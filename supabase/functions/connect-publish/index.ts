// DEMACO — Publica disponibilidad y tarifas a la red YASTA.
// POST (con sesión de usuario Demaco) → toma los tool_models con
// published=true, cuenta unidades disponibles y hace push al webhook
// connect-ingest de YASTA como socio kind='rental'.
//
// Secrets requeridos:
//   YASTA_INGEST_URL  p.ej. https://<ref>.supabase.co/functions/v1/connect-ingest
//   YASTA_API_KEY     api_key del partner "Demaco" creado en YASTA
import { createClient } from "npm:@supabase/supabase-js@2";

const service = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

async function callerOrg(req: Request): Promise<string | null> {
  const auth = req.headers.get("authorization") ?? "";
  const token = auth.replace(/^Bearer\s+/i, "");
  const { data } = await service.auth.getUser(token);
  const uid = data?.user?.id;
  if (!uid) return null;
  const { data: profile } = await service
    .from("profiles")
    .select("organization_id")
    .eq("id", uid)
    .maybeSingle();
  return (profile?.organization_id as string) ?? null;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return Response.json({ error: "POST only" }, { status: 405 });
  }
  const org = await callerOrg(req);
  if (!org) {
    return Response.json({ error: "No autorizado" }, { status: 401 });
  }
  const url = Deno.env.get("YASTA_INGEST_URL");
  const key = Deno.env.get("YASTA_API_KEY");
  if (!url || !key) {
    return Response.json(
      { error: "Configura YASTA_INGEST_URL y YASTA_API_KEY (secrets)" },
      { status: 500 },
    );
  }

  const { data: models } = await service
    .from("tool_models")
    .select("rat_code, supplier_code, name, description, brand, rate_day")
    .eq("organization_id", org)
    .eq("published", true)
    .is("deleted_at", null);
  if (!models || models.length === 0) {
    return Response.json({
      ok: true,
      published: 0,
      note: "Ningún modelo marcado como publicado",
    });
  }

  // Disponibles por modelo.
  const { data: assets } = await service
    .from("assets")
    .select("tool_model_id, status, tool_models!inner(rat_code)")
    .eq("organization_id", org)
    .eq("status", "available")
    .is("deleted_at", null);
  const availByCode = new Map<string, number>();
  for (const a of assets ?? []) {
    const code = (a as Record<string, { rat_code?: string }>)
      .tool_models?.rat_code;
    if (code) availByCode.set(code, (availByCode.get(code) ?? 0) + 1);
  }

  const items = models
    .map((m) => ({ ...m, code: m.rat_code ?? m.supplier_code }))
    .filter((m) => m.code && (m.rate_day ?? 0) > 0)
    .map((m) => ({
      external_id: m.code,
      description:
        `Alquiler ${m.name}${m.brand ? ` ${m.brand}` : ""} (${m.code})`,
      brand: m.brand,
      unit: "día",
      price: m.rate_day,
      is_rental: true,
      stock: availByCode.get(m.code) ?? 0,
    }));

  const res = await fetch(url, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-api-key": key,
    },
    body: JSON.stringify(items),
  });
  const body = await res.json().catch(() => ({}));
  return Response.json(
    res.ok
      ? { ok: true, published: items.length, yasta: body }
      : { ok: false, error: body },
    { status: res.ok ? 200 : 502 },
  );
});

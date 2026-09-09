// DEMACO — Portal de aceptación del contrato de renta (F2b).
//
// El cliente abre contrato.html (bucket público) en su dispositivo;
// esa página consume esta función:
//   GET  ?token=<acceptance_token> → datos del contrato + estado.
//   POST {token, signer_name, signer_id_number, terms, receipt,
//         signature_b64, id_photo_b64?} → guarda firma/cédula en el
//         bucket docs y upserta contract_acceptances.
//
// Pública (--no-verify-jwt): el token uuid ES el secreto del link.
import { createClient } from "npm:@supabase/supabase-js@2";

import { PAGE } from "./page.ts";

const service = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

async function contractByToken(token: string) {
  const { data: c } = await service
    .from("rental_contracts")
    .select(
      "id, organization_id, contract_number, status, pickup_at, start_at, " +
        "due_at, deposit, delivery_method, delivery_fee, site_id, customer_id",
    )
    .eq("acceptance_token", token)
    .is("deleted_at", null)
    .maybeSingle();
  return c;
}

function b64ToBytes(dataUrl: string): { bytes: Uint8Array; mime: string } {
  const m = dataUrl.match(/^data:([^;]+);base64,(.*)$/s);
  const mime = m?.[1] ?? "application/octet-stream";
  const raw = atob(m?.[2] ?? dataUrl);
  const bytes = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) bytes[i] = raw.charCodeAt(i);
  return { bytes, mime };
}

Deno.serve(async (req) => {
  const url = new URL(req.url);

  if (req.method === "GET" && !url.searchParams.has("token")) {
    // Sin ?token= es el navegador del cliente: sirve la página.
    return new Response(PAGE, {
      headers: { "content-type": "text/html; charset=utf-8" },
    });
  }

  if (req.method === "GET") {
    const token = url.searchParams.get("token") ?? "";
    const c = await contractByToken(token);
    if (!c) {
      return Response.json({ error: "Contrato no encontrado" }, {
        status: 404,
      });
    }
    const { data: customer } = await service
      .from("customers")
      .select("name, id_number, phone, email")
      .eq("id", c.customer_id)
      .maybeSingle();
    const { data: site } = c.site_id
      ? await service.from("customer_sites").select("name, address")
        .eq("id", c.site_id).maybeSingle()
      : { data: null };
    const { data: lines } = await service
      .from("rental_lines")
      .select("rate_kind, rate, periods, amount, asset_id, tool_model_id")
      .eq("contract_id", c.id)
      .is("deleted_at", null);
    const items = [];
    for (const l of lines ?? []) {
      const { data: asset } = await service.from("assets")
        .select("asset_tag, brand, mfr_model, serial")
        .eq("id", l.asset_id).maybeSingle();
      const { data: model } = await service.from("tool_models")
        .select("name").eq("id", l.tool_model_id).maybeSingle();
      items.push({
        tag: asset?.asset_tag,
        equipo: model?.name,
        marca: [asset?.brand, asset?.mfr_model].filter(Boolean).join(" "),
        serie: asset?.serial,
        rate_kind: l.rate_kind,
        rate: l.rate,
        periods: l.periods,
        amount: l.amount,
      });
    }
    const { data: acc } = await service.from("contract_acceptances")
      .select(
        "accepted_at, signer_name, signer_id_number, terms_accepted, " +
          "receipt_confirmed, signature_path, id_photo_path",
      )
      .eq("id", c.id).maybeSingle();
    return Response.json({
      contract_number: c.contract_number,
      status: c.status,
      pickup_at: c.start_at ?? c.pickup_at,
      due_at: c.due_at,
      deposit: c.deposit,
      delivery_method: c.delivery_method,
      delivery_fee: c.delivery_fee,
      site,
      customer: {
        name: customer?.name,
        id_number: customer?.id_number,
        registered: !!customer?.id_number,
      },
      items,
      total: items.reduce((s, i) => s + Number(i.amount ?? 0), 0) +
        Number(c.delivery_fee ?? 0),
      acceptance: acc,
    });
  }

  if (req.method === "POST") {
    const body = await req.json().catch(() => null);
    const token = body?.token ?? "";
    const c = await contractByToken(token);
    if (!c) {
      return Response.json({ error: "Contrato no encontrado" }, {
        status: 404,
      });
    }
    const name = (body.signer_name ?? "").trim();
    const idNum = (body.signer_id_number ?? "").trim();
    if (!name || !idNum) {
      return Response.json(
        { error: "Nombre y cédula/RUC son obligatorios" },
        { status: 400 },
      );
    }
    if (body.terms !== true || body.receipt !== true) {
      return Response.json(
        { error: "Debes aceptar los términos y confirmar la recepción" },
        { status: 400 },
      );
    }
    if (!body.signature_b64) {
      return Response.json({ error: "Falta la firma" }, { status: 400 });
    }

    const now = new Date().toISOString();
    const base = `contratos/${c.id}`;
    const sig = b64ToBytes(body.signature_b64 as string);
    const sigPath = `${base}/firma.png`;
    const up1 = await service.storage.from("docs").upload(sigPath, sig.bytes, {
      contentType: sig.mime,
      upsert: true,
    });
    if (up1.error) {
      return Response.json({ error: `Firma: ${up1.error.message}` }, {
        status: 500,
      });
    }
    let idPhotoPath: string | null = null;
    if (body.id_photo_b64) {
      const photo = b64ToBytes(body.id_photo_b64 as string);
      idPhotoPath = `${base}/cedula.jpg`;
      const up2 = await service.storage.from("docs").upload(
        idPhotoPath,
        photo.bytes,
        { contentType: photo.mime, upsert: true },
      );
      if (up2.error) {
        return Response.json({ error: `Cédula: ${up2.error.message}` }, {
          status: 500,
        });
      }
    }

    const { error } = await service.from("contract_acceptances").upsert({
      id: c.id,
      organization_id: c.organization_id,
      contract_id: c.id,
      accepted_at: now,
      signer_name: name,
      signer_id_number: idNum,
      terms_accepted: true,
      receipt_confirmed: true,
      signature_path: sigPath,
      id_photo_path: idPhotoPath,
      updated_at: now,
    });
    if (error) {
      return Response.json({ error: error.message }, { status: 500 });
    }
    // Completa la cédula del cliente si aún no la tenía.
    await service.from("customers")
      .update({ id_number: idNum, updated_at: now })
      .eq("id", c.customer_id)
      .is("id_number", null);
    return Response.json({ ok: true });
  }

  return Response.json({ error: "Método no soportado" }, { status: 405 });
});

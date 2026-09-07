# DEMACO Rent a Tool

Plataforma de alquiler de herramientas de DEMACO (empresa hermana de
YASTA). **Fase 1**: administración del inventario inicial del showroom —
catálogo semilla desde el portafolio, unidades físicas con etiquetas QR,
ubicaciones jerárquicas, capital en herramientas y publicación de
disponibilidad a la red YASTA vía Yasta-Connect.

## Estructura

- `app/` — Flutter (Android/iOS/macOS), offline-first (Drift + cola de
  sync), Riverpod + go_router. Corre 100% local sin credenciales.
- `supabase/` — migraciones (multi-tenant RLS, patrón YASTA) y la Edge
  Function `connect-publish` (push a la red YASTA).
- `seed/` — portafolio fuente (HTML + JSON extraído + especificación).
- `tools/extract_portfolio.py` — regenera `seed/portafolio.json` desde
  el HTML (copiar luego a `app/assets/seed/`).

## Desarrollo

```bash
cd app
flutter test
flutter run                                  # modo solo-local
flutter run --dart-define-from-file=env/dev.json   # con Supabase
```

`env/dev.json` (no commiteado): `{"SUPABASE_URL": "...", "SUPABASE_KEY": "..."}`.

## Reglas de negocio clave

- Tarifas de renta como % del costo: **4 horas 14% · día 20% ·
  semana 70% · mes 200%** (precargadas al importar, editables por
  modelo). Sin costo (=0) → no tarifable.
- Línea **ind** = industrial (DeWalt) · **diy** = económica
  (Craftsman/Stanley). Generadores = SK Power (marca propia).
- `b87_qty` = existencias en la bodega B87 según el maestro
  (informativo; las unidades reales se registran al etiquetar).
- QRs: `demaco:asset:<id>` (unidad) y `demaco:loc:<id>` (ubicación);
  correlativo humano `DEM-0001…` en cada etiqueta.
- Todo cambio de ubicación/estado de una unidad escribe una fila en
  `inventory_movements` (kardex): el asset es la foto, el movimiento
  es la historia.

## Backend (cuando exista el proyecto Supabase)

1. Crear proyecto en supabase.com → `supabase link --project-ref <ref>`
   → `supabase db push`.
2. Crear usuario + organización + perfil (igual que YASTA día 1).
3. `supabase functions deploy connect-publish` y secrets
   `YASTA_INGEST_URL` / `YASTA_API_KEY` (api_key del partner "Demaco"
   kind=rental creado en YASTA Connect).

## Roadmap

F2 contratos de renta (entrega/devolución QR, documental) → F3
facturación SRI + contable → F4 mantenimiento (planes, órdenes de
trabajo, repuestos) → F5 web pública + app cliente → F6 multi-rol →
F7 comunicaciones → F8 NFC/RFID + accesos.

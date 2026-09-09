# DEMACO — Flujo completo de renta (definido por Roberth, 2026-09-09)

El ciclo de vida objetivo de una renta, de la cotización al
re-almacenamiento, y en qué fase del roadmap se construye cada paso.

## El flujo

1. **Cliente acepta** valores monetarios y tiempos de renta.
2. **Cliente lee un QR** impreso en la cotización o da click en un link.
3. Al abrirlo, **acepta digitalmente**: como usuario invitado con los
   datos de su cédula (incluyendo dactilar) o con usuario creado;
   acepta términos y condiciones, confirma recepción de herramienta y
   consumibles, y **firma el contrato digital**.
4. Según su perfil: **cliente crédito** → contrato pasa a cuentas por
   pagar (confirmado por el cliente) · **cliente cash** → se envía link
   de pago o se recibe comprobante.
5. **Entrega confirmada con QR y fotos** del equipo y sus condiciones.
6. Cliente recibe **respaldo documental completo**: contrato firmado,
   factura electrónica, comprobante del depósito de garantía y del
   pago de la renta.
7. **Devolución** — durante el contrato el cliente puede **alargar o
   acortar** la renta, generando saldo a favor o cobro adicional.
8. Empleado registra el ingreso, confirma estado y cumplimiento, y se
   **libera la garantía** + comprobante de cierre.
9. Empleado registra con QR la herramienta y la ubica en
   **mantenimiento o cuarentena** (por almacenar).
10. Se registran **costos de mantenimiento**: mano de obra, repuestos,
    depreciación… (algunos automáticos, otros manuales — el sistema
    solicita o calcula). Se calculan **horas de trabajo** por fórmula o
    horómetro, y se valida si toca **mantenimiento preventivo** según
    los planes.
11. Sale de cuarentena y se asigna a su **ubicación definitiva**.

## Mapeo a fases

| Paso | Fase | Estado |
|---|---|---|
| 1 (tarifas y tiempos) | F2 ✔ | Hecho: tarifa auto por fechas retiro→devolución, o manual sin fechas; retiro en local / envío a obra con costo de transporte; obras múltiples por cliente. |
| 2-3 (QR/link + aceptación + firma) | **F2b portal de aceptación** | Edge Function tipo portal YASTA: página del contrato con T&C, datos de cédula y firma digital. La huella dactilar es dato biométrico sensible — evaluar si basta cédula + firma + selfie (LOPDP Ecuador). |
| 4 (crédito/cash, link de pago, CxP) | F2c + F3b | Campo `credit_terms` en cliente; links de pago requieren pasarela (igual que YASTA F2b); CxP/CxC en el puente contable F3. |
| 5 (entrega QR + fotos) | **F2c evidencias** | Fotos al entregar/recibir adjuntas a la línea (bucket photos), ya previsto como mejora F2. |
| 6 (respaldo + factura electrónica) | F3 SRI | Facturación electrónica vía proveedor autorizado (mismo comparativo Datil/Contifico de YASTA). Envío por email con Resend. |
| 7 (alargar/acortar con saldo) | **F2b extensiones** | Recalcular con `rentalKindForDates` al cambiar due_at en contrato activo (ya funciona); falta registrar el delta como saldo a favor/cobro adicional. |
| 8 (cierre + liberar garantía) | F2c | Estado de garantía (recibida/liberada/retenida parcial) + comprobante PDF de cierre. |
| 9 (cuarentena) | **F4** | Nuevo estado `quarantine` del asset + ubicación de cuarentena. |
| 10 (costos, horómetro, preventivos) | **F4 mantenimiento** | maintenance_orders con costos (mano de obra, repuestos, depreciación auto por fórmula), horas por fórmula u horómetro, maintenance_plans preventivos por familia. |
| 11 (re-almacenamiento) | F4 | Salida de cuarentena → transfer a ubicación definitiva (el kardex ya lo soporta). |

## Orden de construcción propuesto

1. **F2b — Portal de aceptación y firma** (pasos 2, 3, 7): la pieza de
   mayor valor inmediato; reusa el patrón del portal YASTA.
2. **F2c — Evidencias y cierre** (pasos 5, 8): fotos entrega/recepción,
   estados de garantía, comprobante de cierre.
3. **F3 — Facturación SRI + pagos** (pasos 4, 6).
4. **F4 — Cuarentena y mantenimiento** (pasos 9-11).

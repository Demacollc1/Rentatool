# DEMACO — Portafolio de renta de herramientas · Especificación

Documento de referencia para reconstruir el catálogo HTML de renta (`DEMACO_portafolio_oficio.html`) y sus decisiones de negocio y datos. Fecha base de trabajo: 2026.

---

## 1. Contexto del negocio

- **Empresa:** DEMACO — ferretería / distribuidor de herramienta en Ecuador. Distribuidor DeWalt.
- **Proyecto:** montar una línea de **alquiler (tool rental)** de herramientas y equipos.
- **Referencia de mercado:** Casa do Construtor (Brasil, +565 tiendas, franquicia de alquiler). Su catálogo se organiza **por grupo de equipo** y sus kits se dimensionan por **Faixa** (tamaño de tienda / inversión). No manejan gama DIY vs Industrial — eso es un diferenciador de DEMACO.
- **Bodega propia del proyecto:** **B87**. Bodegas de Guayaquil con prioridad de transferencia: **B1, B2, B41** (en ese orden); fuera de esas, cualquier otra.

---

## 2. Fuentes de datos (archivos)

| Archivo | Contenido | Columnas clave |
|---|---|---|
| **Book173.csv** | Maestro de productos (≈31,111 filas) | [1] Número artículo · [2] 3º nº artículo (**código de modelo mostrado**) · [3] Nº corto (interno) · [4] Descripción · [5] Descripción 2 · [10] Código vta3 = **SRP3 (grupo de productos)** · [11] Código vta4 = **marca** |
| **Book171.csv** | Inventario + costo por bodega (≈29,943 filas) | [0] Suc/bodega · [1] Número artículo · [6] Existencias físicas · [13] **Costo Promedio** |
| **Book174–179** | Diccionarios de códigos | 174=Industria(vta1) · 175=Familia(vta2) · **176=Grupo de productos (SRP3/vta3)** · 177=Marca(vta4) · 178=Clase(SBT) · 179=Subgrupo |
| **Book181.csv** | Generadores marca propia SK Power | 3 modelos SK3900/SK6500/SK9000 |
| **Tool_rental_.xlsx** | Asignación teórica oficio → herramienta → consumibles/specs (Hoja2, 8 oficios) | Herramienta · Accesorios y consumibles · Medidas y especificaciones |

**Reglas de lectura confirmadas:**
- El **código mostrado** en cada tarjeta es el **3º nº artículo** (modelo de fábrica: DWE575K, CMCS500B…), no el Nº corto interno.
- La **marca** está en vta4 (SRP4), no en vta3.
- El **nombre completo** de una categoría = Descripción 1 + Descripción 2 unidas.
- Costo para tarifar = **Costo Promedio** (Book171, col 13).

### Códigos SRP3 usados (grupos-máquina)

FDE=Taladros/Atornilladores/Llaves de impacto · FDA=Amoladoras y esmeriladoras · FDC=Martillos de percusión y demoledores · FDD=Sierras y máquinas de corte · FDI=Lijadoras/Tupí/Pulidoras/Rebajadoras · FDF=Compresores y generadores · FDG=Cautines/Pistolas de calor/Sopletes · FDH=Hidrolavadoras/Sopladoras/Aspiradoras · FDN=Mezcladores y vibradores · FIB=Máquinas de soldar · FFG=Herramientas con motor para jardín · FDQ=Clavadoras · FAA/FAC/FAD/FAE/FGx=Consumibles (brocas, discos, bits, lijas).

### Códigos de marca (vta4)

DW=DeWalt (Industrial) · CRF=Craftsman (DIY) · ST=Stanley (DIY) · BD=Black&Decker · MAS/ELT/FUR/LI=marcas de equipo especializado · SK=SK Power (marca propia DEMACO).

---

## 3. Modelo de niveles (DIY vs Industrial)

Cada herramienta se muestra en dos columnas:

- **Industrial = DeWalt (DW).** Criterio de selección: costo mediano entre los disponibles (representativo, no el más caro ni el más barato); se prefiere con stock en B87.
- **DIY = Craftsman (CRF), si no, Stanley (ST).** Criterio: el más económico con stock en B87.
- Excepción marca propia: **generadores = SK Power** (SK3900 entrada / SK9000 industrial).
- Cobertura real: solo ~30% de las herramientas por oficio existen en DeWalt/Craftsman/Stanley (herramienta eléctrica de mano). El equipo pesado y especializado (excavadoras, soldadoras, bombas, concreteras) va en otras marcas o se marca **por definir**.

---

## 4. Modelo de precios de renta

Tarifa como % del **costo del producto**. Estructura vigente (corregida — ver nota):

| Periodo | Tarifa | Sobre costo |
|---|---|---|
| 4 horas | 14% (bloque) | 14% |
| **Día** | **20%** | 20% |
| **Semana** | 3.5× día | **70%** (10%/día × 7) |
| **Mes** | 10× día | **200%** (6.7%/día × 30) |

**Fórmulas en HTML:** día = `costo×0.20` · semana = `costo×0.70` · mes = `costo×2.00`. Recuperación del costo ≈ 5 días de renta efectiva.

> **Corrección aplicada:** la propuesta inicial del usuario (4h=30%, día=20%, semana=15%, mes=10% como *totales* de periodo) es matemáticamente inconsistente (un día saldría más barato que 4 horas; una semana más barata que un día). Benchmark de industria (LendControl, Reservety, Home Depot): herramienta pequeña renta 14–25%/día; semana = 3–4× día; mes = 9–14× día. El card corregido respeta eso. En pantallas/tarifario se usa el card corregido, **no** el 30% invertido.

---

## 5. Estructura del catálogo HTML

### Oficios (11)
CARPINTERÍA · ALBAÑILERÍA · PLOMERÍA · ELECTRICIDAD · PINTURA Y ACABADOS · MOVIMIENTO DE TIERRA/DEMOLICIÓN · SOLDADURA METALMECÁNICA · IMPERMEABILIZACIÓN DE CUBIERTAS · SEGURIDAD INDUSTRIAL · LIMPIEZA · JARDINERÍA.

### Sub-grupos dentro de oficio
Corte y desbaste general (Albañilería) · Destape de cañerías + Bombas de agua (Plomería) · Inspección de fugas (Electricidad) · Acceso y trabajo en altura + EPP (Seguridad).

### Dos vistas (toggle)
- **Por oficio** (comercial, orientado al cliente).
- **Por grupo de equipo** (inventario/compras): Herramientas eléctricas, Demolición y rompedores, Compresores, Generadores, Bombas, Compactación y concreto, Corte de piso y concreto, Limpieza, Jardinería, Soldadura, Acceso y altura, Seguridad/EPP, Medición y diagnóstico, Calor y sellado, Especializada/pesada.

### Estados de fila
- **ok** → tarjeta Industrial + DIY con código, costo y 4 precios (día/semana/mes).
- **pordef** ("por definir") → categoría creada pero sin producto en el maestro (concretera, ranuradora, cámara térmica, subtipos de bomba, transformador de obra, andamio, carretilla motorizada, elevador/tecle, rociadora airless).
- **venta** → EPP que se vende, no se renta (casco, gafas, orejeras, arnés): muestra costo + chip "EPP·venta", sin renta.
- **especializada** → equipo pesado/otra marca fuera de DeWalt/Craftsman/Stanley (oculto por defecto, checkbox para mostrar).

### Inalámbrica vs eléctrica = categorías separadas
Las herramientas con ambas tecnologías se dividen en **dos filas propias** (no como sugerencia): p.ej. "Sierra circular inalámbrica" (DCS575T2 / CMCS500B) y "Sierra circular eléctrica" (DWE575K / CMES500). Aplica a: sierra circular, caladora, ingletadora, taladro/atornillador, amoladora (corte rápido y angular), lijadora, pulidora, router, aspiradora.

### Consumibles con código
Bajo cada herramienta, chips `código · $costo` de consumibles reales del maestro:
- Amoladoras → disco corte `66252843680`, desbaste `N66252842857`, diamantado `N70184607720`
- Taladros → broca concreto `DW530400C`, broca metal `DW170018B`, puntas `DWA3PH1-1L`
- Sierras circular/mesa/ingletadora → disco `DWA271424`
- Caladora → `CMAJ2SET12` · Lijadora → `7508` · Router → `6363`
- Demoledor/rotomartillo → broca SDS-Max `DW5809` · Tronzadora → disco `66252843694`
- Soldadora → electrodo AGA `261240004` · Desbrozadora → nylon `DF080BKP1`

### Disponibilidad
Badge B87 (verde con cantidad si hay stock; "sin B87"; "Importar" si costo n/d). Lógica de acción comprar/transferir: B87 → GYE (B1>B2>B41) → otra bodega → comprar.

---

## 6. Contraste con la franquicia (Casa do Construtor)

Grupos de ellos incorporados o marcados:
- **Limpieza** (hidrolavadora Craftsman CMEPW2400, aspiradora, pulidora de piso) — nuevo oficio.
- **Jardinería** (desbrozadora Craftsman CMCST900D1, motosierra, soplador) — nuevo oficio.
- **Betoneira/concretera, Bomba sumergible, Painéis/andamio, Transformador** — marcados por definir.
- **Consumibles ligados a cada equipo** — reintegrados (ellos los venden como grupo "Acessórios").
- Su "Faixa" (dimensionar cuántas unidades por tamaño de tienda) es un modelo a usar al decidir el stock inicial de compra.

---

## 7. Decisiones / convenciones registradas

- Códigos inalámbricos DeWalt: sufijo **B** = bare tool (sin batería); C/D/X/P = nivel de amperaje de batería (D=2.0Ah, P=5.0Ah XR); dígito 1/2 = cantidad de baterías. Para renta, bare tool es adecuado (baterías como pool aparte).
- **Contratipos:** DEMACO trae el equivalente, no el modelo de la competencia (ej. DCD996↔DCD805).
- **6HD… = códigos de Gerardo Ortiz (GO)**, distribuidor DeWalt Ecuador — NO son códigos de fábrica.
- El maestro usa **UWO** (watts out), no torque en Nm, para percutores. Torque(Nm) y amperaje(Ah) no son campos duros del maestro (Ah se infiere del sufijo).
- No mezclar producto inalámbrico con cableado como equivalentes (son categorías distintas).
- "Taladro de impacto" = como DEMACO llama al atornillador de impacto.

---

## 8. Pendientes / gaps de datos

1. **Costos en $0** (no tarifables aún): generadores SK Power, bombas de agua (todas), aspiradoras DeWalt, roscadora DeWalt.
2. **Sin producto en maestro:** concretera, ranuradora, cámara termográfica, transformador de obra, andamio modular, carretilla motorizada, elevador/tecle, rociadora airless.
3. **Marca para equipo pesado** (soldadoras, bombas, concreteras) — definir línea a distribuir/importar.
4. **Cadena/espada de motosierra** — sin código limpio en el maestro.
5. **EPP** — decidir si se vende (actual) o se renta con tarifa.
6. Revisar pick del "taladro inalámbrico" (cayó en DCF620 drywall por excluir percutor).

---

## 9. Reproducción técnica del HTML

- Single-file HTML (dark, vanilla JS, sin dependencias externas salvo fuentes Google).
- Datos embebidos como `const DATA = {oficio: [ {tool, spec, ind, diy, status, sub, grupo, cons_codes[], cons} ] }`.
- `ind`/`diy` = `{code, desc, cost, b87, brand, n}`. Precios calculados en cliente (día/semana/mes).
- Controles: toggle oficio/grupo, filtro por categoría (chips), buscador, checkbox mostrar especializadas.
- Validar sin errores JS (render en Chromium headless / node) antes de entregar.

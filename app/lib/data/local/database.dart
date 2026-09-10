import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Columnas comunes a toda tabla sincronizable, espejo del esquema de
/// Supabase: id uuid generado en el cliente, updated_at para
/// last-write-wins y deleted_at para borrado suave.
mixin SyncColumns on Table {
  TextColumn get id => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Categorías 2 niveles: 0 = oficio · 1 = grupo de equipo.
class Categories extends Table with SyncColumns {
  TextColumn get parentId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get level => integer().withDefault(const Constant(0))();
}

/// Ubicaciones jerárquicas, hasta 5 niveles:
/// 0 Showroom/Bodega · 1 Área · 2 Repisa · 3 Nivel · 4 Contenedor.
class Locations extends Table with SyncColumns {
  TextColumn get parentId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get level => integer().withDefault(const Constant(0))();
}

/// Proveedores de equipos y consumibles (con RUC).
class Suppliers extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get ruc => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Modelo de herramienta del catálogo (una fila por línea ind/diy).
class ToolModels extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get spec => text().nullable()();

  /// ind = industrial (DeWalt) · diy = económica (Craftsman/Stanley).
  TextColumn get line => text().withDefault(const Constant('ind'))();
  TextColumn get brand => text().nullable()();
  TextColumn get supplierCode => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text().nullable()(); // grupo (padre=oficio)
  RealColumn get listCost => real().withDefault(const Constant(0))();

  /// Tarifas de renta (precarga 14%/20%/70%/200% del costo, editables).
  RealColumn get rateHalfDay => real().nullable()(); // bloque 4-5 h
  RealColumn get rateDay => real().nullable()();
  RealColumn get rateWeek => real().nullable()();
  RealColumn get rateMonth => real().nullable()();

  /// Existencias en la bodega B87 según el maestro (informativo).
  RealColumn get b87Qty => real().withDefault(const Constant(0))();

  /// Se publica a la red YASTA vía Connect.
  BoolColumn get published => boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// Código propio Rent a Tool: canónico + secuencial (ej. AAQ-003).
  TextColumn get ratCode => text().nullable()();

  /// Subgrupo canónico del ERP Demaco (ej. AAQ) y su nombre completo.
  TextColumn get canonicalCode => text().nullable()();
  TextColumn get canonicalName => text().nullable()();

  /// Variación dentro del mismo producto (ej. "kit 2 baterías").
  TextColumn get variant => text().nullable()();
  TextColumn get supplierId => text().nullable()();
}

/// Unidad física rentable (un equipo concreto con etiqueta QR).
class Assets extends Table with SyncColumns {
  TextColumn get toolModelId => text()();

  /// Correlativo humano impreso en la etiqueta: DEM-0001…
  TextColumn get assetTag => text()();
  TextColumn get serial => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('available'))();
  TextColumn get condition => text().withDefault(const Constant('new'))();
  TextColumn get locationId => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  RealColumn get purchaseCost => real().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();

  /// Compra: proveedor y número de factura.
  TextColumn get supplierId => text().nullable()();
  TextColumn get invoiceNumber => text().nullable()();

  /// Fabricante de ESTA unidad (el producto es genérico por specs;
  /// dos unidades del mismo producto pueden ser de marcas distintas).
  TextColumn get brand => text().nullable()();
  TextColumn get mfrModel => text().nullable()();

  /// Link a la ficha técnica del modelo de esta unidad.
  TextColumn get datasheetUrl => text().nullable()();

  /// Foto de la unidad: remota (photos, carpeta de la org) y locales
  /// (patrón de los íconos de canónicos: sube en el sync).
  TextColumn get photoPath => text().nullable()();
  TextColumn get photoLocalPath => text().nullable()();
  DateTimeColumn get photoUploadedAt => dateTime().nullable()();
}

/// Consumibles y accesorios (stock por cantidad).
class Consumables extends Table with SyncColumns {
  TextColumn get code => text().nullable()();
  TextColumn get name => text()();
  TextColumn get unit => text().withDefault(const Constant('u'))();
  RealColumn get cost => real().withDefault(const Constant(0))();
  RealColumn get salePrice => real().withDefault(const Constant(0))();
  RealColumn get stock => real().withDefault(const Constant(0))();
  RealColumn get minStock => real().withDefault(const Constant(0))();
  TextColumn get locationId => text().nullable()();
  TextColumn get canonicalCode => text().nullable()();
  TextColumn get supplierId => text().nullable()();
}

/// Canónicos (subgrupos del ERP + los propios): familia y prefijo de
/// código. La semilla del ERP se carga con ids determinísticos.
class Canonicals extends Table with SyncColumns {
  TextColumn get code => text()();
  TextColumn get name => text()();

  /// Ícono: ruta remota (la pone el sync al subir) y locales.
  TextColumn get iconPath => text().nullable()();
  TextColumn get iconLocalPath => text().nullable()();
  DateTimeColumn get iconUploadedAt => dateTime().nullable()();
}

/// Plantilla de atributos de una familia (canónico): QUÉ importa.
class CanonicalAttributes extends Table with SyncColumns {
  TextColumn get canonicalCode => text()();
  TextColumn get name => text()(); // "Potencia (W)", "Disco (mm)"
  IntColumn get position => integer().withDefault(const Constant(0))();
}

/// Valores mínimos del producto: lo que un modelo alternativo debe
/// cumplir para pertenecer a este código RAT.
class ToolModelAttributes extends Table with SyncColumns {
  TextColumn get toolModelId => text()();
  TextColumn get name => text()();
  TextColumn get value => text()(); // "1400-1500 W", ">=115 mm"
  IntColumn get position => integer().withDefault(const Constant(0))();
}

/// n:m producto ↔ categoría (un producto puede estar en varios
/// oficios; category_id del modelo queda como principal).
class ToolModelCategories extends Table with SyncColumns {
  TextColumn get toolModelId => text()();
  TextColumn get categoryId => text()();
}

/// n:m modelo ↔ consumible. kind: incluido (va amarrado al rentar)
/// u opcional (se ofrece); extra_price = costo adicional si aplica.
class ToolModelConsumables extends Table with SyncColumns {
  TextColumn get toolModelId => text()();
  TextColumn get consumableId => text()();
  TextColumn get kind => text().withDefault(const Constant('incluido'))();
  RealColumn get extraPrice => real().withDefault(const Constant(0))();
}

/// Consumibles/accesorios dentro de un contrato de renta.
class ContractConsumables extends Table with SyncColumns {
  TextColumn get contractId => text()();
  TextColumn get lineId => text().nullable()();
  TextColumn get consumableId => text()();
  TextColumn get kind => text().withDefault(const Constant('incluido'))();
  RealColumn get qty => real().withDefault(const Constant(1))();
  RealColumn get price => real().withDefault(const Constant(0))();
  RealColumn get amount => real().withDefault(const Constant(0))();
}

/// Addendum del contrato: extensión/modificación de fechas con
/// historial (nunca se sobreescribe en silencio).
class ContractAddendums extends Table with SyncColumns {
  TextColumn get contractId => text()();
  TextColumn get kind =>
      text().withDefault(const Constant('extension'))();
  DateTimeColumn get oldPickupAt => dateTime().nullable()();
  DateTimeColumn get newPickupAt => dateTime().nullable()();
  DateTimeColumn get oldDueAt => dateTime().nullable()();
  DateTimeColumn get newDueAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Kardex: la historia de todo movimiento de activos y consumibles.
class InventoryMovements extends Table with SyncColumns {
  TextColumn get assetId => text().nullable()();
  TextColumn get consumableId => text().nullable()();

  /// intake | transfer | rent_out | rent_return | maintenance_out |
  /// maintenance_return | adjust | retire | consume | restock
  TextColumn get kind => text()();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  TextColumn get fromLocationId => text().nullable()();
  TextColumn get toLocationId => text().nullable()();
  TextColumn get contractRef => text().nullable()();
  DateTimeColumn get movedAt => dateTime()();
  TextColumn get createdBy => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Cliente de renta. name = nombre legal; tradeName = comercial.
/// kind: maestro | constructora | diyer | mantenimiento | obra_eventual.
class Customers extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get tradeName => text().nullable()();
  TextColumn get kind => text().nullable()();

  /// nuevo (100% garantía) · frecuente (50%) · con_contrato (30%).
  TextColumn get qualification =>
      text().withDefault(const Constant('nuevo'))();
  TextColumn get idNumber => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Códigos postales INTERNOS de DEMACO: código → ciudad y parroquia.
class PostalCodes extends Table with SyncColumns {
  TextColumn get code => text()();
  TextColumn get city => text()();
  TextColumn get parish => text().nullable()();
}

/// Obra/proyecto del cliente: dónde estará la herramienta rentada.
/// Un cliente puede tener varias obras.
class CustomerSites extends Table with SyncColumns {
  TextColumn get customerId => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();

  /// Código postal interno DEMACO (ver PostalCodes).
  TextColumn get postalCode => text().nullable()();
  RealColumn get gpsLat => real().nullable()();
  RealColumn get gpsLng => real().nullable()();
  TextColumn get contactName => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  TextColumn get contactEmail => text().nullable()();

  /// Nº de orden de compra o documento de solicitud del cliente.
  TextColumn get purchaseOrder => text().nullable()();

  /// credito | prepago.
  TextColumn get paymentMethod =>
      text().withDefault(const Constant('prepago'))();
  TextColumn get notes => text().nullable()();
}

/// Responsable de la herramienta por parte del cliente, en una obra.
class SiteContacts extends Table with SyncColumns {
  TextColumn get siteId => text()();
  TextColumn get name => text()();
  TextColumn get idNumber => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Contrato de renta: draft → active (entregado) → closed (devuelto).
class RentalContracts extends Table with SyncColumns {
  /// Correlativo humano: CTR-0001…
  TextColumn get contractNumber => text()();
  TextColumn get customerId => text()();
  TextColumn get status => text().withDefault(const Constant('draft'))();

  /// Fecha de retiro PACTADA (para calcular la tarifa por fechas).
  DateTimeColumn get pickupAt => dateTime().nullable()();

  /// Momento real de la entrega (manda sobre pickupAt si existe).
  DateTimeColumn get startAt => dateTime().nullable()();
  DateTimeColumn get dueAt => dateTime().nullable()();
  DateTimeColumn get returnedAt => dateTime().nullable()();

  /// Garantía recibida (se devuelve al cierre).
  RealColumn get deposit => real().withDefault(const Constant(0))();

  /// pickup = retiro en el local · delivery = envío por transporte.
  TextColumn get deliveryMethod =>
      text().withDefault(const Constant('pickup'))();

  /// Obra del cliente donde estará la herramienta.
  TextColumn get siteId => text().nullable()();

  /// Responsable de la herramienta por parte del cliente (en la obra).
  TextColumn get contactId => text().nullable()();
  RealColumn get deliveryFee => real().withDefault(const Constant(0))();

  /// Secreto del link público del portal de aceptación (F2b).
  TextColumn get acceptanceToken => text().nullable()();

  /// La garantía es obligatoria por defecto; se desactiva solo para
  /// clientes calificados. deposit_manual = monto editado a mano.
  BoolColumn get depositRequired =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get depositManual =>
      boolean().withDefault(const Constant(false))();

  /// Ciclo de la garantía: se libera (o retiene) al cierre.
  DateTimeColumn get depositReleasedAt => dateTime().nullable()();
  RealColumn get depositRetained =>
      real().withDefault(const Constant(0))();
  TextColumn get depositNotes => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text().nullable()();
}

/// Foto de evidencia del estado del equipo al entregar o recibir.
/// localPath/uploadedAt son solo locales (patrón de íconos): el
/// archivo sube al bucket docs en el próximo sync.
class RentalLinePhotos extends Table with SyncColumns {
  /// Foto de una línea (lineId) o del contrato (contractId).
  TextColumn get lineId => text().nullable()();
  TextColumn get contractId => text().nullable()();

  /// delivery = al entregar · return = al recibir.
  TextColumn get kind => text()();
  TextColumn get photoPath => text().nullable()(); // ruta remota (docs)
  TextColumn get localPath => text().nullable()();
  DateTimeColumn get uploadedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Aceptación documental del cliente (la escribe SOLO la Edge Function
/// contract-portal; el app la lee vía pull — nunca la encola).
class ContractAcceptances extends Table with SyncColumns {
  TextColumn get contractId => text()();
  DateTimeColumn get acceptedAt => dateTime().nullable()();
  TextColumn get signerName => text().nullable()();
  TextColumn get signerIdNumber => text().nullable()();
  BoolColumn get termsAccepted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get receiptConfirmed =>
      boolean().withDefault(const Constant(false))();
  TextColumn get signaturePath => text().nullable()();
  TextColumn get idPhotoPath => text().nullable()();
}

/// Línea del contrato: una unidad física con su tarifa y períodos.
class RentalLines extends Table with SyncColumns {
  TextColumn get contractId => text()();
  TextColumn get assetId => text()();
  TextColumn get toolModelId => text()();

  /// half_day (bloque 4-5h) | day | week | month.
  TextColumn get rateKind => text().withDefault(const Constant('day'))();
  RealColumn get rate => real().withDefault(const Constant(0))();
  RealColumn get periods => real().withDefault(const Constant(1))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
  DateTimeColumn get returnedAt => dateTime().nullable()();
  TextColumn get conditionOut => text().nullable()();
  TextColumn get conditionIn => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Cola de sincronización de subida.
class SyncQueue extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get tableRef => text()();
  TextColumn get rowId => text()();
  TextColumn get op => text()();
  TextColumn get payload => text()();
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Estado clave-valor del sync (cursores de pull, org cacheada…).
class SyncState extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [
  Categories,
  Locations,
  Suppliers,
  Canonicals,
  ToolModels,
  CanonicalAttributes,
  ToolModelAttributes,
  ToolModelCategories,
  Assets,
  Consumables,
  ToolModelConsumables,
  InventoryMovements,
  Customers,
  PostalCodes,
  CustomerSites,
  SiteContacts,
  RentalContracts,
  RentalLines,
  RentalLinePhotos,
  ContractConsumables,
  ContractAddendums,
  ContractAcceptances,
  SyncQueue,
  SyncState,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 17; // v16 foto unidad · v17 reglas de renta

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          await m.createAll();
          if (from < 2) {
            await m.addColumn(toolModels, toolModels.ratCode);
            await m.addColumn(toolModels, toolModels.canonicalCode);
            await m.addColumn(toolModels, toolModels.canonicalName);
            await m.addColumn(toolModels, toolModels.variant);
            await m.addColumn(toolModels, toolModels.supplierId);
            await m.addColumn(assets, assets.supplierId);
            await m.addColumn(assets, assets.invoiceNumber);
            await m.addColumn(consumables, consumables.canonicalCode);
            await m.addColumn(consumables, consumables.supplierId);
          }
          if (from < 3) {
            await m.addColumn(assets, assets.brand);
            await m.addColumn(assets, assets.mfrModel);
          }
          // v4/v5/v7: createAll de arriba crea las tablas nuevas.
          if (from < 8 && from >= 3) {
            await m.addColumn(assets, assets.datasheetUrl);
          }
          if (from == 5) {
            await m.addColumn(canonicals, canonicals.iconPath);
            await m.addColumn(canonicals, canonicals.iconLocalPath);
            await m.addColumn(canonicals, canonicals.iconUploadedAt);
          }
          if (from == 9) {
            await m.addColumn(
                rentalContracts, rentalContracts.deliveryMethod);
            await m.addColumn(rentalContracts, rentalContracts.siteId);
            await m.addColumn(
                rentalContracts, rentalContracts.deliveryFee);
          }
          if (from >= 9 && from < 11) {
            await m.addColumn(rentalContracts, rentalContracts.pickupAt);
          }
          if (from >= 9 && from < 12) {
            await m.addColumn(
                rentalContracts, rentalContracts.acceptanceToken);
          }
          if (from >= 9 && from < 13) {
            await m.addColumn(rentalContracts, rentalContracts.contactId);
          }
          if (from < 16) {
            await m.addColumn(assets, assets.photoPath);
            await m.addColumn(assets, assets.photoLocalPath);
            await m.addColumn(assets, assets.photoUploadedAt);
          }
          if (from < 17) {
            await m.addColumn(
                toolModelConsumables, toolModelConsumables.kind);
            await m.addColumn(toolModelConsumables,
                toolModelConsumables.extraPrice);
          }
          if (from >= 9 && from < 17) {
            await m.addColumn(customers, customers.qualification);
            await m.addColumn(
                rentalContracts, rentalContracts.depositRequired);
            await m.addColumn(
                rentalContracts, rentalContracts.depositManual);
          }
          if (from >= 15 && from < 17) {
            await m.addColumn(
                rentalLinePhotos, rentalLinePhotos.contractId);
          }
          if (from >= 9 && from < 15) {
            await m.addColumn(
                rentalContracts, rentalContracts.depositReleasedAt);
            await m.addColumn(
                rentalContracts, rentalContracts.depositRetained);
            await m.addColumn(
                rentalContracts, rentalContracts.depositNotes);
          }
          if (from >= 9 && from < 14) {
            await m.addColumn(customers, customers.tradeName);
            await m.addColumn(customers, customers.kind);
            await m.addColumn(customerSites, customerSites.postalCode);
            await m.addColumn(customerSites, customerSites.gpsLat);
            await m.addColumn(customerSites, customerSites.gpsLng);
            await m.addColumn(
                customerSites, customerSites.contactEmail);
            await m.addColumn(
                customerSites, customerSites.purchaseOrder);
            await m.addColumn(
                customerSites, customerSites.paymentMethod);
          }
        },
      );

  static LazyDatabase _open() => LazyDatabase(() async {
        final dir = await getApplicationDocumentsDirectory();
        return NativeDatabase.createInBackground(
            File(p.join(dir.path, 'demaco.sqlite')));
      });
}

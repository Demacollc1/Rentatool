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

/// n:m modelo ↔ consumible (el mismo disco sirve a varias sierras).
class ToolModelConsumables extends Table with SyncColumns {
  TextColumn get toolModelId => text()();
  TextColumn get consumableId => text()();
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

/// Cliente de renta (persona o empresa, con cédula/RUC).
class Customers extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get idNumber => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Obra/proyecto del cliente: dónde estará la herramienta rentada.
/// Un cliente puede tener varias obras.
class CustomerSites extends Table with SyncColumns {
  TextColumn get customerId => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get contactName => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
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

  /// Obra del cliente donde estará la herramienta (si es envío).
  TextColumn get siteId => text().nullable()();
  RealColumn get deliveryFee => real().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text().nullable()();
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
  CustomerSites,
  RentalContracts,
  RentalLines,
  SyncQueue,
  SyncState,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 11; // v9 contratos · v10 obras · v11 retiro

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
        },
      );

  static LazyDatabase _open() => LazyDatabase(() async {
        final dir = await getApplicationDocumentsDirectory();
        return NativeDatabase.createInBackground(
            File(p.join(dir.path, 'demaco.sqlite')));
      });
}

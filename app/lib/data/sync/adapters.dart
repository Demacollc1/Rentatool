import 'package:drift/drift.dart';

import '../local/database.dart';
import 'sync_service.dart';

double _d(dynamic v) => (v as num?)?.toDouble() ?? 0;
double? _dN(dynamic v) => (v as num?)?.toDouble();

/// Adapters de sincronización en ORDEN de dependencias (padres antes
/// que hijos). Este orden también gobierna el push de la cola.
List<TableSyncAdapter> buildSyncAdapters() => [
      TableSyncAdapter(
        remoteTable: 'categories',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.categories)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.categories).insertOnConflictUpdate(
                CategoriesCompanion(
                  id: Value(r['id'] as String),
                  parentId: Value(r['parent_id'] as String?),
                  name: Value(r['name'] as String),
                  level: Value((r['level'] as num?)?.toInt() ?? 0),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'locations',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.locations)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.locations).insertOnConflictUpdate(
                LocationsCompanion(
                  id: Value(r['id'] as String),
                  parentId: Value(r['parent_id'] as String?),
                  name: Value(r['name'] as String),
                  level: Value((r['level'] as num?)?.toInt() ?? 0),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'suppliers',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.suppliers)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.suppliers).insertOnConflictUpdate(
                SuppliersCompanion(
                  id: Value(r['id'] as String),
                  name: Value(r['name'] as String),
                  ruc: Value(r['ruc'] as String?),
                  phone: Value(r['phone'] as String?),
                  email: Value(r['email'] as String?),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'tool_models',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.toolModels)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.toolModels).insertOnConflictUpdate(
                ToolModelsCompanion(
                  id: Value(r['id'] as String),
                  name: Value(r['name'] as String),
                  spec: Value(r['spec'] as String?),
                  line: Value((r['line'] ?? 'ind') as String),
                  brand: Value(r['brand'] as String?),
                  supplierCode: Value(r['supplier_code'] as String?),
                  description: Value(r['description'] as String?),
                  categoryId: Value(r['category_id'] as String?),
                  listCost: Value(_d(r['list_cost'])),
                  rateHalfDay: Value(_dN(r['rate_half_day'])),
                  rateDay: Value(_dN(r['rate_day'])),
                  rateWeek: Value(_dN(r['rate_week'])),
                  rateMonth: Value(_dN(r['rate_month'])),
                  b87Qty: Value(_d(r['b87_qty'])),
                  published: Value((r['published'] ?? false) as bool),
                  photoPath: Value(r['photo_path'] as String?),
                  notes: Value(r['notes'] as String?),
                  ratCode: Value(r['rat_code'] as String?),
                  canonicalCode: Value(r['canonical_code'] as String?),
                  canonicalName: Value(r['canonical_name'] as String?),
                  variant: Value(r['variant'] as String?),
                  supplierId: Value(r['supplier_id'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'canonical_attributes',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.canonicalAttributes)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.canonicalAttributes).insertOnConflictUpdate(
                CanonicalAttributesCompanion(
                  id: Value(r['id'] as String),
                  canonicalCode: Value(r['canonical_code'] as String),
                  name: Value(r['name'] as String),
                  position:
                      Value((r['position'] as num?)?.toInt() ?? 0),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'tool_model_attributes',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.toolModelAttributes)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.toolModelAttributes).insertOnConflictUpdate(
                ToolModelAttributesCompanion(
                  id: Value(r['id'] as String),
                  toolModelId: Value(r['tool_model_id'] as String),
                  name: Value(r['name'] as String),
                  value: Value(r['value'] as String),
                  position:
                      Value((r['position'] as num?)?.toInt() ?? 0),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'consumables',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.consumables)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.consumables).insertOnConflictUpdate(
                ConsumablesCompanion(
                  id: Value(r['id'] as String),
                  code: Value(r['code'] as String?),
                  name: Value(r['name'] as String),
                  unit: Value((r['unit'] ?? 'u') as String),
                  cost: Value(_d(r['cost'])),
                  salePrice: Value(_d(r['sale_price'])),
                  stock: Value(_d(r['stock'])),
                  minStock: Value(_d(r['min_stock'])),
                  locationId: Value(r['location_id'] as String?),
                  canonicalCode: Value(r['canonical_code'] as String?),
                  supplierId: Value(r['supplier_id'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'tool_model_consumables',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.toolModelConsumables)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.toolModelConsumables).insertOnConflictUpdate(
                ToolModelConsumablesCompanion(
                  id: Value(r['id'] as String),
                  toolModelId: Value(r['tool_model_id'] as String),
                  consumableId: Value(r['consumable_id'] as String),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'assets',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.assets)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.assets).insertOnConflictUpdate(
                AssetsCompanion(
                  id: Value(r['id'] as String),
                  toolModelId: Value(r['tool_model_id'] as String),
                  assetTag: Value(r['asset_tag'] as String),
                  serial: Value(r['serial'] as String?),
                  status: Value((r['status'] ?? 'available') as String),
                  condition: Value((r['condition'] ?? 'new') as String),
                  locationId: Value(r['location_id'] as String?),
                  purchaseDate: Value(tsN(r['purchase_date'])),
                  purchaseCost: Value(_d(r['purchase_cost'])),
                  notes: Value(r['notes'] as String?),
                  supplierId: Value(r['supplier_id'] as String?),
                  invoiceNumber: Value(r['invoice_number'] as String?),
                  brand: Value(r['brand'] as String?),
                  mfrModel: Value(r['mfr_model'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'inventory_movements',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.inventoryMovements)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.inventoryMovements).insertOnConflictUpdate(
                InventoryMovementsCompanion(
                  id: Value(r['id'] as String),
                  assetId: Value(r['asset_id'] as String?),
                  consumableId: Value(r['consumable_id'] as String?),
                  kind: Value(r['kind'] as String),
                  quantity: Value(_d(r['quantity'])),
                  fromLocationId: Value(r['from_location_id'] as String?),
                  toLocationId: Value(r['to_location_id'] as String?),
                  contractRef: Value(r['contract_ref'] as String?),
                  movedAt: Value(ts(r['moved_at'])),
                  createdBy: Value(r['created_by'] as String?),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
    ];

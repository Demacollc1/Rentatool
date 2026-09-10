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
        remoteTable: 'canonicals',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.canonicals)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.canonicals).insertOnConflictUpdate(
                CanonicalsCompanion(
                  id: Value(r['id'] as String),
                  code: Value(r['code'] as String),
                  name: Value(r['name'] as String),
                  iconPath: Value(r['icon_path'] as String?),
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
        remoteTable: 'tool_model_categories',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.toolModelCategories)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.toolModelCategories).insertOnConflictUpdate(
                ToolModelCategoriesCompanion(
                  id: Value(r['id'] as String),
                  toolModelId: Value(r['tool_model_id'] as String),
                  categoryId: Value(r['category_id'] as String),
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
                  kind: Value((r['kind'] ?? 'incluido') as String),
                  extraPrice: Value(_d(r['extra_price'])),
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
                  datasheetUrl: Value(r['datasheet_url'] as String?),
                  photoPath: Value(r['photo_path'] as String?),
                  // Los campos locales de la foto se conservan.
                  photoLocalPath: Value(local?.photoLocalPath),
                  photoUploadedAt: Value(local?.photoUploadedAt),
                  hoursMeter: Value(_d(r['hours_meter'])),
                  lastMaintenanceAt:
                      Value(tsN(r['last_maintenance_at'])),
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
      TableSyncAdapter(
        remoteTable: 'maintenance_orders',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.maintenanceOrders)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.maintenanceOrders).insertOnConflictUpdate(
                MaintenanceOrdersCompanion(
                  id: Value(r['id'] as String),
                  assetId: Value(r['asset_id'] as String),
                  kind: Value((r['kind'] ?? 'revision') as String),
                  status: Value((r['status'] ?? 'open') as String),
                  contractRef: Value(r['contract_ref'] as String?),
                  openedAt: Value(ts(r['opened_at'])),
                  closedAt: Value(tsN(r['closed_at'])),
                  hoursMeter: Value(_dN(r['hours_meter'])),
                  laborCost: Value(_d(r['labor_cost'])),
                  partsCost: Value(_d(r['parts_cost'])),
                  otherCost: Value(_d(r['other_cost'])),
                  depreciationCost:
                      Value(_d(r['depreciation_cost'])),
                  totalCost: Value(_d(r['total_cost'])),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'maintenance_plans',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.maintenancePlans)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.maintenancePlans).insertOnConflictUpdate(
                MaintenancePlansCompanion(
                  id: Value(r['id'] as String),
                  toolModelId: Value(r['tool_model_id'] as String),
                  name: Value(r['name'] as String),
                  everyDays:
                      Value((r['every_days'] as num?)?.toInt()),
                  everyHours: Value(_dN(r['every_hours'])),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'customers',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.customers)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.customers).insertOnConflictUpdate(
                CustomersCompanion(
                  id: Value(r['id'] as String),
                  name: Value(r['name'] as String),
                  tradeName: Value(r['trade_name'] as String?),
                  kind: Value(r['kind'] as String?),
                  qualification:
                      Value((r['qualification'] ?? 'nuevo') as String),
                  idNumber: Value(r['id_number'] as String?),
                  phone: Value(r['phone'] as String?),
                  email: Value(r['email'] as String?),
                  address: Value(r['address'] as String?),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'postal_codes',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.postalCodes)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.postalCodes).insertOnConflictUpdate(
                PostalCodesCompanion(
                  id: Value(r['id'] as String),
                  code: Value(r['code'] as String),
                  city: Value(r['city'] as String),
                  parish: Value(r['parish'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'customer_sites',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.customerSites)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.customerSites).insertOnConflictUpdate(
                CustomerSitesCompanion(
                  id: Value(r['id'] as String),
                  customerId: Value(r['customer_id'] as String),
                  name: Value(r['name'] as String),
                  address: Value(r['address'] as String?),
                  postalCode: Value(r['postal_code'] as String?),
                  gpsLat: Value(_dN(r['gps_lat'])),
                  gpsLng: Value(_dN(r['gps_lng'])),
                  contactName: Value(r['contact_name'] as String?),
                  contactPhone: Value(r['contact_phone'] as String?),
                  contactEmail: Value(r['contact_email'] as String?),
                  purchaseOrder: Value(r['purchase_order'] as String?),
                  paymentMethod:
                      Value((r['payment_method'] ?? 'prepago') as String),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'site_contacts',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.siteContacts)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.siteContacts).insertOnConflictUpdate(
                SiteContactsCompanion(
                  id: Value(r['id'] as String),
                  siteId: Value(r['site_id'] as String),
                  name: Value(r['name'] as String),
                  idNumber: Value(r['id_number'] as String?),
                  phone: Value(r['phone'] as String?),
                  role: Value(r['role'] as String?),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'rental_contracts',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.rentalContracts)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.rentalContracts).insertOnConflictUpdate(
                RentalContractsCompanion(
                  id: Value(r['id'] as String),
                  contractNumber: Value(r['contract_number'] as String),
                  customerId: Value(r['customer_id'] as String),
                  status: Value((r['status'] ?? 'draft') as String),
                  pickupAt: Value(tsN(r['pickup_at'])),
                  startAt: Value(tsN(r['start_at'])),
                  dueAt: Value(tsN(r['due_at'])),
                  returnedAt: Value(tsN(r['returned_at'])),
                  deposit: Value(_d(r['deposit'])),
                  deliveryMethod:
                      Value((r['delivery_method'] ?? 'pickup') as String),
                  siteId: Value(r['site_id'] as String?),
                  contactId: Value(r['contact_id'] as String?),
                  deliveryFee: Value(_d(r['delivery_fee'])),
                  acceptanceToken:
                      Value(r['acceptance_token'] as String?),
                  depositRequired:
                      Value((r['deposit_required'] ?? true) as bool),
                  depositManual:
                      Value((r['deposit_manual'] ?? false) as bool),
                  depositReleasedAt:
                      Value(tsN(r['deposit_released_at'])),
                  depositRetained: Value(_d(r['deposit_retained'])),
                  depositNotes: Value(r['deposit_notes'] as String?),
                  notes: Value(r['notes'] as String?),
                  createdBy: Value(r['created_by'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'contract_consumables',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.contractConsumables)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.contractConsumables).insertOnConflictUpdate(
                ContractConsumablesCompanion(
                  id: Value(r['id'] as String),
                  contractId: Value(r['contract_id'] as String),
                  lineId: Value(r['line_id'] as String?),
                  consumableId: Value(r['consumable_id'] as String),
                  kind: Value((r['kind'] ?? 'incluido') as String),
                  qty: Value(_d(r['qty'])),
                  price: Value(_d(r['price'])),
                  amount: Value(_d(r['amount'])),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'contract_addendums',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.contractAddendums)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.contractAddendums).insertOnConflictUpdate(
                ContractAddendumsCompanion(
                  id: Value(r['id'] as String),
                  contractId: Value(r['contract_id'] as String),
                  kind: Value((r['kind'] ?? 'extension') as String),
                  oldPickupAt: Value(tsN(r['old_pickup_at'])),
                  newPickupAt: Value(tsN(r['new_pickup_at'])),
                  oldDueAt: Value(tsN(r['old_due_at'])),
                  newDueAt: Value(tsN(r['new_due_at'])),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'rental_line_photos',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.rentalLinePhotos)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.rentalLinePhotos).insertOnConflictUpdate(
                RentalLinePhotosCompanion(
                  id: Value(r['id'] as String),
                  lineId: Value(r['line_id'] as String?),
                  contractId: Value(r['contract_id'] as String?),
                  kind: Value(r['kind'] as String),
                  photoPath: Value(r['photo_path'] as String?),
                  // localPath/uploadedAt se conservan si existen.
                  localPath: Value(local?.localPath),
                  uploadedAt: Value(local?.uploadedAt),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'contract_acceptances',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.contractAcceptances)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.contractAcceptances).insertOnConflictUpdate(
                ContractAcceptancesCompanion(
                  id: Value(r['id'] as String),
                  contractId: Value(r['contract_id'] as String),
                  acceptedAt: Value(tsN(r['accepted_at'])),
                  signerName: Value(r['signer_name'] as String?),
                  signerIdNumber:
                      Value(r['signer_id_number'] as String?),
                  termsAccepted:
                      Value((r['terms_accepted'] ?? false) as bool),
                  receiptConfirmed:
                      Value((r['receipt_confirmed'] ?? false) as bool),
                  signaturePath: Value(r['signature_path'] as String?),
                  idPhotoPath: Value(r['id_photo_path'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
      TableSyncAdapter(
        remoteTable: 'rental_lines',
        mergeRemote: (db, r) async {
          final local = await (db.select(db.rentalLines)
                ..where((x) => x.id.equals(r['id'] as String)))
              .getSingleOrNull();
          final remoteUpdated = ts(r['updated_at']);
          if (!newer(local?.updatedAt, remoteUpdated)) return false;
          await db.into(db.rentalLines).insertOnConflictUpdate(
                RentalLinesCompanion(
                  id: Value(r['id'] as String),
                  contractId: Value(r['contract_id'] as String),
                  assetId: Value(r['asset_id'] as String),
                  toolModelId: Value(r['tool_model_id'] as String),
                  rateKind: Value((r['rate_kind'] ?? 'day') as String),
                  rate: Value(_d(r['rate'])),
                  periods: Value(_d(r['periods'])),
                  amount: Value(_d(r['amount'])),
                  deliveredAt: Value(tsN(r['delivered_at'])),
                  returnedAt: Value(tsN(r['returned_at'])),
                  conditionOut: Value(r['condition_out'] as String?),
                  conditionIn: Value(r['condition_in'] as String?),
                  notes: Value(r['notes'] as String?),
                  updatedAt: Value(remoteUpdated),
                  deletedAt: Value(tsN(r['deleted_at'])),
                ),
              );
          return true;
        },
      ),
    ];

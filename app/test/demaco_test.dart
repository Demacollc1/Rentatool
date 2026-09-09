import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demaco/data/local/database.dart';
import 'package:demaco/data/ocr/label_parser.dart';
import 'package:demaco/data/repositories/catalog_repository.dart';
import 'package:demaco/data/repositories/category_repository.dart';
import 'package:demaco/data/repositories/location_repository.dart';
import 'package:demaco/data/repositories/rental_repository.dart';
import 'package:demaco/data/seed/portfolio_importer.dart';
import 'package:demaco/data/sync/adapters.dart';
import 'package:demaco/data/sync/sync_service.dart';

AppDatabase _db() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
}

void main() {
  group('ids determinísticos', () {
    test('misma clave → mismo uuid; clave distinta → distinto', () {
      expect(deterministicId('model:DWE575K'),
          deterministicId('model:DWE575K'));
      expect(deterministicId('model:DWE575K'),
          isNot(deterministicId('model:CMES500')));
      expect(
          RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
              .hasMatch(deterministicId('x')),
          isTrue);
    });
  });

  group('importador del portafolio', () {
    late AppDatabase db;
    late SyncService sync;
    late PortfolioImporter importer;
    late CatalogRepository catalog;

    setUp(() {
      db = _db();
      sync = SyncService(db, buildSyncAdapters());
      catalog = CatalogRepository(db, sync);
      importer = PortfolioImporter(CategoryRepository(db, sync), catalog);
    });

    tearDown(() => db.close());

    Map<String, dynamic> loadSeed() =>
        jsonDecode(File('assets/seed/portafolio.json').readAsStringSync())
            as Map<String, dynamic>;

    test('resumen del JSON real', () {
      final s = importer.summarize(loadSeed());
      expect(s.oficios, 11);
      expect(s.filas, 107);
      expect(s.modelos, 71); // códigos únicos (se repiten entre oficios)
      expect(s.consumibles, 14);
    });

    test('importa y es idempotente', () async {
      final data = loadSeed();
      final r1 = await importer.import(data);
      expect(r1.modelos, 71);

      final models = await catalog.watchModels().first;
      expect(models.length, 71);
      final cons = await catalog.watchConsumables().first;
      expect(cons.length, 14);

      // Tarifas precargadas según la regla 14/20/70/200.
      final sierra =
          models.firstWhere((m) => m.supplierCode == 'DWE575K');
      expect(sierra.listCost, closeTo(124.92, 0.01));
      expect(sierra.rateHalfDay, closeTo(124.92 * 0.14, 0.01));
      expect(sierra.rateDay, closeTo(124.92 * 0.20, 0.01));
      expect(sierra.rateWeek, closeTo(124.92 * 0.70, 0.01));
      expect(sierra.rateMonth, closeTo(124.92 * 2.00, 0.01));

      // Reimportar no duplica.
      await importer.import(data);
      expect((await catalog.watchModels().first).length, 71);
      expect((await catalog.watchConsumables().first).length, 14);
    });

    test('sin costo → sin tarifas (no tarifable)', () async {
      await importer.import(loadSeed());
      final models = await catalog.watchModels().first;
      final sinCosto = models.where((m) => m.listCost == 0);
      for (final m in sinCosto) {
        expect(m.rateDay, isNull,
            reason: '${m.supplierCode} no debería tener tarifa');
      }
    });
  });

  group('kardex de unidades', () {
    late AppDatabase db;
    late CatalogRepository catalog;
    late LocationRepository locations;

    setUp(() {
      db = _db();
      final sync = SyncService(db, buildSyncAdapters());
      catalog = CatalogRepository(db, sync);
      locations = LocationRepository(db, sync);
    });

    tearDown(() => db.close());

    test('alta, movimiento y estados escriben movements', () async {
      final modelId = await catalog.saveModel(
          name: 'Taladro', listCost: 100, rateDay: 20);
      final bodega = await locations.save(name: 'Bodega B87');
      final showroom = await locations.save(name: 'Showroom');

      final tag = await catalog.nextAssetTag();
      expect(tag, 'DEM-0001');
      final assetId = await catalog.createAsset(
        toolModelId: modelId,
        assetTag: tag,
        locationId: bodega,
        purchaseCost: 95,
      );

      var moves = await catalog.watchMovements(assetId: assetId).first;
      expect(moves.single.kind, 'intake');

      await catalog.moveAsset(assetId, showroom);
      moves = await catalog.watchMovements(assetId: assetId).first;
      final transfer = moves.firstWhere((m) => m.kind == 'transfer');
      expect(transfer.fromLocationId, bodega);
      expect(transfer.toLocationId, showroom);

      await catalog.setAssetStatus(assetId, 'rented');
      await catalog.setAssetStatus(assetId, 'available');
      moves = await catalog.watchMovements(assetId: assetId).first;
      expect(moves.map((m) => m.kind).toSet(),
          {'intake', 'transfer', 'rent_out', 'rent_return'});

      // Capital = suma de purchase_cost de unidades vivas.
      final assets = await catalog.watchAssets().first;
      final capital = assets
          .where((a) => a.status != 'retired')
          .fold<double>(0, (s, a) => s + a.purchaseCost);
      expect(capital, 95);
    });

    test('sin serie de fábrica → lote + fecha de ingreso', () async {
      final modelId = await catalog.saveModel(name: 'Nivel láser');
      final tag = await catalog.nextAssetTag();
      final id = await catalog.createAsset(
          toolModelId: modelId, assetTag: tag, serial: '  ');
      final asset = await catalog.getAsset(id);
      final now = DateTime.now();
      final fecha = '${now.year}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}';
      expect(asset!.serial, '$tag-$fecha');
    });

    test('correlativo de asset_tag avanza', () async {
      final modelId = await catalog.saveModel(name: 'X');
      await catalog.createAsset(
          toolModelId: modelId, assetTag: await catalog.nextAssetTag());
      await catalog.createAsset(
          toolModelId: modelId, assetTag: await catalog.nextAssetTag());
      expect(await catalog.nextAssetTag(), 'DEM-0003');
    });
  });

  group('ubicaciones', () {
    test('jerarquía 5 niveles con fullPath y tope', () async {
      final db = _db();
      final locations =
          LocationRepository(db, SyncService(db, buildSyncAdapters()));
      var parent = await locations.save(name: 'Bodega B87');
      final ids = [parent];
      for (final name in ['Zona A', 'Repisa 1', 'Nivel 2', 'Caja 3']) {
        parent = await locations.save(parentId: parent, name: name);
        ids.add(parent);
      }
      expect(await locations.fullPath(ids.last),
          'Bodega B87 > Zona A > Repisa 1 > Nivel 2 > Caja 3');
      expect(
          () => locations.save(parentId: ids.last, name: 'Extra'),
          throwsStateError);
      await db.close();
    });
  });

  group('codigos y proveedores', () {
    test('nextRatCode secuencial por canónico', () async {
      final db = _db();
      final sync = SyncService(db, buildSyncAdapters());
      final catalog = CatalogRepository(db, sync);
      expect(await catalog.nextRatCode('AAQ'), 'AAQ-001');
      await catalog.saveModel(
          name: 'Anclaje químico', ratCode: 'AAQ-001',
          canonicalCode: 'AAQ');
      expect(await catalog.nextRatCode('AAQ'), 'AAQ-002');
      expect(await catalog.nextRatCode('SIE'), 'SIE-001');
      await db.close();
    });
  });

  group('OCR label parser', () {
    test('reconoce marca, modelo y serie etiquetados', () {
      final g = parseLabelText("""
DEWALT
Angle Grinder
MODEL: D28114
S/N: 23245662345
120V~ 60Hz 11.6A
""");
      expect(g.brand, 'Dewalt');
      expect(g.model, 'D28114');
      expect(g.serial, '23245662345');
    });

    test('serie sin etiqueta: dígitos largos; modelo por patrón', () {
      final g = parseLabelText("""
BOSCH GWS14-125
987654321012
1400W 11000RPM
""");
      expect(g.brand, 'Bosch');
      expect(g.model, 'GWS14-125');
      expect(g.serial, '987654321012');
    });

    test('specs eléctricas no se confunden con modelo', () {
      final g = parseLabelText('CRAFTSMAN\n120V 60HZ 1500W\nCMES500');
      expect(g.model, 'CMES500');
    });
  });

  group('contratos de renta (F2)', () {
    late AppDatabase db;
    late CatalogRepository catalog;
    late RentalRepository rentals;

    setUp(() {
      db = _db();
      final sync = SyncService(db, buildSyncAdapters());
      catalog = CatalogRepository(db, sync);
      rentals = RentalRepository(db, sync, catalog);
    });

    tearDown(() => db.close());

    Future<(String contractId, String assetId)> armaContrato() async {
      final modelId = await catalog.saveModel(
          name: 'Rotomartillo',
          listCost: 100,
          rateHalfDay: 14,
          rateDay: 20,
          rateWeek: 70,
          rateMonth: 200);
      final assetId = await catalog.createAsset(
          toolModelId: modelId,
          assetTag: await catalog.nextAssetTag(),
          purchaseCost: 100);
      final customerId = await rentals.saveCustomer(
          name: 'Constructora Andes', idNumber: '0999999999001');
      final contractId =
          await rentals.createContract(customerId: customerId);
      return (contractId, assetId);
    }

    test('correlativo CTR avanza', () async {
      final customerId = await rentals.saveCustomer(name: 'Ana');
      expect(await rentals.nextContractNumber(), 'CTR-0001');
      await rentals.createContract(customerId: customerId);
      expect(await rentals.nextContractNumber(), 'CTR-0002');
    });

    test('flujo completo: agregar, entregar, devolver, cerrar', () async {
      final (contractId, assetId) = await armaContrato();

      // Agregar la unidad con tarifa día precargada.
      expect(await rentals.addLine(contractId, assetId), isNull);
      expect(await rentals.addLine(contractId, assetId),
          contains('ya está en el contrato'));
      var lines = await rentals.watchLines(contractId).first;
      expect(lines.single.line.rate, 20);
      expect(lines.single.line.amount, 20);

      // Cambiar a semana × 2 recalcula el importe.
      await rentals.updateLine(lines.single.line.id,
          rateKind: 'week', periods: 2);
      lines = await rentals.watchLines(contractId).first;
      expect(lines.single.line.amount, 140);

      // Entregar: contrato activo, unidad rentada, kardex rent_out.
      expect(await rentals.deliver(contractId), isNull);
      var contract = await rentals.getContract(contractId);
      expect(contract!.status, 'active');
      var asset = await catalog.getAsset(assetId);
      expect(asset!.status, 'rented');
      var moves = await catalog.watchMovements(assetId: assetId).first;
      final out = moves.firstWhere((m) => m.kind == 'rent_out');
      expect(out.contractRef, contract.contractNumber);

      // La misma unidad no puede entrar a otro contrato.
      final c2 = await rentals.createContract(
          customerId: contract.customerId);
      expect(await rentals.addLine(c2, assetId),
          contains('no está disponible'));

      // Devolver: unidad disponible, línea cerrada, contrato cerrado.
      await rentals.returnLine(lines.single.line.id);
      asset = await catalog.getAsset(assetId);
      expect(asset!.status, 'available');
      contract = await rentals.getContract(contractId);
      expect(contract!.status, 'closed');
      expect(contract.returnedAt, isNotNull);
      moves = await catalog.watchMovements(assetId: assetId).first;
      expect(moves.any((m) => m.kind == 'rent_return'), isTrue);
    });

    test('devolución dañada manda la unidad a mantenimiento', () async {
      final (contractId, assetId) = await armaContrato();
      await rentals.addLine(contractId, assetId);
      await rentals.deliver(contractId);
      final lines = await rentals.watchLines(contractId).first;
      await rentals.returnLine(lines.single.line.id,
          conditionIn: 'poor', notes: 'carbones quemados');
      final asset = await catalog.getAsset(assetId);
      expect(asset!.status, 'maintenance');
      expect(asset.condition, 'poor');
      final contract = await rentals.getContract(contractId);
      expect(contract!.status, 'closed');
    });

    test('tarifa derivada de las fechas retiro → devolución', () {
      final r = RentalRepository(db,
          SyncService(db, buildSyncAdapters()), catalog);
      final d0 = DateTime(2026, 9, 9, 10);
      (String, double) f(int dias) =>
          r.rentalKindForDates(d0, d0.add(Duration(days: dias)));
      expect(f(0), ('day', 1.0)); // mismo día = 1 día
      expect(f(3), ('day', 3.0));
      expect(f(10), ('week', 2.0));
      expect(f(30), ('month', 1.0));
      expect(f(45), ('month', 2.0));
    });

    test('con fecha pactada la línea se calcula sola y se recalcula',
        () async {
      final (contractId, assetId) = await armaContrato();
      await rentals.updateContract(contractId,
          dueAt: DateTime.now().add(const Duration(days: 10)));
      await rentals.addLine(contractId, assetId);
      var lines = await rentals.watchLines(contractId).first;
      expect(lines.single.line.rateKind, 'week');
      expect(lines.single.line.periods, 2);
      expect(lines.single.line.amount, 140); // 70 × 2

      // Acortar la renta recalcula a días.
      await rentals.updateContract(contractId,
          dueAt: DateTime.now().add(const Duration(days: 2)));
      lines = await rentals.watchLines(contractId).first;
      expect(lines.single.line.rateKind, 'day');
      expect(lines.single.line.amount, 40); // 20 × 2
    });

    test('el retiro pactado manda mientras no haya entrega real',
        () async {
      final (contractId, assetId) = await armaContrato();
      // Retiro en 5 días y devolución en 15: la renta dura 10 días.
      final now = DateTime.now();
      await rentals.updateContract(contractId,
          pickupAt: now.add(const Duration(days: 5)),
          dueAt: now.add(const Duration(days: 15)));
      await rentals.addLine(contractId, assetId);
      final lines = await rentals.watchLines(contractId).first;
      expect(lines.single.line.rateKind, 'week');
      expect(lines.single.line.periods, 2); // ceil(10/7)
    });

    test('obras por cliente y entrega con transporte', () async {
      final (contractId, _) = await armaContrato();
      final contract = await rentals.getContract(contractId);
      final siteId = await rentals.saveSite(
          customerId: contract!.customerId,
          name: 'Edificio Norte',
          address: 'Av. Siempre Viva 123');
      await rentals.updateContract(contractId,
          deliveryMethod: 'delivery', siteId: siteId, deliveryFee: 15);
      final c2 = await rentals.getContract(contractId);
      expect(c2!.deliveryMethod, 'delivery');
      expect(c2.siteId, siteId);
      expect(c2.deliveryFee, 15);
      final sites =
          await rentals.watchSites(contract.customerId).first;
      expect(sites.single.name, 'Edificio Norte');
    });

    test('entregar sin líneas o dos veces falla con motivo', () async {
      final (contractId, assetId) = await armaContrato();
      expect(await rentals.deliver(contractId),
          contains('al menos una unidad'));
      await rentals.addLine(contractId, assetId);
      expect(await rentals.deliver(contractId), isNull);
      expect(await rentals.deliver(contractId),
          contains('ya fue entregado'));
    });
  });
}

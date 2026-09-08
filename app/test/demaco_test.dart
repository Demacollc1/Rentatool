import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demaco/data/local/database.dart';
import 'package:demaco/data/ocr/label_parser.dart';
import 'package:demaco/data/repositories/catalog_repository.dart';
import 'package:demaco/data/repositories/category_repository.dart';
import 'package:demaco/data/repositories/location_repository.dart';
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
}

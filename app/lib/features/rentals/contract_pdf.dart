import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/repositories/rental_repository.dart';
import '../../data/sync/sync_service.dart';

const _kindLabel = {
  'half_day': 'Bloque 4h',
  'day': 'Día',
  'week': 'Semana',
  'month': 'Mes',
};

/// Genera el contrato de renta en PDF (A4) y devuelve la ruta.
Future<String?> buildContractPdf(WidgetRef ref, String contractId) async {
  final repo = ref.read(rentalRepositoryProvider);
  final db = ref.read(appDatabaseProvider);
  final contract = await repo.getContract(contractId);
  if (contract == null) return null;
  final customer = await (db.select(db.customers)
        ..where((c) => c.id.equals(contract.customerId)))
      .getSingleOrNull();
  final site = contract.siteId == null
      ? null
      : await (db.select(db.customerSites)
            ..where((s) => s.id.equals(contract.siteId!)))
          .getSingleOrNull();
  final lines = await repo.watchLines(contractId).first;
  final money = NumberFormat.currency(symbol: r'$');
  final df = DateFormat('dd/MM/yyyy HH:mm');
  final total = lines.fold<double>(0, (s, l) => s + l.line.amount) +
      contract.deliveryFee;

  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(36),
    build: (ctx) => [
      pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('DEMACO RENT A TOOL',
                      style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text('Contrato de renta de herramientas',
                      style: const pw.TextStyle(
                          fontSize: 10, color: PdfColors.grey700)),
                ]),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(contract.contractNumber,
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(df.format(contract.startAt ?? DateTime.now()),
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
          ]),
      pw.Divider(color: PdfColors.grey800),
      pw.SizedBox(height: 6),
      pw.Text('CLIENTE',
          style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
              letterSpacing: 1)),
      pw.Text(customer?.name ?? '—',
          style: pw.TextStyle(
              fontSize: 12, fontWeight: pw.FontWeight.bold)),
      pw.Text(
          [
            if (customer?.idNumber != null) 'CI/RUC ${customer!.idNumber}',
            if (customer?.phone != null) 'Tel. ${customer!.phone}',
            if (customer?.address != null) customer!.address!,
          ].join(' · '),
          style: const pw.TextStyle(fontSize: 10)),
      pw.SizedBox(height: 4),
      if (contract.dueAt != null)
        pw.Text(
            'Devolución pactada: '
            '${DateFormat('dd/MM/yyyy').format(contract.dueAt!)}',
            style: const pw.TextStyle(fontSize: 10)),
      pw.Text(
          contract.deliveryMethod == 'delivery'
              ? 'Entrega: envío por transporte'
                  '${site == null ? '' : ' a ${site.name}'
                      '${site.address == null ? '' : ' — ${site.address}'}'}'
              : 'Entrega: retiro en el local',
          style: const pw.TextStyle(fontSize: 10)),
      pw.SizedBox(height: 12),
      pw.TableHelper.fromTextArray(
        headers: [
          'Unidad',
          'Equipo',
          'Serie',
          'Tarifa',
          'Cant.',
          'Importe'
        ],
        headerStyle: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white),
        headerDecoration:
            const pw.BoxDecoration(color: PdfColors.grey800),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellAlignments: {
          4: pw.Alignment.center,
          5: pw.Alignment.centerRight,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(1.5),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(1.8),
          3: const pw.FlexColumnWidth(1.6),
          4: const pw.FlexColumnWidth(0.8),
          5: const pw.FlexColumnWidth(1.3),
        },
        data: [
          for (final v in lines)
            [
              v.asset?.assetTag ?? '',
              '${v.model?.name ?? ''}\n'
                  '${[v.asset?.brand, v.asset?.mfrModel].whereType<String>().join(' ')}',
              v.asset?.serial ?? '',
              '${_kindLabel[v.line.rateKind] ?? v.line.rateKind} '
                  '${money.format(v.line.rate)}',
              v.line.periods.toStringAsFixed(0),
              money.format(v.line.amount),
            ],
        ],
      ),
      pw.SizedBox(height: 8),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          if (contract.deliveryFee > 0)
            pw.Text('Transporte: ${money.format(contract.deliveryFee)}',
                style: const pw.TextStyle(fontSize: 10)),
          pw.Text('TOTAL ${money.format(total)}',
              style: pw.TextStyle(
                  fontSize: 13, fontWeight: pw.FontWeight.bold)),
          if (contract.deposit > 0)
            pw.Text('Garantía recibida: ${money.format(contract.deposit)}',
                style: const pw.TextStyle(fontSize: 10)),
        ]),
      ]),
      pw.SizedBox(height: 14),
      pw.Text('CONDICIONES',
          style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
              letterSpacing: 1)),
      pw.Bullet(
          text: 'El cliente recibe los equipos en buen estado de '
              'funcionamiento y los devuelve en las mismas condiciones, '
              'salvo el desgaste normal por uso.',
          style: const pw.TextStyle(fontSize: 9)),
      pw.Bullet(
          text: 'Daños, pérdida o robo durante la renta corren por '
              'cuenta del cliente hasta el valor de reposición.',
          style: const pw.TextStyle(fontSize: 9)),
      pw.Bullet(
          text: 'La devolución después de la fecha pactada genera el '
              'cobro de los períodos adicionales a la tarifa contratada.',
          style: const pw.TextStyle(fontSize: 9)),
      pw.Bullet(
          text: 'La garantía se devuelve al cierre del contrato, '
              'descontando daños o faltantes si los hubiera.',
          style: const pw.TextStyle(fontSize: 9)),
      if ((contract.notes ?? '').isNotEmpty) ...[
        pw.SizedBox(height: 6),
        pw.Text('Notas: ${contract.notes}',
            style: const pw.TextStyle(fontSize: 9)),
      ],
      pw.SizedBox(height: 42),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        for (final firma in ['ENTREGA · DEMACO', 'RECIBE · CLIENTE'])
          pw.Column(children: [
            pw.Container(
                width: 180,
                decoration: const pw.BoxDecoration(
                    border: pw.Border(
                        top: pw.BorderSide(color: PdfColors.grey800)))),
            pw.SizedBox(height: 3),
            pw.Text(firma, style: const pw.TextStyle(fontSize: 8)),
          ]),
      ]),
    ],
  ));

  final dir = await getApplicationDocumentsDirectory();
  final outDir = Directory(p.join(dir.path, 'pdfs'));
  await outDir.create(recursive: true);
  final path =
      p.join(outDir.path, 'Contrato_${contract.contractNumber}.pdf');
  await File(path).writeAsBytes(await doc.save());
  return path;
}

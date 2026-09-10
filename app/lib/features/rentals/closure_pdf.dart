import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/repositories/rental_repository.dart';
import '../../data/sync/sync_service.dart';

const _condLabel = {'good': 'Bien', 'fair': 'Regular', 'poor': 'Dañada'};

/// Comprobante de cierre del contrato: devolución conforme de las
/// unidades y liquidación de la garantía. Devuelve la ruta del PDF.
Future<String?> buildClosurePdf(WidgetRef ref, String contractId) async {
  final repo = ref.read(rentalRepositoryProvider);
  final db = ref.read(appDatabaseProvider);
  final contract = await repo.getContract(contractId);
  if (contract == null || contract.status != 'closed') return null;
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
  final devuelta = contract.deposit - contract.depositRetained;

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
                  pw.Text('ALIVIO CONSTRUCTOR',
                      style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text('Comprobante de cierre de contrato',
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
                  pw.Text(df.format(contract.returnedAt ?? DateTime.now()),
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
          ]),
      pw.Divider(color: PdfColors.grey800),
      pw.SizedBox(height: 6),
      pw.Text('Cliente: ${customer?.name ?? '—'}'
          '${customer?.idNumber == null ? '' : ' · RUC ${customer!.idNumber}'}',
          style: const pw.TextStyle(fontSize: 10)),
      if (site != null)
        pw.Text('Obra: ${site.name}',
            style: const pw.TextStyle(fontSize: 10)),
      pw.Text(
          'Entregado: '
          '${contract.startAt == null ? '—' : df.format(contract.startAt!)}'
          ' · Devuelto: '
          '${contract.returnedAt == null ? '—' : df.format(contract.returnedAt!)}',
          style: const pw.TextStyle(fontSize: 10)),
      pw.SizedBox(height: 10),
      pw.TableHelper.fromTextArray(
        headers: ['Unidad', 'Equipo', 'Devuelta', 'Condición'],
        headerStyle: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white),
        headerDecoration:
            const pw.BoxDecoration(color: PdfColors.grey800),
        cellStyle: const pw.TextStyle(fontSize: 9),
        columnWidths: {
          0: const pw.FlexColumnWidth(1.4),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(1.6),
          3: const pw.FlexColumnWidth(1.3),
        },
        data: [
          for (final v in lines)
            [
              v.asset?.assetTag ?? '',
              v.model?.name ?? '',
              v.line.returnedAt == null
                  ? '—'
                  : DateFormat('dd/MM HH:mm')
                      .format(v.line.returnedAt!),
              _condLabel[v.line.conditionIn] ??
                  (v.line.conditionIn ?? '—'),
            ],
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Text('Renta total: ${money.format(total)}',
          style: const pw.TextStyle(fontSize: 11)),
      pw.SizedBox(height: 6),
      pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey700),
            borderRadius: pw.BorderRadius.circular(4)),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('LIQUIDACIÓN DE GARANTÍA',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1)),
              pw.Text('Recibida: ${money.format(contract.deposit)}',
                  style: const pw.TextStyle(fontSize: 10)),
              if (contract.depositRetained > 0)
                pw.Text(
                    'Retenida: ${money.format(contract.depositRetained)}'
                    '${contract.depositNotes == null ? '' : ' — ${contract.depositNotes}'}',
                    style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Devuelta al cliente: ${money.format(devuelta)}',
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold)),
              if (contract.depositReleasedAt != null)
                pw.Text(
                    'Liberada el ${df.format(contract.depositReleasedAt!)}',
                    style: const pw.TextStyle(fontSize: 9)),
            ]),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
          'ALIVIO CONSTRUCTOR confirma la recepción conforme de los equipos '
          'detallados y el cumplimiento de los términos del contrato. '
          'Con la devolución de la garantía, el contrato queda cerrado '
          'sin valores pendientes entre las partes, salvo lo indicado '
          'en la liquidación.',
          style: const pw.TextStyle(fontSize: 9)),
      pw.SizedBox(height: 42),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        for (final firma in ['RECIBE · ALIVIO', 'CONFORME · CLIENTE'])
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
  final path = p.join(
      outDir.path, 'Cierre_${contract.contractNumber}.pdf');
  await File(path).writeAsBytes(await doc.save());
  return path;
}

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Etiqueta con QR: título (asset_tag o nombre), subtítulo y payload.
class QrLabel {
  const QrLabel({required this.title, this.subtitle, required this.data});

  final String title;
  final String? subtitle;
  final String data;
}

String qrForLocation(String id) => 'demaco:loc:$id';
String qrForAsset(String id) => 'demaco:asset:$id';

/// Payload completo de unidad: legible por el app (el id va primero)
/// y por cualquier lector genérico (producto, marca/modelo, lote, serie).
String qrForAssetFull({
  required String id,
  String? ratCode,
  String? brandModel,
  required String lote,
  String? serial,
}) =>
    [
      'demaco:asset:$id',
      if (ratCode != null && ratCode.isNotEmpty) ratCode,
      if (brandModel != null && brandModel.trim().isNotEmpty)
        brandModel.trim(),
      lote,
      if (serial != null && serial.isNotEmpty) 'SN:$serial',
    ].join('|');

const _ink = PdfColor.fromInt(0xFF15130D);
const _yellow = PdfColor.fromInt(0xFFFFC400);

/// PDF A4 con etiquetas QR (3 por fila) listas para imprimir/pegar.
Future<String> buildQrLabelsPdf({
  required String title,
  required List<QrLabel> labels,
  required String fileName,
}) async {
  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(24),
    build: (ctx) => [
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        color: _ink,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('DEMACO · $title',
                style: pw.TextStyle(
                    color: _yellow,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12)),
            pw.Text('${labels.length} etiquetas',
                style: const pw.TextStyle(
                    color: PdfColors.white, fontSize: 9)),
          ],
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final label in labels)
            pw.Container(
              width: 165,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey600),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                children: [
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: label.data,
                    width: 110,
                    height: 110,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(label.title,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  if (label.subtitle != null)
                    pw.Text(label.subtitle!,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                            fontSize: 7, color: PdfColors.grey700)),
                ],
              ),
            ),
        ],
      ),
    ],
  ));

  final dir = await getApplicationDocumentsDirectory();
  final outDir = Directory(p.join(dir.path, 'pdfs'));
  await outDir.create(recursive: true);
  final path = p.join(outDir.path, '$fileName.pdf');
  await File(path).writeAsBytes(await doc.save());
  return path;
}

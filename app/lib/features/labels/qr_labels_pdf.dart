import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/sync/sync_service.dart';

/// Etiqueta con QR: título (lote/nombre), subtítulo y payload.
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

/// Tamaño de etiqueta configurable (Configuración → Etiquetas).
/// Por defecto 100×50 mm (rollo DYMO grande).
const defaultLabelWidthMm = 100.0;
const defaultLabelHeightMm = 50.0;

Future<(double, double)> loadLabelSize(SyncService sync) async {
  final w = double.tryParse(await sync.stateGet('label_w_mm') ?? '');
  final h = double.tryParse(await sync.stateGet('label_h_mm') ?? '');
  return (w ?? defaultLabelWidthMm, h ?? defaultLabelHeightMm);
}

Future<void> saveLabelSize(
    SyncService sync, double wMm, double hMm) async {
  await sync.stateSet('label_w_mm', wMm.toString());
  await sync.stateSet('label_h_mm', hMm.toString());
}

/// PDF para impresora de etiquetas: UNA etiqueta por página al tamaño
/// configurado. Diseño en blanco y negro sin fondos (ahorro de tinta):
/// QR a la izquierda, nombre en negrita y ruta/detalle amplios.
Future<String> buildQrLabelsPdf({
  required String title,
  required List<QrLabel> labels,
  required String fileName,
  double? widthMm,
  double? heightMm,
}) async {
  final w = widthMm ?? defaultLabelWidthMm;
  final h = heightMm ?? defaultLabelHeightMm;
  final format =
      PdfPageFormat(w * PdfPageFormat.mm, h * PdfPageFormat.mm);
  // Escala tipográfica relativa a la altura (base 50 mm).
  final k = h / 50.0;
  final doc = pw.Document();

  for (final label in labels) {
    doc.addPage(pw.Page(
      pageFormat: format,
      margin: pw.EdgeInsets.all(2.5 * PdfPageFormat.mm),
      build: (ctx) {
        final qrSide = math.min(
            (h - 8) * PdfPageFormat.mm, (w * 0.42) * PdfPageFormat.mm);
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: label.data,
              width: qrSide,
              height: qrSide,
            ),
            pw.SizedBox(width: 3 * PdfPageFormat.mm),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('DEMACO · $title'.toUpperCase(),
                      style: pw.TextStyle(
                          fontSize: 7 * k,
                          color: PdfColors.grey700,
                          letterSpacing: 1)),
                  pw.Divider(
                      thickness: 0.7, color: PdfColors.grey800),
                  pw.Text(label.title,
                      maxLines: 2,
                      style: pw.TextStyle(
                          fontSize: 16 * k,
                          fontWeight: pw.FontWeight.bold)),
                  if (label.subtitle != null) ...[
                    pw.SizedBox(height: 2 * k * PdfPageFormat.mm),
                    pw.Text(label.subtitle!,
                        maxLines: 4,
                        style: pw.TextStyle(
                            fontSize: 9.5 * k,
                            color: PdfColors.grey800)),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    ));
  }

  final dir = await getApplicationDocumentsDirectory();
  final outDir = Directory(p.join(dir.path, 'pdfs'));
  await outDir.create(recursive: true);
  final path = p.join(outDir.path, '$fileName.pdf');
  await File(path).writeAsBytes(await doc.save());
  return path;
}

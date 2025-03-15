import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerMaker {
  static Future<ui.Image> getImageFromPath(String imagePath) async {
    //File imageFile = File(imagePath);

    var bd = await rootBundle.load(imagePath);
    Uint8List imageBytes = Uint8List.view(bd.buffer);

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  static Future<ui.Image> getImageFromPathUrl(String imagePath) async {
    //File imageFile = File(imagePath);
    // final response = await http.Client().get(Uri.parse(imagePath));
    // final bytes = response.bodyBytes;
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(imagePath);
    Uint8List imageBytes = await markerImageFile.readAsBytes();
//  var bd = await rootBundle.load(imagePath);
    //Uint8List imageBytes = Uint8List.view(bd.buffer);

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  static Future<BitmapDescriptor> getMarkerIcon(
      String imagePath,
      String infoText,
      Color color,
      double rotateDegree,
      bool _showTitle) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    //size
    Size canvasSize = const Size(700.0, 220.0);
    Size markerSize = const Size(120.0, 120.0);
    late TextPainter textPainter;
    if (_showTitle) {
      // Add info text
      textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: infoText,
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w600, color: color),
      );
      textPainter.layout();
    }

    final Paint infoPaint = Paint()..color = Colors.white;
    final Paint infoStrokePaint = Paint()..color = color;
    const double infoHeight = 40.0;
    const double strokeWidth = 2.0;

    //final Paint markerPaint = Paint()..color = color.withOpacity(0);
    const double shadowWidth = 40.0;

    canvas.translate(
        canvasSize.width / 2, canvasSize.height / 2 + infoHeight / 2);

    // Add shadow circle
    // canvas.drawOval(
    //     Rect.fromLTWH(-markerSize.width / 2, -markerSize.height / 2,
    //         markerSize.width, markerSize.height),
    //     markerPaint);
    // // Add border circle
    // canvas.drawOval(
    //     Rect.fromLTWH(
    //         -markerSize.width / 2 + shadowWidth,
    //         -markerSize.height / 2 + shadowWidth,
    //         markerSize.width - 2 * shadowWidth,
    //         markerSize.height - 2 * shadowWidth),
    //     borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(
        -markerSize.width / 2 + .5 * shadowWidth,
        -markerSize.height / 2 + .5 * shadowWidth,
        markerSize.width - shadowWidth,
        markerSize.height - shadowWidth);

    //save canvas before rotate
    canvas.save();

    //double rotateRadian = (pi / 180.0) * rotateDegree;

    //Rotate Image
    //canvas.rotate(rotateRadian);

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    ui.Image image;
    // Add image
    // if(imagePath.contains("arrow-ack.png")){
    image = await getImageFromPathUrl(imagePath);

    // image = await getImageFromPath("assets/images/direction.png");
    /* }else{
    image = await getImageFromPathUrl(imagePath);

  }*/

    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitHeight);

    canvas.restore();
    if (_showTitle) {
      // Add info box stroke
      canvas.drawPath(
          Path()
            ..addRRect(RRect.fromLTRBR(
                -textPainter.width / 2 - infoHeight / 2,
                -canvasSize.height / 2 - infoHeight / 2 + 1,
                textPainter.width / 2 + infoHeight / 2,
                -canvasSize.height / 2 + infoHeight / 2 + 1,
                const Radius.circular(35.0)))
            ..moveTo(-15, -canvasSize.height / 2 + infoHeight / 2 + 1)
            ..lineTo(0, -canvasSize.height / 2 + infoHeight / 2 + 25)
            ..lineTo(15, -canvasSize.height / 2 + infoHeight / 2 + 1),
          infoStrokePaint);

      //info info box
      canvas.drawPath(
          Path()
            ..addRRect(RRect.fromLTRBR(
                -textPainter.width / 2 - infoHeight / 2 + strokeWidth,
                -canvasSize.height / 2 - infoHeight / 2 + 1 + strokeWidth,
                textPainter.width / 2 + infoHeight / 2 - strokeWidth,
                -canvasSize.height / 2 + infoHeight / 2 + 1 - strokeWidth,
                const Radius.circular(32.0)))
            ..moveTo(-15 + strokeWidth / 2,
                -canvasSize.height / 2 + infoHeight / 2 + 1 - strokeWidth)
            ..lineTo(0,
                -canvasSize.height / 2 + infoHeight / 2 + 25 - strokeWidth * 2)
            ..lineTo(15 - strokeWidth / 2,
                -canvasSize.height / 2 + infoHeight / 2 + 1 - strokeWidth),
          infoPaint);
      textPainter.paint(
          canvas,
          Offset(
              -textPainter.width / 2,
              -canvasSize.height / 2 -
                  infoHeight / 2 +
                  infoHeight / 2 -
                  textPainter.height / 2));

      canvas.restore();
    }

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(canvasSize.width.toInt(), canvasSize.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? uint8List = byteData?.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List!);
  }
}

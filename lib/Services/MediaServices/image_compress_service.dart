import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:native_exif/native_exif.dart';

class ImageCompressService {
  Future<File> compress(File file, {bool isDocument = false}) async {
    debugPrint('Compressing the image');
    final stamp = '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 32)}';
    final compressedPath = '${file.parent.path}/compressed_$stamp.jpg';
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      compressedPath,
      quality: 50,
      minWidth: 800,
      minHeight: 600,
      keepExif: true,
    );

    if (compressedImage == null) {
      throw StateError('Could not compress image');
    }

    final exif = await Exif.fromPath(compressedImage.path);
    exif.getLatLong().then((value) {
      debugPrint('Location: ${value?.latitude}, ${value?.longitude}');
    });
    final dateFormat = DateFormat('yyyy:MM:dd HH:mm:ss');
    await exif.writeAttribute('DateTimeOriginal', dateFormat.format(DateTime.now()));

    if (isDocument) {
      return File(compressedImage.path);
    }

    debugPrint('Adding WaterMark');
    final decoded = img.decodeImage(await File(compressedImage.path).readAsBytes());
    if (decoded == null) {
      throw StateError('Could not decode image');
    }

    img.drawString(
      decoded,
      DateTime.now().toString(),
      font: img.arial24,
      x: 50,
      y: decoded.height - 60,
    );
    final watermarkedPath = '${file.parent.path}/watermarked_$stamp.jpg';
    final result = await File(watermarkedPath).writeAsBytes(img.encodeJpg(decoded));
    try {
      await File(compressedPath).delete();
    } catch (_) {}
    return result;
  }
}

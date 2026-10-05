import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

class MediaUploadStager {
  static const _folder = 'pending_uploads';

  static Future<File> stage(File source) async {
    final dir = await _directory();
    final name = 'src_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 32)}.jpg';
    final dest = File('${dir.path}/$name');
    return source.copy(dest.path);
  }

  static Future<void> delete(File? file) async {
    if (file == null) return;
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  static Future<Directory> _directory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_folder');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}

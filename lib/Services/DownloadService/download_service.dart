import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/custom_snack_bar.dart';
import '../AuthServices/token_storage.dart';
import '../../constants/globals.dart';

class DownloadService {
  /// Checks if Android version is 10 or above (API 29+)
  /// Android 10+ uses scoped storage with MediaStore API which doesn't require storage permission
  Future<bool> _isAndroid10OrAbove() async {
    if (!Platform.isAndroid) return false;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      // androidInfo.version.sdkInt gives the SDK version (29 = Android 10, 30 = Android 11, etc.)
      return androidInfo.version.sdkInt >= 29;
    } catch (e) {
      // If detection fails, default to requesting permission (safer for older Android)
      debugPrint('DownloadService: Failed to detect Android version: $e');
      return false;
    }
  }

  Future<void> downloadForm(BuildContext context, String? file, int? claimId) async {
    debugPrint('DownloadService: starting downloadForm(file=$file, claimId=$claimId)');

    if (file == null || claimId == null) {
      debugPrint('DownloadService: failed - missing file or claimId');
      if (context.mounted) showSnackBar(context, "Download failed");
      return;
    }

    String url = "$baseUrl$file/$claimId?action=download";
    debugPrint('DownloadService: url=$url');

    String? token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('DownloadService: failed - no token');
      if (context.mounted) showSnackBar(context, "Download failed");
      return;
    }

    // Only request storage permission on Android < 10 (API < 29)
    // Android 10+ uses scoped storage with MediaStore API which doesn't require storage permission
    if (Platform.isAndroid && !(await _isAndroid10OrAbove())) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          showSnackBar(context, "Allow storage permission to save to Downloads");
        }
        openAppSettings();
        return;
      }
    }

    final task = DownloadTask(
      url: url,
      headers: {'Authorization': 'Bearer $token'},
      filename: '$file.pdf',
      baseDirectory: BaseDirectory.temporary,
      updates: Updates.statusAndProgress,
    );

    FileDownloader().configureNotification(
      running: TaskNotification('Downloading', '{filename} – {progress}%'),
      complete: TaskNotification('Download completed', '{filename}'),
      progressBar: true,
      tapOpensFile: true,
    );

    try {
      debugPrint('DownloadService: starting download...');
      final result = await FileDownloader().download(task);

      if (result.status == TaskStatus.complete) {
        if (Platform.isAndroid) {
          await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads);
        }
        debugPrint('DownloadService: download complete');
      } else {
        debugPrint('DownloadService: download failed - status=${result.status}');
        if (context.mounted) {
          showSnackBar(context, "Download failed");
        }
      }
    } catch (e, stack) {
      debugPrint('DownloadService: error - $e');
      debugPrint('DownloadService: stackTrace - $stack');
      if (context.mounted) {
        showSnackBar(context, "Download failed");
      }
    }
  }

  /// Downloads a letter that requires document selection (alert3, total-loss-docs, theft-docs)
  /// by POSTing selected document names and saving the PDF response.
  /// Uses background_downloader so progress appears in the notification bar (same as downloadForm).
  Future<void> downloadLetterWithDocuments(
    BuildContext context,
    String file,
    int? claimId,
    List<String> documents,
  ) async {
    debugPrint('DownloadService: downloadLetterWithDocuments(file=$file, claimId=$claimId)');

    if (file.isEmpty || claimId == null || documents.isEmpty) {
      debugPrint('DownloadService: failed - missing file, claimId or documents');
      if (context.mounted) showSnackBar(context, "Download failed");
      return;
    }

    final token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('DownloadService: failed - no token');
      if (context.mounted) showSnackBar(context, "Download failed");
      return;
    }

    // Only request storage permission on Android < 10 (API < 29)
    // Android 10+ uses scoped storage with MediaStore API which doesn't require storage permission
    if (Platform.isAndroid && !(await _isAndroid10OrAbove())) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          showSnackBar(context, "Allow storage permission to save to Downloads");
        }
        openAppSettings();
        return;
      }
    }

    final postBody = {'documents': documents, 'action': 'download'};
    final task = DownloadTask(
      url: '$baseUrl$file/$claimId',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      post: postBody,
      filename: '$file.pdf',
      baseDirectory: BaseDirectory.temporary,
      updates: Updates.statusAndProgress,
    );

    FileDownloader().configureNotification(
      running: TaskNotification('Downloading', '{filename} – {progress}%'),
      complete: TaskNotification('Download completed', '{filename}'),
      progressBar: true,
      tapOpensFile: true,
    );

    try {
      debugPrint('DownloadService: downloadLetterWithDocuments starting...');
      final result = await FileDownloader().download(task);

      if (result.status == TaskStatus.complete) {
        if (Platform.isAndroid) {
          await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads);
        }
        debugPrint('DownloadService: downloadLetterWithDocuments complete');
      } else {
        debugPrint('DownloadService: downloadLetterWithDocuments failed - status=${result.status}');
        if (context.mounted) {
          showSnackBar(context, "Download failed");
        }
      }
    } catch (e, stack) {
      debugPrint('DownloadService: downloadLetterWithDocuments error - $e');
      debugPrint('DownloadService: stackTrace - $stack');
      if (context.mounted) {
        showSnackBar(context, "Download failed");
      }
    }
  }
}

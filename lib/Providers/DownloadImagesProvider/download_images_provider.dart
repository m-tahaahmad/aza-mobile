import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:icms_app/Model/DownloadImages/download_images_response_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Services/DownloadImagesServices/download_images_service.dart';
import '../../components/custom_snack_bar.dart';
import 'dart:io';

class DownloadImagesProvider extends ChangeNotifier {
  DownloadImagesListModel? _allImagesList;
  double progressValue = 0.0;
  List<DownloadTask> tasks = [];
  bool isDownloading = false;
  bool isCompleted = false;

  DownloadImagesListModel? get allImagesList => _allImagesList;

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
      debugPrint('DownloadImagesProvider: Failed to detect Android version: $e');
      return false;
    }
  }

  set setAllImages(DownloadImagesListModel responseModel) {
    _allImagesList = responseModel;
    notifyListeners();
  }

  set setProgress(double value) {
    progressValue = value;
    notifyListeners();
  }

  set setDownloading(value) {
    isDownloading = value;
    notifyListeners();
  }

  set setComplete(value) {
    isCompleted = value;
    notifyListeners();
  }

  downloadImages(BuildContext context, int id, String? type) async {
    setDownloading = true;
    await DownloadImageService().getAllImages(context, id, type: type).then((value) async {
      if (value.responseData?.imagesList != null) {
        var imagesData = value.responseData?.imagesList?.toList();
        
        // Only request storage permission on Android < 10 (API < 29)
        // Android 10+ uses scoped storage with MediaStore API which doesn't require storage permission
        bool hasPermission = true;
        if (Platform.isAndroid && !(await _isAndroid10OrAbove())) {
          var status = await Permission.storage.request();
          debugPrint("STATUS:: $status");
          if (!status.isGranted) {
            hasPermission = false;
            if (status.isPermanentlyDenied) {
              openAppSettings();
              if (!context.mounted) return;
              showSnackBar(context, "Permission required to download images.");
            } else if (status.isDenied) {
              if (!context.mounted) return;
              showSnackBar(context, "Allow Permission and try again");
            }
            setDownloading = false;
            return;
          }
        }

        if (hasPermission) {
          for (var image in imagesData!) {
            var task = DownloadTask(
                url: image.imageUrl!,
                // Presigned B2 URLs carry auth in the query string; a Bearer header
                // can break signature validation on S3-compatible stores.
                updates: Updates.statusAndProgress,
                baseDirectory: BaseDirectory.temporary,
                filename: image.filename);
            tasks.add(task);
          }
          FileDownloader().configureNotification(
              running: TaskNotification('Downloading', 'file: {filename}'),
              complete: TaskNotification('Downloaded', 'file: {filename}'),
              progressBar: true,
              tapOpensFile: true);
          if (tasks.isNotEmpty) {
            await FileDownloader().downloadBatch(tasks, batchProgressCallback: (succeeded, failed) {
              debugPrint('$succeeded files succeeded, $failed have failed');
              debugPrint('Progress is ${(succeeded + failed) / tasks.length} %');
              setProgress = (succeeded + failed) / tasks.length;
            });
            for (var e in tasks) {
              FileDownloader().moveToSharedStorage(e, SharedStorage.downloads);
            }
            if (progressValue == 1.0) {
              setDownloading = false;
              setComplete = true;
              if (!context.mounted) return;
              showSnackBar(context, "Download Finish");
              setProgress = 0.0;
            }
          } else {
            setDownloading = false;
            if (!context.mounted) return;
            showSnackBar(context, "No Images to download.");
          }
        }
      } else {
        setDownloading = false;
        if (!context.mounted) return;
        showSnackBar(context, value.message ?? "Something went wrong!!!");
      }
    });
  }

  resetProvider() {
    isDownloading = false;
    isCompleted = false;
    notifyListeners();
  }
}

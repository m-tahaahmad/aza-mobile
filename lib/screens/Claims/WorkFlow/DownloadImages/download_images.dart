import 'package:flutter/material.dart';
import 'package:icms_app/Model/DownloadImages/download_images_response_model.dart';
import 'package:icms_app/Services/DownloadImagesServices/download_images_service.dart';
import 'package:icms_app/constants/theme_constants.dart';
import 'package:icms_app/screens/Claims/WorkFlow/DownloadImages/download_images_ui.dart';
import '../../../../Services/API/api_response.dart';
import '../../../../components/app_loader.dart';

class DownloadImagesScreen extends StatefulWidget {
  final int? id;

  const DownloadImagesScreen({super.key, this.id});

  @override
  State<DownloadImagesScreen> createState() => _DownloadImagesScreenState();
}

class _DownloadImagesScreenState extends State<DownloadImagesScreen> {
  Future<ApiResponse<DownloadImagesListModel>?>? getImages;

  @override
  void initState() {
    super.initState();
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              height: 200,
              width: 200,
              color: ColorConstants.baseColor,
            ),
          );
        });
    getImages = DownloadImageService().getAllImages(context, widget.id!, type: "f_insp");
  }

  Future _handleRefresh() async {
    getImages = DownloadImageService().getAllImages(context, widget.id!, type: "f_insp");
    await Future.delayed(const Duration(milliseconds: 1500));
    return getImages;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
        body: FutureBuilder<ApiResponse<dynamic>?>(
            future: getImages,
            builder: (context, AsyncSnapshot<ApiResponse<dynamic>?> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: AppLoader());
              } else {
                return const DownloadImagesUI();
              }
            }),
      ),
    );
  }
}

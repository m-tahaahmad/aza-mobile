import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icms_app/Providers/DownloadImagesProvider/download_images_provider.dart';
import 'package:provider/provider.dart';

import '../../../../components/app_loader.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_filled_button.dart';
import '../../../../constants/theme_constants.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../constants/globals.dart';

class DownloadImagesUI extends StatefulWidget {
  const DownloadImagesUI({super.key});

  @override
  State<DownloadImagesUI> createState() => _DownloadImagesUIState();
}

class _DownloadImagesUIState extends State<DownloadImagesUI> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Provider.of<MediaProvider>(context, listen: false).resetProvider();
        Navigator.of(context).pop(true);
      },
      child: Consumer<DownloadImagesProvider>(builder: (context, imagesProvider, child) {
        var imagesData = imagesProvider.allImagesList?.imagesList?.toList();
        return Scaffold(
          appBar: customAppBar(
            context,
            title: "Download Images",
            showBackButton: true,
            onTap: () {
              Navigator.of(context).pop(true);
            },
            returnValue: true,
          ) as PreferredSizeWidget?,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: imagesData?.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.0,
                              crossAxisCount: 2,
                              mainAxisExtent: 200,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // zoomPicture(
                                      //   mediaProvider.images[index]!.imageUrl,
                                      // );
                                    },
                                    child: Image.network(
                                      imagesData![index].imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: ColorConstants.primaryColor,
                                              )),
                                          child: const Center(
                                            child: Icon(
                                              Icons.hide_image_outlined,
                                              size: 50,
                                            ),
                                          ),
                                        );
                                      },
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: ColorConstants.primaryColor,
                                                )),
                                            child: const Center(child: AppLoader()),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              claimsType == "Waiting for approval" || claimsType == "Reports Pending"
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: ColorConstants.primaryColor,
                        width: size.width,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomFilledButton(
                              width: size.width * 0.9,
                              height: 35.h,
                              title: "DOWNLOAD IMAGES",
                              fontSize: FontSizes.extraSmallText,
                              btnColor: ColorConstants.white,
                              textColor: Colors.black,
                              onPressed: () {},
                            )),
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }
}

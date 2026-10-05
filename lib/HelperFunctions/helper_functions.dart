import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:icms_app/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';

import '../Providers/MediaProvider/media_provider.dart';
import '../components/custom_snack_bar.dart';
import '../constants/theme_constants.dart';
import 'package:geocoding/geocoding.dart';

class HelperFunctions {
  bool usePlrAttributes() {
    bool usePlr = false;
    if (claimsType == "1st Inspection" || claimsType == "Rejected" || claimsType == "Waiting for approval") {
      usePlr = true;
    }
    return usePlr;
  }

  imgFromCamera(
    BuildContext context,
    ImagePicker picker,
    int? claimId,
    MediaProvider mediaProvider, {
    required String uploadType,
    required String listType,
  }) async {
    if (!canAddImageForListType(listType, mediaProvider)) {
      showSnackBar(context, 'Limit Exceeded');
      return;
    }

    if (!mediaProvider.canStartUpload) {
      showSnackBar(context, 'Please wait — uploads in progress');
      return;
    }

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    if (!context.mounted) return;
    showSnackBar(context, 'Uploading . . .');

    final result = await mediaProvider.enqueueUpload(
      source: File(image.path),
      claimId: claimId,
      uploadType: uploadType,
      listType: listType,
    );

    if (!context.mounted) return;
    if (!result.success && result.message != null && !result.cancelled) {
      showSnackBar(context, result.message!);
    }
  }

  bool canAddImageForListType(String listType, MediaProvider mediaProvider) {
    switch (listType) {
      case 'insp':
        return mediaProvider.images.length < 36;
      case 'reinsp':
        return mediaProvider.reInspectImages.length < 15;
      case 'sd':
        return mediaProvider.sdImages.length < 8;
      case 'pre':
        return mediaProvider.preInspectImages.length < 20;
      default:
        return true;
    }
  }

  Future<Position?> getLocation() async {
    var status = await Permission.location.request();
    Position? position;
    if (status.isGranted) {
      position = await Geolocator.getCurrentPosition(
        locationSettings: Platform.isAndroid
            ? AndroidSettings(
                accuracy: LocationAccuracy.high,
                forceLocationManager: true,
              )
            : const LocationSettings(
                accuracy: LocationAccuracy.high,
              ),
      );
      // debugPrint('location: ${position.latitude}');
      // final coordinates = new Coordinates(position.latitude, position.longitude);
      List<Placemark> addresses = await placemarkFromCoordinates(position.latitude, position.longitude);
      var first = addresses.first;
      debugPrint(first.toString());
      debugPrint("${first.name} : ${first.subLocality} : ${first.administrativeArea}");
      return position;
    } else {
      return position;
    }
  }

  zoomPicture(BuildContext context, String? imageUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              alignment: Alignment.center,
              backgroundColor: ColorConstants.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.all(10),
              children: [
                Center(
                  child: Stack(
                    children: [
                      ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(15)), child: Image.network(imageUrl!)),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7).withValues(alpha: 0.5),
                                radius: 19,
                                child: Icon(
                                  Icons.clear,
                                  size: 18.h,
                                  color: ColorConstants.white,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
        });
  }

  getImageSize(path) async {
    final x = (await File(path).readAsBytes());
    final x1 = (await File(path).readAsBytes()).length;
    var decodedImage = await decodeImageFromList(x);
    debugPrint("WIDTH:: ${decodedImage.width}");
    debugPrint("HEIGHT:: ${decodedImage.height}");
    num size = x1 / 1000;
    debugPrint("FileSize:: ${size.toString()}");
    return x;
  }

  Future<void> selectDate(BuildContext context, DateTime initialDate, Function(String) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: ColorConstants.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialDate) {
      initialDate = picked;
      var formattedDate = DateFormat('yyyy-MM-dd').format(initialDate);
      debugPrint(formattedDate);
      onDateSelected(formattedDate);
    } else {
      var formattedDate = DateFormat('yyyy-MM-dd').format(initialDate);
      debugPrint(formattedDate);
      onDateSelected(formattedDate);
    }
  }
}

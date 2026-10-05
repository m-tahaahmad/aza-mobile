import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// App-wide page route with iOS edge-swipe back when running on iOS.
Route<T> appPageRoute<T>(WidgetBuilder builder, {bool fullscreenDialog = false}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute<T>(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
    );
  }

  return MaterialPageRoute<T>(
    builder: builder,
    fullscreenDialog: fullscreenDialog,
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppLoader extends StatelessWidget {
  final Color? color;

  const AppLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: 12.0,
      animating: true,
      color: color ?? Colors.black,
    );
  }
}

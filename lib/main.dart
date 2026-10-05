import 'package:flutter/material.dart';
import 'app.dart';
import 'init_app.dart';

Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

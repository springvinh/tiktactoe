import 'package:caro/controllers/bindings/AuthBinding.dart';
import 'package:caro/utils/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      home: Root(),
      debugShowCheckedModeBanner: false,
    );
  }
}
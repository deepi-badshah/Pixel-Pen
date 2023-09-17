import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixel_pen/SplashPage.dart';
import 'package:pixel_pen/widgets/PdfScanner.dart';
import 'package:pixel_pen/widgets/ResultScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // to ensure whether the dependencies are loaded correctly
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixel Pen',
      // home: SplashScreen(),
      // home: ResultScrSeen(text: "Hello Deepanshu"),
      home: PdfScanner(),
    );
  }
}

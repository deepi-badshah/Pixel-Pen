import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixel_pen/widgets/MainButton.dart';
import 'package:pixel_pen/widgets/ResultContainer.dart';

import '../utils/colors.dart';

class TextScanner extends StatefulWidget {
  const TextScanner({Key? key}) : super(key: key);

  @override
  State<TextScanner> createState() => _TextScannerState();
}

class _TextScannerState extends State<TextScanner> with WidgetsBindingObserver {
  bool isPermissionGranted = false;
  late final Future<void> future;

  //For controlling camera
  CameraController? cameraController;
  final textRecogniser = TextRecognizer();

  @override
  void initState() {
    super.initState();
    //To display camera feed we need to add WidgetsBindingObserver.
    WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecogniser.close();
    super.dispose();
  }

  //It'll check if app is in foreground or background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              //Show camera content behind everything
              if (isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        initCameraController(snapshot.data!);
                        return Center(
                          child: CameraPreview(cameraController!),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
              Scaffold(
                appBar: AppBar(
                  toolbarHeight: 80,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        shape: BoxShape
                            .rectangle, // Use a circular shape for the button
                        color: AppColors.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkColor!,
                            blurRadius: 12,
                            offset: const Offset(4, 4),
                            spreadRadius: 1,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            blurRadius: 12,
                            offset: Offset(-4, -4),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 24, // Set the desired icon size
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.darkColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  title: BounceInDown(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 2000),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor!,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.darkColor!,
                                blurRadius: 12,
                                offset: const Offset(4, 4),
                                spreadRadius: 1),
                            const BoxShadow(
                                color: Colors.white,
                                blurRadius: 12,
                                offset: Offset(-4, -4),
                                spreadRadius: 1),
                          ]),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        child: Text(
                          'Pixel Pen',
                          style: TextStyle(
                            fontFamily: 'Cera Pro',
                            color: AppColors.titleColor,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: AppColors.backgroundColor,
                  elevation: 0,
                ),
                backgroundColor:
                    isPermissionGranted ? Colors.transparent : null,
                body: isPermissionGranted
                    ? Column(
                        children: [
                          Expanded(child: Container()),
                          MainButton(
                            child: const Text(
                              "Scan Me",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.titleColor),
                            ),
                            onPressed: () {
                              scanImage();
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: const Text(
                            'Camera Permission Denied',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
            ],
          );
        });
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted = status == PermissionStatus.granted;
  }

  //It is used to initialise the camera controller
  //It also check the available camera in your device
  //It also check if camera controller is initialised or not.
  void initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }
    //Select the first ream camera
    CameraDescription? camera;
    for (var a = 0; a < cameras.length; a++) {
      final CameraDescription current = cameras[a];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      cameraSelected(camera);
    }
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  //Start Camera
  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  //Stop Camera
  void stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  //It will take care of scanning text from image
  Future<void> scanImage() async {
    if (cameraController == null) {
      return;
    }
    final navigator = Navigator.of(context);
    try {
      final pictureFile = await cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizerText = await textRecogniser.processImage(inputImage);
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(text: recognizerText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }
}

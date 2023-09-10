import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:pixel_pen/utils/ProgressIndicator.dart';
import 'package:pixel_pen/utils/colors.dart';
import 'package:pixel_pen/widgets/MainButton.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pixel_pen/widgets/TextScanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FilePickerResult? filePicked; // pdf file picked
  String? selectedFileName;
  // Function to pick a image file
  Future<void> pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String fileName = file.name;

        // Update the UI with the selected file name
        setState(() {
          selectedFileName = fileName;
          filePicked = result;
        });
      }
    } catch (e) {
      print("Error picking image : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              shape: BoxShape.rectangle, // Use a circular shape for the button
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 100 / 2,
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
                    child: Center(
                      child: FadeIn(
                        duration: Duration(seconds: 2),
                        child: Text(
                          selectedFileName != null
                              ? 'Selected PDF : $selectedFileName'
                              : "No File Choosen",
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MainButton(
                    child: const Text(
                      "Pick Me",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.titleColor),
                    ),
                    onPressed: () {
                      pickPDFFile();
                    },
                  ),
                  MainButton(
                    child: const Text(
                      "Camera",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.titleColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TextScanner()));
                    },
                  ),
                ],
              ),
              // const MyProgressIndicator(progress: 0.1),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 100 / 2,
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
                    child: Center(
                      child: FadeIn(
                        duration: Duration(seconds: 2),
                        child: const Text(
                          "TODO Progress Indicator",
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MainButton(
                    child: const Text(
                      "View word",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.titleColor),
                    ),
                    onPressed: () {
                      // TODO: View word file implementation
                    },
                  ),
                  MainButton(
                    child: const Text(
                      "Download",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.titleColor),
                    ),
                    onPressed: () {
                      //TO DO Download file to local device
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

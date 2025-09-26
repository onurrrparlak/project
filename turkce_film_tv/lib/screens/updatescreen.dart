import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';
import 'package:path_provider/path_provider.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  UpdateScreenState createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen> {
  bool downloading = false;
  double downloadProgress = 0;
  String downloadUrl = '';
  String patchNotes = '';
  String versionNumber = '';

  Future<void> fetchAppVersion() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('AppVersion')
          .doc('latestVersion')
          .get();

      final data = snapshot.data();

      if (data != null) {
        setState(() {
          downloadUrl = data['downloadUrl'];
          patchNotes = data['patchNotes'];
          versionNumber = data['versionNumber'];
        });
      } else {
        // Invalid data format or document does not exist
      }
    } catch (error) {
      // Error fetching app version: $error
    }
  }

  @override
  void initState() {
    
    super.initState();
    fetchAppVersion();
  }

  void downloadFile(String url) async {
    Dio dio = Dio();
    try {
      setState(() {
        downloading = true;
        downloadProgress = 0;
      });

      const fileName = 'app-release.apk';
      final downloadDir = await getExternalStorageDirectory();
      final savePath = '${downloadDir!.path}/Download/$fileName';

      await dio.download(url, savePath,
          onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          setState(() {
            downloadProgress = receivedBytes / totalBytes;
          });
        }
      });

      setState(() {
        downloading = false;
      });

      // Downloaded file path: $savePath
      doSomethingAfterDownload(savePath);
    } catch (e) {
      // $e
      setState(() {
        downloading = false;
      });
    }
  }

  Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    return '$appDocumentsPath/$fileName';
  }

  void doSomethingAfterDownload(String savePath) {
    FlutterAppInstaller.installApk(filePath: savePath).then((value) {
      // Installation successful
      // APK installation completed!
      // Perform your desired job here
    }).catchError((error) {
      // Installation failed
      // APK installation failed: $error
      // Handle the error if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                'Versiyon Numarası: $versionNumber',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Güncelleme Notları:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              RichText(
                text: TextSpan(
                  children: patchNotes
                      .split('. ')
                      .map((note) => TextSpan(
                            text: '$note\n',
                            style: const TextStyle(fontSize: 16),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  downloadFile(downloadUrl);
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0), // Adjust the padding as needed
                  ),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.green),
                  foregroundColor:
                      WidgetStateProperty.all<Color>(Colors.white),
                  overlayColor: WidgetStateProperty.all<Color>(
                      Colors.green.withValues(alpha: 0.8)),
                  elevation: WidgetStateProperty.all<double>(
                      0.0), // Remove the button shadow
                ),
                child: const Text('Güncelle'),
              ),
              if (downloading)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: downloadProgress,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(downloadProgress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:turkce_film_tv/firebase_options.dart';
import 'package:turkce_film_tv/provider/movie_provider.dart';
import 'package:turkce_film_tv/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkce_film_tv/screens/loginscreen.dart';
import 'package:turkce_film_tv/screens/updatescreen.dart';
import 'package:turkce_film_tv/services/focusnodeservice.dart';
import 'package:turkce_film_tv/services/focusservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  Future<String> getFirestoreVersion() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('AppVersion')
        .doc('latestVersion')
        .get();

    dynamic versionData = docSnapshot.data();
    if (versionData != null && versionData is Map<String, dynamic>) {
      return versionData['versionNumber'] as String;
    } else {
      return '1.0.0'; // Replace with your preferred fallback version
    }
  }

  String firestoreVersion = await getFirestoreVersion();
  String appVersion = packageInfo.version;
  // firestoreVersion: $firestoreVersion
  // appVersion: $appVersion

  bool isNewerVersionAvailable(String currentVersion, String latestVersion) {
    // Split the version numbers into their individual components
    List<int> currentVersionNumbers =
        currentVersion.split('.').map(int.parse).toList();
    List<int> latestVersionNumbers =
        latestVersion.split('.').map(int.parse).toList();

    // Compare the version numbers
    for (int i = 0; i < currentVersionNumbers.length; i++) {
      if (latestVersionNumbers.length <= i) {
        // All the numbers in the latest version have been checked
        return false; // No newer version available
      }

      if (latestVersionNumbers[i] > currentVersionNumbers[i]) {
        return true; // Newer version available
      } else if (latestVersionNumbers[i] < currentVersionNumbers[i]) {
        return false; // No newer version available
      }
    }

    // All numbers up to the current version's length are the same
    return latestVersionNumbers.length > currentVersionNumbers.length;
  }

  if (isNewerVersionAvailable(appVersion, firestoreVersion)) {
    runApp(
        const MaterialApp(debugShowCheckedModeBanner: false, home: UpdateScreen()));
  } else {
    // Load the app normally
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    ).then((_) async {
      final movieProvider = MovieProvider();
      await movieProvider.fetchMovies();

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<MovieProvider>.value(
          value: movieProvider,
        ),
        ChangeNotifierProvider<FocusServiceProvider>.value(
          value: FocusService.focusServiceProvider,
        ),
          ],
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'Carossoft',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.hasData) {
                  return const HomePage();
                } else {
                  return const LoginPage();
                }
              },
            ),
          ),
        ),
      );
    });
  }
}

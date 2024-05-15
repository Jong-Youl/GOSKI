// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDem2SkJIa9Gt460DR-T-9OijF1L4cE3Y',
    appId: '1:870373914042:web:3fa96e8e06120102a29983',
    messagingSenderId: '870373914042',
    projectId: 'goski-instructor',
    authDomain: 'goski-instructor.firebaseapp.com',
    storageBucket: 'goski-instructor.appspot.com',
    measurementId: 'G-LQPYWZ9HD0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwmS9p4HVoXVbgTZrianUo4SILfvp9yac',
    appId: '1:870373914042:android:2bb50cb931670e6ca29983',
    messagingSenderId: '870373914042',
    projectId: 'goski-instructor',
    storageBucket: 'goski-instructor.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAD-gqlfKbrM4JL6HbWi2TtBiMVTUBm9eY',
    appId: '1:870373914042:ios:6128335cad549d63a29983',
    messagingSenderId: '870373914042',
    projectId: 'goski-instructor',
    storageBucket: 'goski-instructor.appspot.com',
    iosBundleId: 'com.example.goskiInstructor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAD-gqlfKbrM4JL6HbWi2TtBiMVTUBm9eY',
    appId: '1:870373914042:ios:e2582478453a0345a29983',
    messagingSenderId: '870373914042',
    projectId: 'goski-instructor',
    storageBucket: 'goski-instructor.appspot.com',
    iosBundleId: 'com.example.goskiInstructor.RunnerTests',
  );
}

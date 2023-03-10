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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDbgGE1atZWteZ3D_nLF-lbVJwRvoEdfwA',
    appId: '1:317687638487:web:1e881b7b0180cf46fc8392',
    messagingSenderId: '317687638487',
    projectId: 'chats-5495b',
    authDomain: 'chats-5495b.firebaseapp.com',
    storageBucket: 'chats-5495b.appspot.com',
    measurementId: 'G-RCKZJCBGZ2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDbhYie5bWWMhyLermMjVQj_EuYnXc6-M',
    appId: '1:317687638487:android:e1ce8f608aef2437fc8392',
    messagingSenderId: '317687638487',
    projectId: 'chats-5495b',
    storageBucket: 'chats-5495b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeQxDTQWjNkeFDKHvc_7lFrKexxxx8c4A',
    appId: '1:317687638487:ios:737187843b2bd3b9fc8392',
    messagingSenderId: '317687638487',
    projectId: 'chats-5495b',
    storageBucket: 'chats-5495b.appspot.com',
    iosClientId: '317687638487-90r2r2g7duip99746bv8627eaf4r7vqq.apps.googleusercontent.com',
    iosBundleId: 'com.example.chats',
  );
}

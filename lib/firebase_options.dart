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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7hoGv7WT1ZI0fnD0B6U7D0iJLM8Wn9Ns',
    appId: '1:523020228481:web:5536505907ea750cd2ba80',
    messagingSenderId: '523020228481',
    projectId: 'flash-chat-a499e',
    authDomain: 'flash-chat-a499e.firebaseapp.com',
    storageBucket: 'flash-chat-a499e.appspot.com',
    measurementId: 'G-3GQYNLN510',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPXXMtY9JX4hrll16FSD-NRBldc4Fnxuo',
    appId: '1:523020228481:android:fd05723f84fcb5d5d2ba80',
    messagingSenderId: '523020228481',
    projectId: 'flash-chat-a499e',
    storageBucket: 'flash-chat-a499e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyeOs2awXTelCiUqE8WV0kwiuHLRW1M68',
    appId: '1:523020228481:ios:6f1715677e1ede64d2ba80',
    messagingSenderId: '523020228481',
    projectId: 'flash-chat-a499e',
    storageBucket: 'flash-chat-a499e.appspot.com',
    iosClientId: '523020228481-7jseeu26j221lfhqrs73341rnlk8001o.apps.googleusercontent.com',
    iosBundleId: 'co.akundadababalei.flashChat',
  );
}

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'No Web Firebase configuration provided. Add your Firebase configuration first.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS is not configured yet.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'MacOS is not supported.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows is not supported.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux is not supported.',
        );
      default:
        throw UnsupportedError(
          'Unknown platform $defaultTargetPlatform',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDUny5MkrQnHsKi4F1E7532UcjSSmKNqU',
    appId: '1:348531329854:android:4144308e5c6cd8fa93fa6f',
    messagingSenderId: '348531329854',
    projectId: 'readify-a7423',
    storageBucket: 'readify-a7423.firebasestorage.app',
  );
} 
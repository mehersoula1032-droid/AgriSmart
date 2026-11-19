import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Plateforme non configurée');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5yJSie7NJx2NfzuM2GxfKjf-5n0ngTRc',
    appId: '1:418460465519:android:85efb1320ab03fb74e109a',
    messagingSenderId: '418460465519',
    projectId: 'agrismart-iset-1a4ae',
    storageBucket: 'agrismart-iset-1a4ae.firebasestorage.app',
  );
}
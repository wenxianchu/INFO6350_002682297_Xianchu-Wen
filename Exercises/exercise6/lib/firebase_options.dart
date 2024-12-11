// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyA96CO505gnTDTbBNw3q76LpMmEmu22qF8',
    appId: '1:190478210417:web:c227400676185138e892d0',
    messagingSenderId: '190478210417',
    projectId: 'exercise6-d58db',
    authDomain: 'exercise6-d58db.firebaseapp.com',
    storageBucket: 'exercise6-d58db.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhts7c3KOLzEUX7N59xcdUXIIS4n2dGb0',
    appId: '1:190478210417:android:7fbb6ae0d071efd8e892d0',
    messagingSenderId: '190478210417',
    projectId: 'exercise6-d58db',
    storageBucket: 'exercise6-d58db.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyNBj-agmOIqhFuTWPuC0BxdQZhxNn8L8',
    appId: '1:190478210417:ios:7984e7d8d3193e11e892d0',
    messagingSenderId: '190478210417',
    projectId: 'exercise6-d58db',
    storageBucket: 'exercise6-d58db.firebasestorage.app',
    iosBundleId: 'com.example.exercise6',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyNBj-agmOIqhFuTWPuC0BxdQZhxNn8L8',
    appId: '1:190478210417:ios:7984e7d8d3193e11e892d0',
    messagingSenderId: '190478210417',
    projectId: 'exercise6-d58db',
    storageBucket: 'exercise6-d58db.firebasestorage.app',
    iosBundleId: 'com.example.exercise6',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA96CO505gnTDTbBNw3q76LpMmEmu22qF8',
    appId: '1:190478210417:web:5b97ad17c10b06a4e892d0',
    messagingSenderId: '190478210417',
    projectId: 'exercise6-d58db',
    authDomain: 'exercise6-d58db.firebaseapp.com',
    storageBucket: 'exercise6-d58db.firebasestorage.app',
  );
}

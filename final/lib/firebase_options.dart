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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
/*      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;*/
      case TargetPlatform.fuchsia:
        // TODO: Handle this case.
      case TargetPlatform.linux:
        // TODO: Handle this case.
      case TargetPlatform.windows:
        // TODO: Handle this case.
      case TargetPlatform.iOS:
        // TODO: Handle this case.
      case TargetPlatform.macOS:
        // TODO: Handle this case.
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1TUkdEtNbJqbKiaB14w71IOhUoZQRzgc',
    appId: '1:124721597369:android:f2eaab8f93be6f9c67c468',
    messagingSenderId: '124721597369',
    projectId: 'hypergaragesale-a643d',
    authDomain: 'hypergaragesale-a643d.firebaseapp.com',
    storageBucket: 'hypergaragesale-a643d.firebasestorage.app',
    measurementId: 'G-DGF0CP099H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1TUkdEtNbJqbKiaB14w71IOhUoZQRzgc',
    appId: '1:124721597369:android:f2eaab8f93be6f9c67c468',
    messagingSenderId: '124721597369',
    projectId: 'hypergaragesale-a643d',
    storageBucket: 'hypergaragesale-a643d.firebasestorage.app',
  );

}
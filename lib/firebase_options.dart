
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
    apiKey: 'AIzaSyCndL-ltQACizFvWUbhRHsEWJdHj4giMF0',
    appId: '1:461752841096:web:44cf29e6c6b89c2b35803d',
    messagingSenderId: '461752841096',
    projectId: 'f3-talk',
    authDomain: 'f3-talk.firebaseapp.com',
    storageBucket: 'f3-talk.appspot.com',
    measurementId: 'G-QCTKNHTCDG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1ouomYf1bJCn88DRk_6yWInu38rY1yHw',
    appId: '1:461752841096:android:179d903dad36ab1c35803d',
    messagingSenderId: '461752841096',
    projectId: 'f3-talk',
    storageBucket: 'f3-talk.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXOJbMIf6tx8MVIAgh00W7up4EC4qZSOM',
    appId: '1:461752841096:ios:71aa9bc0e92b7aa935803d',
    messagingSenderId: '461752841096',
    projectId: 'f3-talk',
    storageBucket: 'f3-talk.appspot.com',
    iosBundleId: 'com.example.f3Talk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXOJbMIf6tx8MVIAgh00W7up4EC4qZSOM',
    appId: '1:461752841096:ios:0c1c833a4f4ddeac35803d',
    messagingSenderId: '461752841096',
    projectId: 'f3-talk',
    storageBucket: 'f3-talk.appspot.com',
    iosBundleId: 'com.example.f3Talk.RunnerTests',
  );
}

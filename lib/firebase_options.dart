// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYu3L55Bt0dKRdLH5c71_geNxBLFQmBvs',
    appId: '1:470144478610:android:c88523f00d9c81a28a254b',
    messagingSenderId: '470144478610',
    projectId: 'niresto-alex',
    storageBucket: 'niresto-alex.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD92oGBEJTviWO6ObC7fiBUjsLX9ia88Qk',
    appId: '1:470144478610:ios:b85265ab7111b0e48a254b',
    messagingSenderId: '470144478610',
    projectId: 'niresto-alex',
    storageBucket: 'niresto-alex.appspot.com',
    iosClientId: '470144478610-gis1nskqrhqhnv91b3f2p4uk5tqcfiju.apps.googleusercontent.com',
    iosBundleId: 'de.niresto.app',
  );
}

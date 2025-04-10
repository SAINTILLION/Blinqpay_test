import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVATVkgxyMyy8mnQvf0_rSHbwnO2d4iCg',
    appId: '1:970650390015:android:df1b3410291f33963eabca',
    messagingSenderId: '970650390015',
    projectId: 'blinqpost',
    storageBucket: "blinqpost.appspot.com"
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDNzmaHZYiPrTfV7Y6yQ40IsX_t-iwWYA',
    appId: '1:970650390015:ios:df1b3410291f33963eabca',
    messagingSenderId: '970650390015',
    projectId: 'blinqpost',
    storageBucket: "blinqpost.appspot.com"
    
  );

  

}

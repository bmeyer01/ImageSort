import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAq4NIGG9uSV08dr470QPJeABCrWjRDCEI",
            authDomain: "photoid-c1bce.firebaseapp.com",
            projectId: "photoid-c1bce",
            storageBucket: "photoid-c1bce.appspot.com",
            messagingSenderId: "736196752000",
            appId: "1:736196752000:web:6150a9c6537062c1786c65"));
  } else {
    await Firebase.initializeApp();
  }
}

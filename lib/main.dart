import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final useFirebaseAuth = await _tryInitializeFirebase();
  runApp(UniLaneApp(useFirebaseAuth: useFirebaseAuth));
}

Future<bool> _tryInitializeFirebase() async {
  try {
    await Firebase.initializeApp();
    return true;
  } catch (_) {
    return false;
  }
}

import 'package:app/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app/authentication/login.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:app/authentication/signup.dart'; // If needed

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using google-services.json for Android
  await Firebase.initializeApp();
  await Permission.locationWhenInUse.isDenied.then((value){
    if (value) {
      Permission.locationWhenInUse.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Android App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: FirebaseAuth.instance.currentUser ==null ? LogIn(): HomePage(), // Replace with your actual start screen
    );
  }
}
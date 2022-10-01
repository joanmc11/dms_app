import 'package:dms_app/firebase_options.dart';
import 'package:dms_app/view/navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Team App',
      theme: ThemeData(
          primarySwatch: Colors.red, secondaryHeaderColor: Colors.yellow),
      home: NavigationPage(),
    );
  }
}

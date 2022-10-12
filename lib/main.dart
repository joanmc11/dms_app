import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms_app/firebase_options.dart';
import 'package:dms_app/service/user_pref_service.dart';
import 'package:dms_app/utils/wrapper.dart';
import 'package:dms_app/view/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  //User preferences
  final _prefs = UserPreferences();
  await _prefs.initPrefs();

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && _prefs.uid != "") {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: _prefs.uid)
          .get();

      if (snapshot.size == 0) {
        print(
            "El usuario está registrado pero no tiene documento en Firebase!");
        user = null;
      }
    }
    if (user != null && _prefs.uid != "") {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: _prefs.uid)
          .get();
      print("User logged: ${user.uid}");
      _prefs.uid = user.uid;

      final instance = await SharedPreferences.getInstance();
      final termsShown = instance.getBool("TermsPopUp");
      if (termsShown == null) {
        _prefs.loggedIn = true;
      } else {
        if (termsShown) {
          _prefs.loggedIn = false;
        } else {
          _prefs.loggedIn = true;
        }
      }
      
    } else {
      print("User not logged");
      _prefs.uid = "";
      _prefs.loggedIn = false;
    }
      

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Team App',
      theme: ThemeData(
          primarySwatch: Colors.red, secondaryHeaderColor: Colors.yellow),
      home: const Wrapper(),
    );
  }
}

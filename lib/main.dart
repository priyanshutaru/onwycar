// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:onwycar/BottomNavigationBar/BottomNavigation.dart';
import 'package:onwycar/Screens/HomePageRelatedScreens/DuplicateHomeScreen.dart';

import 'package:onwycar/auth/loginScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:onwycar/auth/signUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HelperFunctions/helperfunctions.dart';
import 'check_login_screen.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool openDialogue = false;
  void saveDialoguePreference() async {}
  @override
  void initState() {
    saveDialoguePreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        // textTheme: GoogleFonts.comicNeueTextTheme()
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 200,
        duration: 3000,
        nextScreen: check_login(),
        splash: Image.asset(
          "assets/logo.png",
          height: 150,
          width: 250,
        ),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

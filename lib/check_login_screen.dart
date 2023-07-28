import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/HomePageRelatedScreens/DuplicateHomeScreen.dart';
import 'auth/loginScreen.dart';
class check_login extends StatefulWidget {
  const check_login({Key? key}) : super(key: key);

  @override
  State<check_login> createState() => _check_loginState();
}

class _check_loginState extends State<check_login> {
  @override
  void initState() {
  super.initState();
  Timer(Duration(seconds: 0),() async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String? mobile=pref.getString('mobile');
    if(mobile!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DuplicateHome()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
  });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

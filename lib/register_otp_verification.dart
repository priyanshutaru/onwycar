import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onwycar/HelperFunctions/helperfunctions.dart';
import 'package:onwycar/Screens/HomePageRelatedScreens/DuplicateHomeScreen.dart';
import 'package:timer_count_down/timer_count_down.dart';

class RegisterOtpScreen extends StatefulWidget {
  const RegisterOtpScreen({Key? key,  required this.mobile}) : super(key: key);
  final String mobile;

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {

  TextEditingController otp = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String msg = '';


  Future verifyNumber() async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'loading..');
      var api = Uri.parse("https://onway.creditmywallet.in.net/api/verify_otp");
      Map mapeddate = {
        'mobile': widget.mobile.toString(),
        'otp': otp.text,
      };

      final response = await http.post(
        api,
        body: mapeddate,
      );

      var res = await json.decode(response.body);
      print("response" + response.body);
      msg = res["status_message"];


      print(msg);
      try {
        if (msg == "Login Successful") {
          HelperFunctions.saveuserID(res['mobile']);
          HelperFunctions.savedName(res['name']);
          HelperFunctions.savedEmail(res['email']);
          HelperFunctions.savedNumber(res['mobile']);
          Fluttertoast.showToast(msg: "Mobile Verified");
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          EasyLoading.dismiss();
          setState(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DuplicateHome(),
              ),
            );
          });
        }
        else if (msg == "Invalid OTP") {
          EasyLoading.dismiss();
          return Fluttertoast.showToast(
              msg: 'Invalid OTP');
        }
      } catch (e) {
        print(e);
        print(msg);
        EasyLoading.dismiss();
      }
    }
  }




  @override



  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/carimg.jpg'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    height: 120,
                  ),
                  Column(
                    children: [
                      Column(
                        children:const [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Enter OTP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                      Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(0)),
                              border:
                              Border.all(color: Colors.black, width: 0.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              // color: Colors.black12,

                              width: 300,
                              height: 170,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: otp,
                                            style:
                                            const TextStyle(color: Colors.black),
                                            decoration:const InputDecoration(

                                                hintText: 'Enter OTP',
                                                hintStyle: TextStyle(
                                                    color: Colors.black54,fontWeight: FontWeight.w500)),
                                          ),


                                        ],
                                      ),
                                    ),
                                    ButtonTheme(
                                      minWidth: 150.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          side: BorderSide(
                                              color: Colors.black, width: 0.5)),
                                      child: MaterialButton(
                                        elevation: 5.0,
                                        hoverColor: Colors.green,
                                        color: Colors.black,
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          verifyNumber();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: (){}, child: Text('Resend Otp : ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
                          Countdown(
                            seconds: 20,
                            build: (BuildContext context, double time) => Text(time.toString(),style: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.bold),),
                            interval: Duration(seconds: 1),
                            onFinished: () {
                              // print('Timer is done!');
                              Fluttertoast.showToast(msg: "Re-send OTP");
                            },
                          )

                        ],
                      ),

                    ],
                  ),


                ],
              )],
          ),
        ),
      ),
    );
  }
}

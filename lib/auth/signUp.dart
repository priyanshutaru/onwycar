import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Screens/HomePageRelatedScreens/DuplicateHomeScreen.dart';
import 'loginScreen.dart';
import 'package:onwycar/auth/OtpScreen.dart';
import 'package:http/http.dart' as http;
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {

TextEditingController _email=TextEditingController();
TextEditingController _name=TextEditingController();
TextEditingController _mobile=TextEditingController();
final formKey = GlobalKey<FormState>();
  Future Register() async {
    // await HelperFunctions.saveUserLoggedInSharedPreference(true);
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Loading...');
    var api = Uri.parse("https://bitacars.com/api/user_register");

      Map mapeddate = {
        'name': _name.text,
        'mobile': _mobile.text,
        'email': _email.text,
      };
      final response = await http.post(
      api,
      body: mapeddate,
    );
     String msg='';
    var res = await json.decode(response.body);
    print("response" + response.body);
    msg = res["status_message"];
    print(msg);

    try {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if(msg =='Registration Successful')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginOtpScreen(
            mobile: _mobile.text.toString(),
        )));}
      else if(msg =='Registration Successful'){
          EasyLoading.showSuccess("Registration successful");
          EasyLoading.dismiss();
          print(msg);

        }
      else if(msg=='Mobile Number is already Exists'){
          return Fluttertoast.showToast(msg: 'Mobile Number is already Exists');

        }else if(msg=='Email Id is already Exists'){
        return Fluttertoast.showToast(msg: 'Email Id is already Exists');

      }
      else{
          Fluttertoast.showToast(msg: 'Something Went Wrong');
        }
      }
      else{
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: 'Something Went Wrong');
      }
    } catch (e) {
      print(e);
    }}else{
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Fill all fields');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Column(
                    children: [
                      Column(
                        children: const[
                          SizedBox(height: 100,),
                          Text(
                            'Register Now',
                            style: TextStyle(
                              letterSpacing: 1,
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Card(
                        // color: Colors.black12,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              border:
                              Border.all(color: Colors.black, width: 0.5)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              // color: Colors.black12,
                              // color: Colors.transparent,
                              width: 300,
                              height: 240,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15,right: 15),
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
                                            controller: _name,
                                            style:
                                            TextStyle(color: Colors.black),
                                            decoration:const InputDecoration(
                                                hintText: 'Enter your name',
                                                hintStyle: TextStyle(
                                                   fontSize: 14,
                                                    color: Colors.black54)),
                                          ),
                                          TextFormField(
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            validator: (val) {
                                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(val!)
                                                  ? null : "Please provide a valid email";
                                            },
                                               controller: _email,
                                            style:
                                            TextStyle(color: Colors.black),
                                            decoration:const InputDecoration(
                                                hintText: 'Enter your email',
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                    color: Colors.black54)),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            validator: (val) {
                                            return val!.length == 10
                                                ? null
                                                : "Please enter 10 digit mobileNumber";
                                          },
                                            controller: _mobile,
                                            obscureText: false,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(10),
                                            ],
                                            style:
                                            TextStyle(color: Colors.black),
                                            decoration:const InputDecoration(
                                                hintText: 'Enter your mobile number',
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                    color: Colors.black54)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ButtonTheme(
                                      minWidth: 150.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          side:const BorderSide(
                                              color: Colors.teal, width: 1)),
                                      child: MaterialButton(
                                        elevation: 5.0,
                                        hoverColor: Colors.black,
                                        color: Colors.black,
                                        child:const Text(
                                          "Get OTP",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                     Register();
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
                      const SizedBox(
                        height: 20,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:  Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child:const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                  indent: 30,
                                  height: 36,
                                )),
                          ),
                          const  Text(
                            "OR",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child:  Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child:const Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                    height: 36,
                                    endIndent: 30)),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Already you have an account?",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),
                            TextButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>DuplicateHome()));
                            },
                            child: Text("Login",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.blue),))
                          ],
                        ),
                      )
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

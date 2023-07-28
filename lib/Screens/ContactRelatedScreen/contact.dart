import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../HomePageRelatedScreens/DuplicateHomeScreen.dart';
import '../ProfileRelatedScreens/profile.dart';
import '../TrackRelatedScreens/track.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _message = TextEditingController();

  Future Contect_Us_Api() async {
    Map data = {
      'name': _name.text.toString(),
      'email': _email.text.toString(),
      'mobile': _mobile.text.toString(),
      'address': _address.text.toString(),
      'message': _message.text.toString(),
    };
    Uri url = Uri.parse(" https://bitacars.com/api/contact_us");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    if (response.statusCode == 200) {
      var res = await json.decode(response.body);
      String msg = res['status_message'].toString();
      print("bjhgbvfjhdfgbfu====>..." + msg);
      if (msg == 'Success') {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: 'Successfully');
      } else {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Contect_Us_Api();
  }

  var email = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 00,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Support",
            style: TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            /* Container(
               decoration: BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage(
                           "assets/homebackgroundImage.png"
                       ),
                       fit: BoxFit.fill
                   )
               ),
             ),*/
            ListView(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      //height: MediaQuery.of(context).size.height/2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 60),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        // border: Border.all(width: 2,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // gradient: LinearGradient(
                        //     colors: [
                        //       Colors.greenAccent.shade200,
                        //       Colors.green.shade100,
                        //     ]
                        // ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: TextFormField(
                                controller: _name,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name.....';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _email,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    )),
                                validator: (value) {
                                  if (!(email.hasMatch(value!))) {
                                    return "Please provide a valid email";
                                  } else if (value == null || value.isEmpty) {
                                    return 'Please enter email.....';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _mobile,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Mobile No',
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter mobile no.....';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _address,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: 'Address',
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter address.....';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _message,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                decoration: InputDecoration(
                                    hintText: 'Message...............',
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1),
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter message.....';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Contect_Us_Api();
                                      Fluttertoast.showToast(
                                          msg: 'Successfully');
                                      _name.clear();
                                      _email.clear();
                                      _mobile.clear();
                                      _address.clear();
                                      _message.clear();
                                    } else {
                                      EasyLoading.dismiss();
                                    }
                                  },
                                  height: 50,
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          2.93,
                                      right: MediaQuery.of(context).size.width /
                                          2.93),
                                  color: Colors.green,
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black87.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) {
            // Respond to item press.
            setState(() => _currentIndex = value);
            if (_currentIndex == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DuplicateHome()));
            } else if (_currentIndex == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Contact()));
            } else if (_currentIndex == 2) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Track()));
            } else if (_currentIndex == 3) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            }
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(FontAwesomeIcons.home),
            ),
            BottomNavigationBarItem(
              label: 'Contact',
              icon: Icon(FontAwesomeIcons.phoneAlt),
            ),
            BottomNavigationBarItem(
              label: 'Booking',
              icon: Icon(FontAwesomeIcons.addressBook),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(CupertinoIcons.profile_circled),
            ),
          ],
        ));
  }
}

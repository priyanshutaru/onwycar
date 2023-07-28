import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileVerification extends StatefulWidget {
  String user_id, verification_status;
  ProfileVerification(
      {required this.user_id, required this.verification_status});

  @override
  State<ProfileVerification> createState() => _ProfileVerificationState();
}

class _ProfileVerificationState extends State<ProfileVerification> {
  final picker = ImagePicker();
  File? frontDrivingLicense;
  File? backDrivingLicense;
  File? frontAadharCard;
  File? backAadharCard;

  TextEditingController _driving_no = TextEditingController();
  TextEditingController _addhar_no = TextEditingController();
  String? profile_status;
  Future ProfileVerification() async {
    String addhar1 = frontAadharCard!.path.split('/').last;
    String addhar2 = backAadharCard!.path.split('/').last;
    String driving1 = frontDrivingLicense!.path.split('/').last;
    String driving2 = backDrivingLicense!.path.split('/').last;
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': '${widget.user_id}'.toString(),
      'aadhar_number': _addhar_no.text.toString(),
      'aadhar_front': await MultipartFile.fromFile(frontAadharCard!.path,
          filename: addhar1),
      'aadhar_back':
          await MultipartFile.fromFile(backAadharCard!.path, filename: addhar2),
      'dl_number': _driving_no.text.toString(),
      'dl_front': await MultipartFile.fromFile(frontDrivingLicense!.path,
          filename: driving1),
      'dl_back': await MultipartFile.fromFile(backDrivingLicense!.path,
          filename: driving2),
    });
    var response = await dio.post(
        'https://onway.creditmywallet.in.net/api/user_profile_verification',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    String msg = res['status_message'];
    print("bjhgbvfjhdfgbfu====>..." + msg);
    if (msg == 'Success') {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Verify Profile Successfully');
      Navigator.pop(context);
    } else {
      EasyLoading.dismiss();
    }
  }

  Future frontDrivingLicense1(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        frontDrivingLicense = new File(pickedFile.path);
        print(frontDrivingLicense!.path);
      });
    }
  }

  Future backDrivingLicense2(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        backDrivingLicense = new File(pickedFile.path);
        print(backDrivingLicense!.path);
      });
    }
  }

  Future frontAadharCard1(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        frontAadharCard = new File(pickedFile.path);
        print(frontAadharCard!.path);
      });
    }
  }

  Future backAadharCard2(context, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        backAadharCard = new File(pickedFile.path);
        print(backAadharCard!.path);
      });
    }
  }

  var status;
  @override
  void initState() {
    super.initState();
    setState(() {
      status = '${widget.verification_status.toString()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('PROFILE VERIFICATION'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: status == "0"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        'only few steps left to complete. Upload remaining documents to continue using On Way Car',
                        style: GoogleFonts.lato(
                            fontSize: 15, color: Colors.black54),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Text(
                          'VERIFY PROFILE IN 2 SIMPLE STEPS',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1',
                          style: GoogleFonts.lato(
                              fontSize: 18, color: Colors.black54),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Upload Driving License',
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.black54))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: _driving_no,
                        decoration: InputDecoration(
                            hintText: 'Driving License Number',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print('love');
                        // frontDrivingLicense1(context, ImageSource.camera);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Please upload the image"),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text("Camera"),
                                  onPressed: () {
                                    frontDrivingLicense1(
                                        context, ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: Text("Gallery"),
                                  onPressed: () {
                                    frontDrivingLicense1(
                                        context, ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 600,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.pink.shade50, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: frontDrivingLicense == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.add_circled,
                                        ),
                                        Text(
                                          'Upload front picture of driving license',
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                  )
                                : Image.file(frontDrivingLicense!,
                                    fit: BoxFit.fitWidth),
                          ),
                          Positioned(
                              right: 5,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    frontDrivingLicense = null;
                                  });
                                },
                                icon: Icon(Icons.highlight_remove),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print('love');
                        // backDrivingLicense2(context, ImageSource.camera);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Please upload the image"),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text("Camera"),
                                  onPressed: () {
                                    backDrivingLicense2(
                                        context, ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: Text("Gallery"),
                                  onPressed: () {
                                    backDrivingLicense2(
                                        context, ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 600,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.pink.shade50, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: backDrivingLicense == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.add_circled,
                                        ),
                                        Text(
                                          'Upload back picture of driving license',
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                  )
                                : Image.file(backDrivingLicense!,
                                    fit: BoxFit.fitWidth),
                          ),
                          Positioned(
                              right: 5,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    backDrivingLicense = null;
                                  });
                                },
                                icon: Icon(Icons.highlight_remove),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('2',
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.black54)),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Upload Addhar Card',
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.black54))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: _addhar_no,
                        decoration: InputDecoration(
                            hintText: 'Addhar Card  Number',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print('love');
                        //frontAadharCard1(context, ImageSource.camera);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Please upload the image"),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text("Camera"),
                                  onPressed: () {
                                    frontAadharCard1(
                                        context, ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: Text("Gallery"),
                                  onPressed: () {
                                    frontAadharCard1(
                                        context, ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Stack(children: [
                        Container(
                          height: 200,
                          width: 600,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.pink.shade50, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: frontAadharCard == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.add_circled,
                                      ),
                                      const Text(
                                        'Upload front picture of Aadhaar Card',
                                        style: TextStyle(),
                                      )
                                    ],
                                  ),
                                )
                              : Image.file(frontAadharCard!,
                                  fit: BoxFit.fitWidth),
                        ),
                        Positioned(
                            right: 5,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  frontAadharCard = null;
                                });
                              },
                              icon: Icon(Icons.highlight_remove),
                            ))
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print('love');
                        //backAadharCard2(context, ImageSource.camera);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Please upload the image"),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text("Camera"),
                                  onPressed: () {
                                    backAadharCard2(
                                        context, ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: Text("Gallery"),
                                  onPressed: () {
                                    backAadharCard2(
                                        context, ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 600,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.pink.shade50, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: backAadharCard == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.add_circled,
                                        ),
                                        Text(
                                          'Upload back picture of  Aadhaar Card',
                                          style: TextStyle(),
                                        )
                                      ],
                                    ),
                                  )
                                : Image.file(backAadharCard!,
                                    fit: BoxFit.fitWidth),
                          ),
                          Positioned(
                              right: 5,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    backAadharCard = null;
                                  });
                                },
                                icon: Icon(Icons.highlight_remove),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150,
                    )
                  ],
                )
              : status == "1"
                  ? Card(
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.amberAccent.shade400,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.arrow_clockwise_circle_fill,
                              color: Colors.white,
                              size: 90,
                            ),
                            Text(
                              "Verification Processing",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  : status == "2"
                      ? Card(
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 3.5,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.green,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.checkmark_circle_fill,
                                  color: Colors.white,
                                  size: 90,
                                ),
                                Text(
                                  "Verification Verified",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      : status == "3"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    'only few steps left to complete. Upload remaining documents to continue using On Way Car',
                                    style: GoogleFonts.lato(
                                        fontSize: 15, color: Colors.black54),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    child: Text(
                                      'VERIFY PROFILE IN 2 SIMPLE STEPS',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                status == "3"
                                    ? Card(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5.5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.red,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.nosign,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                              Text(
                                                "Verification Rejected",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Documents Upload Again",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1',
                                      style: GoogleFonts.lato(
                                          fontSize: 18, color: Colors.black54),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Upload Driving License',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54))
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: TextFormField(
                                    controller: _driving_no,
                                    decoration: InputDecoration(
                                        hintText: 'Driving License Number',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black38),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    // frontDrivingLicense1(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                frontDrivingLicense1(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                frontDrivingLicense1(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.pink.shade50,
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: frontDrivingLicense == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .add_circled,
                                                    ),
                                                    Text(
                                                      'Upload front picture of driving license',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(frontDrivingLicense!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                frontDrivingLicense = null;
                                              });
                                            },
                                            icon: Icon(Icons.highlight_remove),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    // backDrivingLicense2(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                backDrivingLicense2(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                backDrivingLicense2(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.pink.shade50,
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: backDrivingLicense == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .add_circled,
                                                    ),
                                                    Text(
                                                      'Upload back picture of driving license',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(backDrivingLicense!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                backDrivingLicense = null;
                                              });
                                            },
                                            icon: Icon(Icons.highlight_remove),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('2',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Upload Addhar Card',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54))
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: TextFormField(
                                    controller: _addhar_no,
                                    decoration: InputDecoration(
                                        hintText: 'Addhar Card  Number',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black38),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    //frontAadharCard1(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                frontAadharCard1(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                frontAadharCard1(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(children: [
                                    Container(
                                      height: 200,
                                      width: 600,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.pink.shade50,
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: frontAadharCard == null
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.add_circled,
                                                  ),
                                                  const Text(
                                                    'Upload front picture of Aadhaar Card',
                                                    style: TextStyle(),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Image.file(frontAadharCard!,
                                              fit: BoxFit.fitWidth),
                                    ),
                                    Positioned(
                                        right: 5,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              frontAadharCard = null;
                                            });
                                          },
                                          icon: Icon(Icons.highlight_remove),
                                        ))
                                  ]),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    //backAadharCard2(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                backAadharCard2(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                backAadharCard2(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.pink.shade50,
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: backAadharCard == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .add_circled,
                                                    ),
                                                    Text(
                                                      'Upload back picture of  Aadhaar Card',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(backAadharCard!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                backAadharCard = null;
                                              });
                                            },
                                            icon: Icon(Icons.highlight_remove),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 150,
                                )
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    'only few steps left to complete. Upload remaining documents to continue using On Way Car',
                                    style: GoogleFonts.lato(
                                        fontSize: 15, color: Colors.black54),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    child: Text(
                                      'VERIFY PROFILE IN 2 SIMPLE STEPS',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1',
                                      style: GoogleFonts.lato(
                                          fontSize: 18, color: Colors.black54),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Upload Driving License',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54))
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: TextFormField(
                                    controller: _driving_no,
                                    decoration: InputDecoration(
                                        hintText: 'Driving License Number',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black38),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    // frontDrivingLicense1(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                frontDrivingLicense1(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                frontDrivingLicense1(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.pink.shade50,
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: frontDrivingLicense == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .add_circled,
                                                    ),
                                                    Text(
                                                      'Upload front picture of driving license',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(frontDrivingLicense!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                frontDrivingLicense = null;
                                              });
                                            },
                                            icon: Icon(Icons.highlight_remove),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    // backDrivingLicense2(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                backDrivingLicense2(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                backDrivingLicense2(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.pink.shade50,
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: backDrivingLicense == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .add_circled,
                                                    ),
                                                    Text(
                                                      'Upload back picture of driving license',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(backDrivingLicense!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                backDrivingLicense = null;
                                              });
                                            },
                                            icon: Icon(Icons.highlight_remove),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('2',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Upload Addhar Card',
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black54))
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: TextFormField(
                                    controller: _addhar_no,
                                    decoration: InputDecoration(
                                        hintText: 'Addhar Card  Number',
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black38),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    //frontAadharCard1(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                frontAadharCard1(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                frontAadharCard1(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(children: [
                                    Container(
                                      height: 200,
                                      width: 600,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.pink.shade50,
                                              width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: frontAadharCard == null
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.add_circled,
                                                  ),
                                                  const Text(
                                                    'Upload front picture of Aadhaar Card',
                                                    style: TextStyle(),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Image.file(frontAadharCard!,
                                              fit: BoxFit.fitWidth),
                                    ),
                                    Positioned(
                                        right: 5,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              frontAadharCard = null;
                                            });
                                          },
                                          icon: Icon(Icons.highlight_remove),
                                        ))
                                  ]),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('love');
                                    //backAadharCard2(context, ImageSource.camera);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("Camera"),
                                              onPressed: () {
                                                backAadharCard2(context,
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            MaterialButton(
                                              child: Text("Gallery"),
                                              onPressed: () {
                                                backAadharCard2(context,
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 600,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.pink.shade50,
                                                width: 2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: backAadharCard == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .add_circled,
                                                    ),
                                                    Text(
                                                      'Upload back picture of  Aadhaar Card',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Image.file(backAadharCard!,
                                                fit: BoxFit.fitWidth),
                                      ),
                                      Positioned(
                                          right: 5,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                backAadharCard = null;
                                              });
                                            },
                                            icon: Icon(Icons.highlight_remove),
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 150,
                                )
                              ],
                            ),
        ),
      ),
    );
  }

  Widget FloatingButton() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 0.5),
          color: Colors.white70,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(thickness: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('By Continuing, you are agree to applicable '),
              InkWell(
                  child: Text(
                "T&Cs",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.lightGreen),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: ElevatedButton(
              onPressed: () async {
                ProfileVerification();
                setState(() {
                  
                });
              },
              child: Text('Verify Profile Now'),
              style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
class CoDriverInformation extends StatefulWidget {
  const CoDriverInformation({Key? key}) : super(key: key);

  @override
  State<CoDriverInformation> createState() => _CoDriverInformatioonState();
}

class _CoDriverInformatioonState extends State<CoDriverInformation> {
  final picker = ImagePicker();
  File? frontDrivingLicense;
  File? backDrivingLicense;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5,title: Text('Enter Co-Driver Information'),foregroundColor: Colors.black,backgroundColor: Colors.white,),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
           TextFormField(
             decoration: InputDecoration(
               hintText: 'Enter your name',border:  OutlineInputBorder(
               borderRadius: const BorderRadius.all(
                 const Radius.circular(10.0),
               ),
               borderSide: BorderSide(
                 width: 0.5,
                 style: BorderStyle.none,
               ),
             ),
             ),
           ),
            SizedBox(
              height: 10,
            ),
            Text('Upload Driving License',
                style:
                GoogleFonts.lato(fontSize: 18, color: Colors.black54)),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                print('love');
                frontDrivingLicense1(context, ImageSource.camera);
              },
              child: Container(
                height: 200,
                width: 600,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink.shade50, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: frontDrivingLicense == null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    : Image.file(frontDrivingLicense!, fit: BoxFit.fitWidth),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                print('love');
                backDrivingLicense2(context, ImageSource.camera);
              },
              child: Container(
                height: 200,
                width: 600,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink.shade50, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: backDrivingLicense == null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    : Image.file(backDrivingLicense!, fit: BoxFit.fitWidth),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.lightGreen),onPressed: (){}, child: Text('Upload'))
          ],
        ),
      ),
    ),
    );
  }
}

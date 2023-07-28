import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../profile.dart';

class AccountScreen extends StatefulWidget {
   AccountScreen({required this.name,required this.email,required this.mobileNo});
  String mobileNo,email,name;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  TextEditingController _email=TextEditingController();
  TextEditingController _name=TextEditingController();
  String dropdownValue = 'Male';
  String citiesvalue = 'Delhi';

  List cityItemlist = [];
  Future  getAllCity() async {
    var baseUrl = "https://onway.creditmywallet.in.net/api/city";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)["response_userRegister"];
      setState(() {
        cityItemlist=jsonData;
        print("@@@@@@@@@@@@@@@@===>>>>>>"+cityItemlist.toString());
      });
    }
  }
  var dropdownvalue;
  var email1,name1;

  @override
  void initState() {
    super.initState();
    setState(() {
      getAllCity();
      email1="${widget.email.toString()}";
      name1="${widget.name.toString()}";
      _email.text=email1.toString();
      _name.text=name1.toString();
    });
  }
  Future update_user_account()async{
    Map data={
    'mobile': widget.mobileNo.toString(),
    'email':_email.text.toString(),
    'gender':dropdownValue.toString(),
    'name': _name.text.toString(),
    'city': dropdownvalue.toString(),

    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/update_user_account");
    var body1= jsonEncode(data);
    var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: body1);
    if(response.statusCode==200){
      var res = await json.decode(response.body);
      String msg= res['status_message'].toString();
      print("bjhgbvfjhdfgbfu====>..."+msg);
      if(msg=='Success'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: 'Update Successfully');
      }else{
        EasyLoading.dismiss();
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(backgroundColor: Colors.white,foregroundColor: Colors.black,elevation: 0.5,title: Text('Update Account'),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    'My Account',
                    style: GoogleFonts.share(fontSize: 25),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                ),
                Text(
                  ' Account Details',
                  style: GoogleFonts.share(fontSize: 18),
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Email'),
                    /*Text('${widget.email.toString()}')*/
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 40,
                      child: TextFormField(
                        controller: _email,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                            hintStyle:TextStyle(fontSize: 16,color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white),
                            ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address.....';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Mobile*'),
                    Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all()),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text('${widget.mobileNo.toString()}'))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Personal Details',
                  style: GoogleFonts.lato(fontSize: 18),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Name *'),
                    // Text('${widget.name.toString()}')
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 40,
                      child: TextFormField(
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                          hintStyle:TextStyle(fontSize: 16,color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address.....';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender'),
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all()),
                      padding: EdgeInsets.symmetric(horizontal: 10,),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Padding(
                            padding:  EdgeInsets.only(left: 60.0),
                            child:  Icon(Icons.arrow_drop_down),
                          ),
                          elevation: 16,
                          style:TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              print("gender value+===>>"+dropdownValue);
                            });
                          },
                          items: <String>['Male', 'Female', 'Others']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Location Details',
                  style: GoogleFonts.lato(fontSize: 18),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2,
                  color: Colors.black,
                ),
                Text(
                  'Please share your current city for optimized experience.',
                  style: TextStyle(fontSize: 13.5, color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('City'),
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all()),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonHideUnderline(
                        child:
                        DropdownButton(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                          hint: Text('City',style: TextStyle(color: Colors.black),),
                          items: cityItemlist.map((item) {
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(item['city_name'].toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                              print("Value=======>>>>>"+dropdownvalue.toString());
                            });
                          },
                          value: dropdownvalue,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                      onPressed: (){
                        update_user_account();
                        setState(() {

                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                        },
                      child: Text('Update')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

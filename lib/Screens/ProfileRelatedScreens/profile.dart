import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onwycar/Screens/ProfileRelatedScreens/AcoountScreens/accountScreen.dart';
import 'package:onwycar/Screens/ProfileRelatedScreens/Mybookings/myBoookings.dart';
import 'package:onwycar/Screens/ProfileRelatedScreens/ProfileVerification/profileVerification.dart';
import 'package:onwycar/Screens/ProfileRelatedScreens/TransactionHistory/TransactionHistory.dart';
import 'package:onwycar/Screens/ProfileRelatedScreens/WalletScreen/WalletScreen.dart';
import 'package:onwycar/auth/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ContactRelatedScreen/contact.dart';
import '../HomePageRelatedScreens/DuplicateHomeScreen.dart';
import '../TrackRelatedScreens/track.dart';
import 'CoDriver/COdriverInformationScreen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 3;
  Color grey = Colors.grey;
  String? Mobile;
  var name, email, profile_pic, user_wallet, user_id;
  var verification_status;
  @override
  void initState() {
    super.initState();
    _getValue();
    setState(() {
      getProfile(Mobile);
      _setValue(user_wallet);
    });
  }

  Future getProfile(Mobile) async {
    Map data = {
      'mobile': Mobile.toString(),
    };
    Uri url = Uri.parse("https://bitacars.com/api/get_profile");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    var res = await json.decode(response.body);
    var res1 = res['response_userRegister'];
    setState(() {
      name = res1['name'];
      email = res1['email'];
      profile_pic = res1['profile_pic'];
      user_wallet = res1['user_wallet'];
      user_id = res1['id'];
      _setValue(user_wallet);
    });
    print('data=========>>>>>>>>' + name.toString());
    print('data=========>>>>>>>>' + email.toString());
    print('data=========>>>>>>>>' + profile_pic.toString());
    verification_status = res['verification_status'];
    print("hgvuhuygfu==--->>" + verification_status.toString());
    if (response.statusCode == 200) {}
  }

  void _setValue(user_wallet) async {
    final pref = await SharedPreferences.getInstance();
    final set2 = pref.setString('user_wallet', user_wallet);
    print("hdusifgudsigfiu==>>>=++++" + set2.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0.5,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: profile_pic == null
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 50,
                          child: Image(
                            image: NetworkImage(
                                'https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png'),
                          ))
                      : Container(
                          height: 110,
                          width: 110,
                          child: ClipOval(
                            child: Image.network(
                              '${profile_pic.toString()}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                )),
                name == null
                    ? Text("Onway Car", style: TextStyle(fontSize: 18))
                    : Text('${name.toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  Mobile.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                email == null
                    ? Text("onwaycar123@gmail.com")
                    : Text(
                        '${email.toString()}',
                        style: TextStyle(color: Colors.grey),
                      ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, right: 8.0, left: 8.0, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      /*  Navigator.push(context,
                        MaterialPageRoute(builder: (context) => manageAddress()));*/
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profile Document',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            verification_status == "0"
                                ? Icon(
                                    CupertinoIcons
                                        .exclamationmark_triangle_fill,
                                    color: Colors.amberAccent.shade200,
                                  )
                                : verification_status == "1"
                                    ? Icon(
                                        CupertinoIcons
                                            .arrow_clockwise_circle_fill,
                                        color: Colors.amberAccent.shade400,
                                      )
                                    : verification_status == "2"
                                        ? Icon(
                                            CupertinoIcons
                                                .checkmark_circle_fill,
                                            color: Colors.green,
                                          )
                                        : verification_status == "3"
                                            ? Icon(
                                                CupertinoIcons.nosign,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                CupertinoIcons
                                                    .exclamationmark_triangle_fill,
                                                color:
                                                    Colors.amberAccent.shade200,
                                              )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mobile Number',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.lightGreen,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Wallet ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            verification_status == "0"
                                ? Icon(
                                    CupertinoIcons
                                        .exclamationmark_triangle_fill,
                                    color: Colors.amberAccent.shade200,
                                  )
                                : verification_status == "1"
                                    ? Icon(
                                        CupertinoIcons
                                            .arrow_clockwise_circle_fill,
                                        color: Colors.amberAccent.shade400,
                                      )
                                    : verification_status == "2"
                                        ? Icon(
                                            CupertinoIcons
                                                .checkmark_circle_fill,
                                            color: Colors.green,
                                          )
                                        : verification_status == "3"
                                            ? Icon(
                                                CupertinoIcons.nosign,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                CupertinoIcons
                                                    .exclamationmark_triangle_fill,
                                                color:
                                                    Colors.amberAccent.shade200,
                                              )
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WalletScreen(
                                  user_id: user_id.toString(),
                                  user_wallet: user_wallet.toString(),
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8.0, left: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.wallet,
                              color: grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Wallet',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            user_wallet == null
                                ? Text('₹ 0',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold))
                                : (int.parse('${user_wallet.toString()}')) >= 0
                                    ? Text('₹' + ' ${user_wallet.toString()}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold))
                                    : Text('₹' + '00',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Track()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8.0, left: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              Icons.library_books_outlined,
                              color: grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'My Booking',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          children: [Icon(Icons.arrow_forward_ios_rounded)],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => transactionHisory(
                                  user_id: user_id.toString(),
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8.0, left: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.history,
                              color: grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Transaction History',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          children: [Icon(Icons.arrow_forward_ios_rounded)],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountScreen(
                            name: '${name.toString()}',
                            email: '${email.toString()}',
                            mobileNo: Mobile.toString(),
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8.0, left: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.addressCard,
                              color: grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Account',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          children: [Icon(Icons.arrow_forward_ios_rounded)],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileVerification(
                                  user_id: user_id.toString(),
                                  verification_status:
                                      verification_status.toString(),
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8.0, left: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.print,
                              color: grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Profile Verification',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          children: [Icon(Icons.arrow_forward_ios_rounded)],
                        )
                      ],
                    ),
                  ),
                ),
                /* Divider(
                thickness: 2,
              ),
              InkWell(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CoDriverInformation()));
              },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, right: 8.0, left: 8.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.car,color: Colors.grey,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Co- Driver')
                        ],
                      ),
                      Row(
                        children: [Icon(Icons.arrow_forward_ios_rounded)],
                      )
                    ],
                  ),
                ),
              ), */
                Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Log Out"),
                          actions: <Widget>[
                            MaterialButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            MaterialButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.remove('mobile');
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (Route<dynamic> route) => false);
                              },
                            )
                          ],
                        );
                      },
                    );
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8.0, left: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              color: grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Log Out',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Row(
                          children: [Icon(Icons.arrow_forward_ios_rounded)],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
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

  _getValue() async {
    final pref = await SharedPreferences.getInstance();
    String? get1 = pref.getString('mobile');
    getProfile(get1);
    setState(() {
      Mobile = get1!;
      print("jcbgkgc dggeg fgcg===>>>----" + Mobile.toString());
    });
  }
}

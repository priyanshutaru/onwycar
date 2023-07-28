import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/MyBooking.dart';
import '../../model/mybookSlot.dart';
import '../ContactRelatedScreen/contact.dart';
import '../HomePageRelatedScreens/AvailableCars.dart';
import '../HomePageRelatedScreens/DuplicateHomeScreen.dart';
import '../ProfileRelatedScreens/Mybookings/myBoookings.dart';
import '../ProfileRelatedScreens/profile.dart';
import 'Extract_page.dart';

class Track extends StatefulWidget {
  const Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  var Mobile;
  var booking_id;
  var city, vehicleID;
  Future<List<ResponseUserRegister>> getMyBooking() async {
    Map data1 = {
      /*'mobile':'8423474642',*/
      'mobile': Mobile.toString(),
    };
    Uri url = Uri.parse("https://bitacars.com/api/my_booking_list");
    var body1 = jsonEncode(data1);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body1);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data = json.decode(response.body)["response_userRegister"];
      /* booking_id=data[0]['booking_id'];
       print("slot data====>>>>>"+booking_id);*/
      return data.map((data) => ResponseUserRegister.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<Response>> getMyBookSlot() async {
    Map data1 = {
      'vehicle_id': vehicleID.toString(),
      'city': city.toString(),
    };
    Uri url = Uri.parse("https://bitacars.com/api/get_vehicle_slot");
    var body1 = jsonEncode(data1);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body1);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data = json.decode(response.body)["response"];
      /* booking_id=data[0]['booking_id'];
       print("slot data====>>>>>"+booking_id);*/
      return data.map((data) => Response.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  var vehiclename, picDate, picTime, vehicleImage, tax, slot_km;
  @override
  void initState() {
    super.initState();
    getMyBooking();
    getMyBookSlot();
    setState(() {});
    _getValue();
  }

  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 00,
            centerTitle: true,
            /* flexibleSpace: Container(
        decoration:const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[Colors.blue, Colors.green]))),*/
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: const Text('My Booking',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            /*const TabBar(
            labelPadding: EdgeInsets.only(left: 60, right: 60),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4,
                  color: Colors.white,
                ),
                insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Cars',
              ),
              Tab(
                text: 'Bikes',
              ),
            ],
          ),*/
          ),
          body: FutureBuilder<List<ResponseUserRegister>>(
              future: getMyBooking(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<ResponseUserRegister>? data = snapshot.data;
                  return Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      // Text('My Booking',
                                      //     style: TextStyle(
                                      //       fontSize: 22,
                                      //         color: Colors.green,
                                      //         fontWeight: FontWeight.bold)),
                                      // SizedBox(height: 20,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Booking Status',
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    booking_id = data[index]
                                                        .bookingId
                                                        .toString();
                                                    print("Booking id ==>>>>" +
                                                        booking_id);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyBookings(
                                                                      booking_id:
                                                                          booking_id
                                                                              .toString(),
                                                                    )));
                                                  },
                                                  child: Text(
                                                    data[index]
                                                        .invoiceId
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      booking_id = data[index]
                                                          .bookingId
                                                          .toString();
                                                      print(
                                                          "Booking id ==>>>>" +
                                                              booking_id);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MyBookings(
                                                                        booking_id:
                                                                            booking_id.toString(),
                                                                      )));
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                data[index]
                                                        .image
                                                        .toString()
                                                        .isEmpty
                                                    ? Container(
                                                        height: 80,
                                                        child: Image.asset(
                                                          'assets/car.jpg',
                                                          scale: 4,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 80,
                                                        child: Image.network(
                                                          data[index]
                                                              .image
                                                              .toString(),
                                                          scale: 4,
                                                        ),
                                                      ),
                                                Text(data[index]
                                                    .vehicleName
                                                    .toString()),
                                                Text(
                                                  data[index]
                                                      .vehilceNo
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54),
                                                )
                                              ],
                                            ),
                                            const VerticalDivider(
                                              thickness: 2,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      CupertinoIcons
                                                          .largecircle_fill_circle,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                        '---------------------------'),
                                                    Icon(
                                                      CupertinoIcons
                                                          .largecircle_fill_circle,
                                                      color: Colors.lightGreen,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: const [
                                                    Text('Start',
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        )),
                                                    SizedBox(
                                                      width: 70,
                                                    ),
                                                    Text('End',
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      data[index]
                                                          .startDate
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      data[index]
                                                          .dropDate
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      data[index]
                                                          .startTime
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    const SizedBox(
                                                      width: 50,
                                                    ),
                                                    Text(
                                                      data[index]
                                                          .dropTime
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      data[index].bookingStatus.toString() ==
                                              "0"
                                          ? const Text(
                                              "Booked",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            )
                                          : data[index]
                                                      .bookingStatus
                                                      .toString() ==
                                                  "1"
                                              ? const Text(
                                                  "Booked",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                )
                                              : data[index]
                                                          .bookingStatus
                                                          .toString() ==
                                                      "2"
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          vehiclename =
                                                              data[index]
                                                                  .vehicleName
                                                                  .toString();
                                                          picDate = data[index]
                                                              .startDate
                                                              .toString();
                                                          picTime = data[index]
                                                              .startTime
                                                              .toString();
                                                          vehicleImage =
                                                              data[index]
                                                                  .image
                                                                  .toString();
                                                          city = data[index]
                                                              .cityId
                                                              .toString();
                                                          vehicleID =
                                                              data[index]
                                                                  .vehicleId
                                                                  .toString();
                                                          booking_id =
                                                              data[index]
                                                                  .bookingId
                                                                  .toString();
                                                        });
                                                        dilog();
                                                        getMyBookSlot();
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 35,
                                                        width: 80,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.green,
                                                        ),
                                                        child: const Text(
                                                          "Extend",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : data[index]
                                                              .bookingStatus
                                                              .toString() ==
                                                          "3"
                                                      ? const Text(
                                                          "End Ride",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : data[index]
                                                                  .bookingStatus
                                                                  .toString() ==
                                                              "4"
                                                          ? const Text(
                                                              "Canceled",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : const Text(
                                                              "Booked",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          // TabBarView(
          //   children: <Widget>[
          //
          //     Bike(),
          //   ],
          // ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DuplicateHome()));
              } else if (_currentIndex == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Contact()));
              } else if (_currentIndex == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Track()));
              } else if (_currentIndex == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              }
            },
            items: [
              const BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(FontAwesomeIcons.home),
              ),
              const BottomNavigationBarItem(
                label: 'Contact',
                icon: Icon(FontAwesomeIcons.phoneAlt),
              ),
              const BottomNavigationBarItem(
                label: 'Booking',
                icon: Icon(FontAwesomeIcons.addressBook),
              ),
              const BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(CupertinoIcons.profile_circled),
              ),
            ],
          )),
    );
  }

  _getValue() async {
    final pref = await SharedPreferences.getInstance();
    String? get1 = pref.getString('mobile');
    getMyBooking();
    setState(() {
      Mobile = get1!;
      print("jcbgkgc dggeg fgcg===>>>----" + Mobile.toString());
    });
  }

  dilog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Slot",
            textAlign: TextAlign.center,
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(
                    thickness: 4,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: FutureBuilder<List<Response>>(
                        future: getMyBookSlot(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            List<Response>? data = snapshot.data;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    10,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                padding:
                                                    const EdgeInsets.all(3),
                                                margin:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors
                                                      .lightGreen.shade400,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "₹ " +
                                                          data[index]
                                                              .fixRate
                                                              .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      data[index]
                                                              .fixKm
                                                              .toString() +
                                                          "Km",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  var totalAmount = data[index]
                                                      .fixRate
                                                      .toString();
                                                  slot_km = data[index]
                                                      .fixKm
                                                      .toString();
                                                  int discount = ((int.parse(
                                                          totalAmount
                                                              .toString())) *
                                                      18);
                                                  tax = ((int.parse(discount
                                                          .toString())) /
                                                      100);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Extract(
                                                                vehicleImage:
                                                                    vehicleImage
                                                                        .toString(),
                                                                picDate: picDate
                                                                    .toString(),
                                                                picTime: picTime
                                                                    .toString(),
                                                                vehiclename:
                                                                    vehiclename
                                                                        .toString(),
                                                                totalAmount:
                                                                    totalAmount
                                                                        .toString(),
                                                                booking_id:
                                                                    booking_id
                                                                        .toString(),
                                                                slot_km: slot_km
                                                                    .toString(),
                                                                tax: tax
                                                                    .toString(),
                                                              )));
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>DuplicateHome()));
                                                },
                                                child: const Text(
                                                  "Select",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                        }),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
/*class Bike extends StatefulWidget {
  const Bike({Key? key}) : super(key: key);

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: 1,
    itemBuilder: (BuildContext, int index) {
      return BikeWidget();
    }
    );
  }

}
class Car extends StatefulWidget {
  const Car({Key? key}) : super(key: key);

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext, int index) {
          return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Text('My Booking',
                    //     style: TextStyle(
                    //       fontSize: 22,
                    //         color: Colors.green,
                    //         fontWeight: FontWeight.bold)),
                    // SizedBox(height: 20,),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          const Text('Booking Status',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){

                                },
                                child: Text(
                                  'Id:JPS62WIHW',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 15,),
                              InkWell(
                                  onTap: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>MyBookings()));
                                  },
                                  child: Icon(Icons.arrow_forward_ios,size: 20,)
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                height:80,
                                child: Image.asset(
                                  'assets/car.jpg',
                                  scale: 4,
                                ),
                              ),
                              const Text('Tata Tiago'),
                              const Text(
                                'UP 32 AA 1684',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              )
                            ],
                          ),
                          const VerticalDivider(
                            thickness: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children:const [
                                  Icon(
                                    CupertinoIcons.largecircle_fill_circle,
                                    color: Colors.red,
                                  ),
                                  Text('--------------------------------'),
                                  Icon(
                                    CupertinoIcons.largecircle_fill_circle,
                                    color: Colors.lightGreen,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:const [
                                  Text('Start',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      )),
                                  SizedBox(width: 120,),
                                  Text('End',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:const [
                                  Text(
                                    '9 Aug',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    '9 Aug',
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:const [
                                  Text(
                                    '7 AM',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    '11 AM',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 20,
                                    child: Text(
                                      'Sector-12,Gomti Nagar, Lucknow',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Text('Refund of 700 initiated',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}


Widget BikeWidget() {
  return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('My Booking',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20,),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text('Booking Status',
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){

                        },
                        child: Text(
                          'Id:JPS62WIHW',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Icon(Icons.arrow_forward_ios,size: 20,)
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height:80,
                        child: Image.asset(
                          'assets/scooti1.png',
                          scale: 4,
                        ),
                      ),
                      const Text('Tata Tiago'),
                      const Text(
                        'UP 32 AA 1684',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      )
                    ],
                  ),
                  const VerticalDivider(
                    thickness: 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children:const [
                          Icon(
                            CupertinoIcons.largecircle_fill_circle,
                            color: Colors.red,
                          ),
                          Text('--------------------------------'),
                          Icon(
                            CupertinoIcons.largecircle_fill_circle,
                            color: Colors.lightGreen,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:const [
                          Text('Start',
                              style: TextStyle(
                                color: Colors.black54,
                              )),
                          SizedBox(width: 120,),
                          Text('End',
                              style: TextStyle(
                                color: Colors.black54,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:const [
                          Text(
                            '9 Aug',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text(
                            '9 Aug',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:const [
                          Text(
                            '7 AM',
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text(
                            '11 AM',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            height: 20,
                            child: Text(
                              'Sector-12,Gomti Nagar, Lucknow',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  Text('Refund of 700 initiated',
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ));
}*/




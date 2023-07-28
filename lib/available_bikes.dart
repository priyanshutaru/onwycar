// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onwycar/choos_bike_info.dart';
import 'package:onwycar/constants/appConstants.dart';
import 'package:http/http.dart' as http;

class BikeDetails extends StatefulWidget {
  const BikeDetails(
      {Key? key,
      required this.StartDate,
      required this.EndDate,
      required this.CityId})
      : super(key: key);
  final String StartDate;
  final String EndDate;
  final String CityId;
  @override
  State<BikeDetails> createState() =>
      _CarDetailsState(this.StartDate, this.EndDate);
}

class _CarDetailsState extends State<BikeDetails> {
  bool onPress = false;
  String locality = '';

  String startDate1;
  String EndtDate1;
  String? StartDate2;
  String? EndDate2;
  TimeOfDay? _Starttime;
  TimeOfDay? _Endtime;
  TimeOfDay initialStartTime = TimeOfDay.now();
  TimeOfDay initialEndTime = TimeOfDay.now();
  List response_getvehicle = [];
  List response_bikeFuel = [];
  List response_withoutFuel = [];
  List WithoutfueListBike = [];
  DateTime currentStartDate = DateTime.now();
  DateTime currentEndDate = DateTime.now();

  _CarDetailsState(this.startDate1, this.EndtDate1);
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
        context: context,
        initialDate: currentStartDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2090));
    if (pickedStartDate != null && pickedStartDate != currentStartDate) {
      setState(() {
        currentStartDate = pickedStartDate;
        _pickStartDateTimer();
      });
    }
  }

  _pickStartDateTimer() async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: initialStartTime,
        builder: (BuildContext, Widget? child) {
          return Theme(data: ThemeData(), child: child!);
        });
    if (time != null) {
      setState(() {
        _Starttime = time.replacing(hour: time.hourOfPeriod);
        StartDate2 =
            '${currentStartDate.year}-${currentStartDate.month}-${currentStartDate.day}  ${_Starttime?.hour}:${_Starttime?.minute} ${_Starttime?.period.name.toUpperCase()}';
        EndDate2 =
            '${currentEndDate.year}-${currentEndDate.month}-${currentEndDate.day}  ${_Endtime?.hour}:${_Endtime?.minute} ${_Endtime?.period.name.toUpperCase()}';

        if (_Starttime != null) {
          startDate1 = StartDate2!;
          /* print(startDate1);*/
        } else {
          startDate1 = startDate1;
        }
        FuelCarList();
      });
    }
  }

  Future<void> _selectEndtDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: currentEndDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2090));
    if (pickedEndDate != null && pickedEndDate != currentEndDate)
      setState(() {
        currentEndDate = pickedEndDate;
        _pickEndtDateTimer();
      });
  }

  _pickEndtDateTimer() async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: initialEndTime,
        builder: (BuildContext, Widget? child) {
          return Theme(data: ThemeData(), child: child!);
        });
    if (time != null) {
      setState(() {
        _Endtime = time.replacing(hour: time.hourOfPeriod);
        StartDate2 =
            '${currentStartDate.year}-${currentStartDate.month}-${currentStartDate.day}  ${_Starttime?.hour}:${_Starttime?.minute} ${_Starttime?.period.name.toUpperCase()}';
        EndDate2 =
            '${currentEndDate.year}-${currentEndDate.month}-${currentEndDate.day}  ${_Endtime?.hour}:${_Endtime?.minute} ${_Endtime?.period.name.toUpperCase()}';

        if (_Endtime != null) {
          EndtDate1 = EndDate2!;
          /* print(startDate1);*/
        } else {
          EndtDate1 = EndtDate1;
        }
        FuelCarList();
      });
    }
  }

  Future<void> GetAddressFromLatLong() async {
    Position position = await _getGeoLocationPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];

    setState(() {
      locality =
          '${place.street}, ${place.subLocality},\n ${place.locality}, ${place.postalCode}';
      /* LoginActivity();*/
    });
    print(
        '${place.name} ${place.subAdministrativeArea} ${place.locality} ${place.subLocality}');
  }

  Future FuelCarList() async {
    var api = Uri.parse(appConstants.carfuelListTime);
    print(startDate1.toString());
    print(EndtDate1.toString());
    print(widget.CityId.toString());
    Map mapeddate = {
      "pickup_time": startDate1.toString(),
      "drop_time": EndtDate1.toString(),
      "city": widget.CityId.toString()
    };

    final response = await http.post(
      api,
      body: mapeddate,
    );

    var res = await json.decode(response.body);

    setState(() {
      response_getvehicle = res['response_getvehicle'];
      print(response_getvehicle);
    });

    try {
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future NonFuelCarList() async {
    var api = Uri.parse(appConstants.carWithoutfueList);
    print(widget.StartDate.toString());
    print(widget.EndDate.toString());
    print(widget.CityId.toString());
    Map mapeddate = {
      "pickup_time": widget.StartDate.toString(),
      "drop_time": widget.EndDate.toString(),
      "city": widget.CityId.toString()
    };

    final response = await http.post(
      api,
      body: mapeddate,
    );

    var res = await json.decode(response.body);

    setState(() {
      response_withoutFuel = res['response_withoutFuel'];
      print(response_withoutFuel);
    });

    try {
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future FuelBikeList() async {
    var api = Uri.parse(appConstants.bikefueList);
    print(widget.StartDate.toString());
    print(widget.EndDate.toString());
    print(widget.CityId.toString());
    Map mapeddate = {
      "pickup_time": widget.StartDate.toString(),
      "drop_time": widget.EndDate.toString(),
      "city": widget.CityId.toString()
    };

    final response = await http.post(
      api,
      body: mapeddate,
    );

    var res = await json.decode(response.body);

    setState(() {
      response_bikeFuel = res['response_bikeFuel'];
      print(response_bikeFuel);
    });

    try {
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future NonFuelBikeList() async {
    var api = Uri.parse('http://onway.ggggg.in.net/api/bikeWithoutfueList');
    print(widget.StartDate.toString());
    print(widget.EndDate.toString());
    print(widget.CityId.toString());
    Map mapeddate = {
      "pickup_time": widget.StartDate.toString(),
      "drop_time": widget.EndDate.toString(),
      "city": widget.CityId.toString()
    };

    final response = await http.post(
      api,
      body: mapeddate,
    );

    var res = await json.decode(response.body);
    print("hererere123" + response.body);
    setState(() {
      WithoutfueListBike = res['response_bikeWithout'];
    });

    try {
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    NonFuelBikeList();
    FuelCarList();
    NonFuelCarList();
    FuelBikeList();
    _getGeoLocationPosition();
    GetAddressFromLatLong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            foregroundColor: Colors.black,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(CupertinoIcons.location_solid),
                Text(
                  locality,
                  style: GoogleFonts.lobster(fontSize: 15),
                ),
              ],
            ),
            actions: [
              PopUpCartypes(),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _yourContainer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  gradient: LinearGradient(
                      colors: [Colors.green, Colors.lightGreenAccent.shade700],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(0.5, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: TabBar(
                  labelColor: Colors.black54,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                      insets: EdgeInsets.only(bottom: 4)),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: 'Fuel Cars',
                    ),
                    Tab(
                      text: 'Non Fuel Cars',
                    ),
                    // Tab(
                    //   text: 'Fuel Bikes',
                    // ),
                    // Tab(
                    //   text: 'Non Fuel Bikes',
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        width: 350,
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        "assets/bike.png",
                                        height: 100,
                                        width: 150,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, bottom: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Avenger bike",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Cars,2002 model",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: 3,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Icon(
                                                        Icons.currency_rupee,
                                                        size: 20,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      "100",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "1000 KM",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black54),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                    height: 25,
                                                    width: 90,
                                                    child: MaterialButton(
                                                      color: Colors.lightGreen,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      onPressed: () {
                                                        // setState(() {
                                                        //   onPress = !onPress;
                                                        //
                                                        // });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ChoosedBikeInfo()));
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                        "BOOKED",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ));
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SingleChildScrollView(
                      child: Container(
                        width: 350,
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        "assets/scooti1.png",
                                        height: 100,
                                        width: 150,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Honda Scooty",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(Icons.model_training),
                                                Text(
                                                  "2022",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.chair_alt_outlined),
                                                Text("2",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.car_repair),
                                                Text("Sedon",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: 3,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Icon(
                                                        Icons.currency_rupee,
                                                        size: 20,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Text(
                                                      "100",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "1000 KM",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black54),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                    height: 25,
                                                    width: 90,
                                                    child: MaterialButton(
                                                      color: Colors.lightGreen,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      onPressed: () {
                                                        // setState(() {
                                                        //   onPress = !onPress;
                                                        //
                                                        // });
                                                        // Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedBikeInfo()));
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                        "BOOKED",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ));
                                  }),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // _PetrolBike(),
                    // _ElectricBike()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PopUpCartypes() {
    return PopupMenuButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Text(
                'Filters',
                style: TextStyle(color: Colors.black),
              ),
              Icon(
                FontAwesomeIcons.filter,
                color: Colors.green,
              )
            ],
          ),
        ),
        itemBuilder: (content) => [
              PopupMenuItem(
                child: Text('Car1'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Car2'),
                value: 2,
              ),
              PopupMenuItem(
                child: Text('Car3'),
                value: 3,
              ),
              PopupMenuItem(
                child: Text('Car4'),
                value: 4,
              ),
              PopupMenuItem(
                child: Text('Car5'),
                value: 5,
              ),
              PopupMenuItem(
                child: Text('Car6'),
                value: 6,
              ),
            ]);
  }

  Widget _ElectricCars() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount:
            response_withoutFuel == null ? 0 : response_withoutFuel.length,
        itemBuilder: (BuildContext, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChoosedCarInfo()));
                    },
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.network(
                            '${appConstants.ImageBaseUrl}${response_withoutFuel[index]['vehicle_image']}',
                            height: 80,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                          VerticalDivider(
                            thickness: 1,
                          ),
                          Column(
                            children: [
                              Text(
                                response_withoutFuel[index]['vehicle_name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons
                                        .square_stack_3d_down_right_fill,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(response_withoutFuel[index]['category'])
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.location_solid,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(response_withoutFuel[index]
                                          ['city_name'])
                                    ],
                                  ),
                                ],
                              ),
                              response_withoutFuel[index]['category'] == 0
                                  ? Text(
                                      'Available',
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : Text("Not Available",
                                      style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 118,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext, int index) {
                          return Card(
                            shadowColor: Color(0xff10d5d5),
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '₹ 2645',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: 18),
                                  ),
                                  Text('145 KMS FREE',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.deepOrange.shade300),
                                      onPressed: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => ChoosedCarInfo()));
                                      },
                                      child: Text('Book Now')),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _yourContainer() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreenAccent.shade700],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      alignment: Alignment.center,
      child: Column(children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _selectStartDate(context);
                },
                child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          _Starttime == null
                              ? startDate1
                              : StartDate2.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    )),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'to',
                    style: TextStyle(color: Colors.white),
                  )),
              InkWell(
                onTap: () {
                  _selectEndtDate(context);
                },
                child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            _Endtime == null ? EndtDate1 : EndDate2.toString(),
                            style: TextStyle(fontSize: 12)),
                      ),
                    )),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2),
                    child: Text('Fare: High to Low',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )),
              Container(
                  width: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2),
                    child: Text('Fare: Low to High',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}

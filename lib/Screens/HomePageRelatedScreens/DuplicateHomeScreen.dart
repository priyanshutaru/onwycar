import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onwycar/Screens/HomePageRelatedScreens/AvailableCars.dart';
import '../ContactRelatedScreen/contact.dart';
import '../ProfileRelatedScreens/profile.dart';
import '../TrackRelatedScreens/track.dart';

class DuplicateHome extends StatefulWidget {
  const DuplicateHome({Key? key}) : super(key: key);

  @override
  State<DuplicateHome> createState() => _DuplicateHomeState();
}

class _DuplicateHomeState extends State<DuplicateHome> {
  String Car = "Cars";
  int _currentIndex = 0;
  String locality = '';

  static DateTime date = DateTime.now();
  static var StartingDate = "Starting Date";
  static var StartingTime = "Time";
  //static var StartingTime1="Time";
  static var ReturningDate = "Returning Date";
  static var ReturningTime = "Time";
  // static var ReturningTime2="Time";

  var value = 0;
  // String dropdownvalue = 'Location';
  //  String car = 'car';
  List imageList = [];
  List imagelist1 = [];
  bool isloading = true;
  bool bannerloading = true;
  String? vehicle_name,
      model_no,
      vehicle_no,
      vehicle_image,
      vehicle_type,
      vehicle_status,
      msg;

  Future bannerTop() async {
    var api = Uri.parse("https://bitacars.com/api/banner_top");
    final response = await http.get(
      api,
    );
    var res = await json.decode(response.body);
    var msg = res['status_message'].toString();
    if (msg == "Success") {
      setState(() {
        bannerloading = true;
        imageList = res['response_userRegister'];
        isloading = true;
      });
    }
  }

  Future bannerBottom() async {
    var api = Uri.parse("https://gwalamilk.com/api/getbanner");
    final response = await http.get(
      api,
    );
    var res = await json.decode(response.body);
    var msg = res['message'].toString();
    if (msg == "Record found") {
      setState(() {
        bannerloading = true;
        imagelist1 = res['data'];
        isloading = true;
      });
    }
  }

  List cityItemlist = [];
  Future getAllCity() async {
    var baseUrl = "https://bitacars.com/api/city";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)["response_userRegister"];
      setState(() {
        cityItemlist = jsonData;
        print("@@@@@@@@@@@@@@@@===>>>>>>" + cityItemlist.toString());
      });
    }
  }

  var dropdownvalue;

  Future search_vehicle() async {
    Map data = {
      'city': dropdownvalue.toString(),
      'pickup_date': StartingDate.toString(),
      'pickup_time': StartingTime.toString(),
      'drop_date': ReturningDate.toString(),
      'drop_time': ReturningTime.toString(),
      'vehicle_type': Car.toString(),
    };
    Uri url = Uri.parse("https://bitacars.com/api/search_vehicle");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    if (response.statusCode == 200) {
      var res = await json.decode(response.body);
      String msg = res['status_message'];
      if (msg == 'Success') {
        Fluttertoast.showToast(
            msg: 'Successfully', backgroundColor: Colors.green);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarDetails(
                      city: dropdownvalue.toString(),
                      pickup_date: StartingDate.toString(),
                      pickup_time: StartingTime.toString(),
                      drop_date: ReturningDate.toString(),
                      drop_time: ReturningTime.toString(),
                      vehicle_type: Car.toString(),
                      StartDate: '',
                      EndDate: '',
                      CityId: '',
                    )));
      } else {
        Fluttertoast.showToast(
            msg: 'Server Error...', backgroundColor: Colors.red);
      }
    }
  }

  @override
  void initState() {
    bannerTop();
    bannerBottom();
    GetAddressFromLatLong();
    getAllCity();
    // CitiesList();
    super.initState();
    setState(() {
      search_vehicle();
      print("999999999999999999999" + vehicle_name.toString());
    });
  }

  // entire logic is inside this listener for ListView
  Future<void> GetAddressFromLatLong() async {
    Position position = await _getGeoLocationPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];

    setState(() {
      locality = ' ${place.locality}, ${place.postalCode}';
      /* LoginActivity();*/
    });
    print(
        '${place.name} ${place.subAdministrativeArea} ${place.locality} ${place.subLocality}');
  }

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

  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.green, // body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        StartingTime = ' ${_time.format(context)}';
      });
    }
  }

  void _selectTime2() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.green, // body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        ReturningTime = ' ${_time.format(context)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            foregroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 50,
                  width: 100,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            actions: [
              const Icon(CupertinoIcons.location_solid),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  locality,
                  // style: GoogleFonts.lobster(fontSize: 15),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Center(
                    child: CarouselSlider(
                        options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                            viewportFraction: 1),
                        items: [
                          for (var i = 0; i < imageList.length; i++)
                            bannerloading
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.network(
                                          imageList[i]['banner_img'].toString(),
                                          fit: BoxFit.fitWidth),
                                    ),
                                  )
                                : Container(
                                    child: const Center(
                                      child: CupertinoActivityIndicator(
                                          color: Colors.green, radius: 30),
                                    ),
                                  )
                        ]),
                  ),
                ),
                //SizedBox(height: 10,),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, bottom: 0),
                            child: Row(
                              children: const [
                                Text(
                                  "Search for a cars",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 320,
                                  child: const Text(
                                    "We search over 400 cars and bikes at\nlowest price.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //DropDown List
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width * 95,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.green),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    'Select Location..',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  items: cityItemlist.map((item) {
                                    return DropdownMenuItem(
                                      value: item['id'].toString(),
                                      child: Text(item['city_name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      dropdownvalue = newVal;
                                      print("Value=======>>>>>" +
                                          dropdownvalue.toString());
                                    });
                                  },
                                  value: dropdownvalue,
                                ),
                              ),
                            ),
                          ),
                          //Starting Date Time Code
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.date_range),
                                      MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        height: 40,
                                        child: Text(StartingDate),
                                        onPressed: () async {
                                          await showDatePicker(
                                            context: context,
                                            initialDate: date,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary: Colors
                                                        .green, // header background color
                                                    onPrimary: Colors
                                                        .black, // header text color
                                                    onSurface: Colors
                                                        .green, // body text color
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          ).then((selectedDate) {
                                            if (selectedDate != null) {
                                              setState(() {
                                                date = selectedDate;
                                                StartingDate =
                                                    DateFormat('d-MM-yyyy')
                                                        .format(selectedDate);
                                                print(
                                                    "Starting Date========>>>>" +
                                                        StartingDate);
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time_outlined),
                                      /*MaterialButton(
                                      minWidth: MediaQuery.of(context).size.width/3.7,
                                      height: 40,
                                      child: Text(StartingTime1),
                                      onPressed: () async {
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                            builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.green, // header background color
                                                onPrimary: Colors.black, // header text color
                                                onSurface: Colors.green, // body text color
                                              ),

                                            ),
                                            child: child!,
                                          );
                                        },
                                        ).then((pickedTime) {
                                          if (pickedTime != null) {
                                            setState(() {
                                              // date = pickedTime;
                                              DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                                              // ReturningTime = DateFormat('h : m a').format(date);
                                              StartingTime1 = DateFormat('HH:mm a').format(parsedTime);
                                              StartingTime = DateFormat('HH:mm').format(parsedTime);
                                              print("StartingTime+++>>>>"+StartingTime);
                                            });
                                          }
                                        }
                                        );

                                      },
                                    ),*/
                                      MaterialButton(
                                        onPressed: _selectTime,
                                        child: Text(StartingTime),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Returning Date Time Code
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.date_range),
                                      MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        height: 40,
                                        child: Text(ReturningDate),
                                        onPressed: () async {
                                          await showDatePicker(
                                            context: context,
                                            initialDate: date,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary: Colors
                                                        .green, // header background color
                                                    onPrimary: Colors
                                                        .black, // header text color
                                                    onSurface: Colors
                                                        .green, // body text color
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          ).then((selectedDate) {
                                            if (selectedDate != null) {
                                              setState(() {
                                                date = selectedDate;
                                                ReturningDate =
                                                    DateFormat('d-MM-yyyy')
                                                        .format(selectedDate);
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time_outlined),
                                      /* MaterialButton(
                                      minWidth: MediaQuery.of(context).size.width/3.7,
                                      height: 40,
                                      child: Text(ReturningTime2),
                                      onPressed: () async {
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: Colors.green, // header background color
                                                  onPrimary: Colors.black, // header text color
                                                  onSurface: Colors.green, // body text color
                                                ),
                                                dialogBackgroundColor:Colors.blue[900],
                                              ),
                                              child: child!,
                                            );
                                          },
                                        ).then((pickedTime) {
                                          if (pickedTime != null) {
                                            setState(() {
                                             // date = pickedTime;
                                              DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                                             // ReturningTime = DateFormat('h : m a').format(date);
                                              ReturningTime2 = DateFormat('HH:mm a').format(parsedTime);
                                              ReturningTime = DateFormat('HH:mm').format(parsedTime);
                                             });
                                            }
                                          }
                                        );
                                      },
                                    ),*/
                                      MaterialButton(
                                        onPressed: _selectTime2,
                                        child: Text(ReturningTime),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Radio Button code
                          Column(
                            children: [
                              RadioListTile(
                                title: const Text("Cars"),
                                value: "car",
                                activeColor: Colors.green,
                                groupValue: Car,
                                onChanged: (value) {
                                  setState(() {
                                    Car = value.toString();
                                    print("Cars@@@@@########+++++>>>>>>>>" +
                                        Car.toString());
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Bikes"),
                                value: "bike",
                                activeColor: Colors.green,
                                groupValue: Car,
                                onChanged: (value) {
                                  setState(() {
                                    Car = value.toString();
                                    print("Cars@@@@@########+++++>>>>>>>>" +
                                        Car.toString());
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: ButtonTheme(
                              minWidth: 350.0,
                              height: 45,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: Colors.green, width: 0.5)),
                              child: MaterialButton(
                                elevation: 5.0,
                                hoverColor: Colors.green,
                                highlightColor: Colors.grey,
                                color: Colors.green,
                                child: const Text(
                                  "Search Cars",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (dropdownvalue != null) {
                                      if (StartingTime != ReturningTime) {
                                        search_vehicle();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Not Select Same Time..',
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.red);
                                      }
                                      /*if(Car!=null){
                                      search_vehicle();
                                    }else{
                                      Fluttertoast.showToast(msg: 'Please Select Cars && Bikes..',gravity: ToastGravity.CENTER,backgroundColor: Colors.red);
                                    }*/
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please Select Location',
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red);
                                    }
                                  });
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>CarDetails(StartDate:'', EndDate:'', CityId:'')));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Container(
                        child: const Text(
                          "Our Cars & Bikes",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 25.0),
                  height: 150.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {},
                                child:
                                    _listviewcard("assets/alto.png", "Alto")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child:
                                    _listviewcard("assets/maruti.png", "Kwid")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child: _listviewcard(
                                    "assets/safari.png", "Safari")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child:
                                    _listviewcard("assets/thar.png", "Thar")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child: _listviewcard(
                                    "assets/maruti.png", "Brezza")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child: _listviewcard(
                                    "assets/bolero.png", "Bollero")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child: _listviewcard(
                                    "assets/maruti.png", "Swift")),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () {},
                                child:
                                    _listviewcard("assets/thar.png", "Thar")),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Center(
                    child: CarouselSlider(
                        options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                            viewportFraction: 1),
                        items: [
                          for (var i = 0; i < imageList.length; i++)
                            bannerloading
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.network(
                                          imageList[i]['banner_img'].toString(),
                                          fit: BoxFit.fitWidth),
                                    ),
                                  )
                                : Container(
                                    child: const Center(
                                      child: CupertinoActivityIndicator(
                                          color: Colors.green, radius: 30),
                                    ),
                                  )
                        ]),
                  ),
                ),
                /*CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  viewportFraction: 1),
              items: [
                for (var i = 0; i < imagelist1.length; i++)
                  bannerloading
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                          imagelist1[i]['img'].toString(),
                          fit: BoxFit.fitWidth),
                    ),
                  )
                      : Container(
                    child: Center(
                      child: CupertinoActivityIndicator(
                          color: Colors.green, radius: 30),
                    ),
                  )
              ]
          ),*/
                // SizedBox(
                //   height: 60,
                // )
              ],
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
}

Widget _listviewcard(Images, String text) {
  return Container(
      width: 120,
      child: Card(
        // color: Color.fromARGB(255, 247, 243, 243),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            // CircleAvatar(
            //   radius: 40,
            //   backgroundImage: AssetImage(Images),
            // ),
            Container(
              height: 90,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(Images), fit: BoxFit.fill)),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(text,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff3E3E3E))),
          ],
        ),
      ));
}

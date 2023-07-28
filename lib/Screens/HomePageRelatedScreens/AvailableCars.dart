// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Filters_model/brand_model.dart';
import '../../model/Filters_model/fuelType_model.dart';
import '../../model/Filters_model/segment.dart';
import '../../model/FuelCar.dart';
import '../../model/NonFuelCar.dart';
import '../../model/filters1_model.dart';
import '../ContactRelatedScreen/contact.dart';
import '../ProfileRelatedScreens/profile.dart';
import '../TrackRelatedScreens/track.dart';
import 'ChoosedCarInfo.dart';
import 'DuplicateHomeScreen.dart';

class CarDetails extends StatefulWidget {
  CarDetails({
    required this.StartDate,
    required this.EndDate,
    required this.CityId,
    required this.city,
    required this.pickup_date,
    required this.pickup_time,
    required this.drop_date,
    required this.drop_time,
    required this.vehicle_type,
  });
  String StartDate,
      EndDate,
      CityId,
      city,
      pickup_date,
      pickup_time,
      drop_date,
      drop_time,
      vehicle_type;
  @override
  State<CarDetails> createState() =>
      _CarDetailsState(this.StartDate, this.EndDate);
}

class _CarDetailsState extends State<CarDetails> {
  int _currentIndex = 0;
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
      locality = ' ${place.locality}, ${place.postalCode}';
      /* ${place.street}, ${place.subLocality},\n*/
      /* LoginActivity();*/
    });
    print(
        '${place.name} ${place.subAdministrativeArea} ${place.locality} ${place.subLocality}');
  }

  Future<List<Response1>> getNonFuelCar() async {
    Map data = {
      'city': widget.city.toString(),
      'pickup_date': widget.pickup_date.toString(),
      'pickup_time': widget.pickup_time.toString(),
      'drop_date': widget.drop_date.toString(),
      'drop_time': widget.drop_time.toString(),
      'vehicle_type': widget.vehicle_type.toString(),
    };
    Uri url = Uri.parse("https://bitacars.com/api/search_vehicle");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body1);
    print("Response===>>>>>>>>>>" + response.toString());
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data = json.decode(response.body)["response"];
      return data.map((data) => Response1.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  /* Future nonFuelFilter() async{
    Map data={
      'city':  widget.city.toString(),
      'pickup_date':widget.pickup_date.toString(),
      'pickup_time':widget.pickup_time.toString() ,
      'drop_date':widget.drop_date.toString() ,
      'drop_time': widget.drop_time.toString(),
      'vehicle_type':widget.vehicle_type.toString(),
      'segment[]':Segmentlist,
      'brand[]':Brandlist,
      'fueltype[]':FuelTypelist,
      'transmission[]':Transmissionlist
    };
    setState((){
      print(data.toString()+"gjhjhgkhmhjmhjhjghklhgkghkhgklhj");
    });
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/serach_filter_without_fuel");
    var body1= jsonEncode(data);
    var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: body1);
    if(response.statusCode==200) {
      var res = await json.decode(response.body)['response'];
      print("all data in filter==>>>>>>>>>"+res.toString());
      String msg = res['status_message'].toString();
      print("status_message******************>>"+msg.toString());
      if(msg=='Success'){
        Fluttertoast.showToast(msg: 'Successfully',backgroundColor: Colors.green);
      }
    }
  }*/
  bool fil1 = false;
  var carbikeType;
  List Brandlist = [];
  List Segmentlist = [];
  List FuelTypelist = [];
  List Transmissionlist = [];

  Future<List<ResponseF1>> filterlist1() async {
    Map data1 = {
      'city': widget.city.toString(),
      'pickup_date': widget.pickup_date.toString(),
      'pickup_time': widget.pickup_time.toString(),
      'drop_date': widget.drop_date.toString(),
      'drop_time': widget.drop_time.toString(),
      'vehicle_type': widget.vehicle_type.toString(),
      // 'segment[]':'PREMIUM HATCHBACK',
      // 'brand[]':'Maruti',
      // 'fueltype[]':'',
      // 'transmission[]':'',
      // 'segment[1]':"CUV",
      // 'brand[1]':"Mahindra",
      // 'fueltype[]':"",
      // 'transmission[]':"",
      'segment[]': Segmentlist.toString(),
      'brand[]': Brandlist.toString(),
      'fueltype[]': FuelTypelist.toString(),
      'transmission[]': Transmissionlist.toString(),
    };
    setState(() {
      print(data1.toString() + "gjhjhgkhmhjmhjhjghklhgkghkhgklhj");
    });
    var url = Uri.parse(
        "https://bitacars.com/api/serach_filter_without_fuel");
    //var body1= jsonEncode(data1);
    var response = await http.post(url,
        headers: {"Accept": "application/json"}, body: data1);
    // List data=json.decode(response.body)["response"];
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        print("response****333##*>>>" + map.toString());
        List<dynamic> data = map["response"];
        print("all adata kmlkfhjhedg===*/**?>>" + data.toString());
        return data.map((data) => ResponseF1.fromJson(data)).toList();
      }
    } catch (e) {
      print(e);
    }
    throw Exception('unexpected error occurred');
  }

  // List commentList = ['PREMIUM HATCHBACK'];
  // List commentList1 = ['Maruti'];
  Future FuelFilter() async {
    Map data = {
      'city': widget.city.toString(),
      'pickup_date': widget.pickup_date.toString(),
      'pickup_time': widget.pickup_time.toString(),
      'drop_date': widget.drop_date.toString(),
      'drop_time': widget.drop_time.toString(),
      'vehicle_type': widget.vehicle_type.toString(),
      'segment[]': Segmentlist,
      'brand[]': Brandlist,
      'fueltype[]': FuelTypelist,
      'transmission[]': Transmissionlist
    };
    Uri url = Uri.parse(
        "https://bitacars.com/api/serach_filter_with_fuel");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    if (response.statusCode == 200) {
      var res = await json.decode(response.body);
      String msg = res['status_message'].toString();
      if (msg == 'Success') {
        Fluttertoast.showToast(
            msg: 'Successfully', backgroundColor: Colors.green);
      }
    }
  }

  var vehicle_id,
      fueltotalrent,
      vehicle_id2,
      fueltotalrent2,
      fix_km1,
      fix_km2,
      fuel_type1,
      fuel_type2;
  var slotdata;
  var fixret = "00";
  String? msg;
  Future<List<Response2>> getFuelCar() async {
    Map data1 = {
      'city': widget.city.toString(),
      'pickup_date': widget.pickup_date.toString(),
      'pickup_time': widget.pickup_time.toString(),
      'drop_date': widget.drop_date.toString(),
      'drop_time': widget.drop_time.toString(),
      'vehicle_type': widget.vehicle_type.toString(),
    };
    Uri url = Uri.parse("https://bitacars.com/api/search_vehicle_with_fuel");
    var body1 = jsonEncode(data1);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body1);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      // List data=json.decode(response.body)["response2"];
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response2"];

      return data.map((data) => Response2.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<Slot1>> getSlotCar() async {
    Map data1 = {
      'city': widget.city.toString(),
      'pickup_date': widget.pickup_date.toString(),
      'pickup_time': widget.pickup_time.toString(),
      'drop_date': widget.drop_date.toString(),
      'drop_time': widget.drop_time.toString(),
      'vehicle_type': widget.vehicle_type.toString(),
    };
    Uri url = Uri.parse(
        "https://bitacars.com/api/search_vehicle_with_fuel");
    var body1 = jsonEncode(data1);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body1);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["response2"][0]["slot"];
      return data.map((data) => Slot1.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  var Mobile,
      vehcile_img,
      vehicle_name,
      security_money,
      tax,
      delivery_charge,
      latittude,
      longitude,
      self_location;
  Future getCheckout(Mobile) async {
    Map data = {
      'mobile': Mobile.toString(),
      'vehicle_id': vehicle_id.toString(),
      'total_rent': fueltotalrent.toString(),
    };
    Uri url =
        Uri.parse("https://bitacars.com/api/checkout_summary");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    var res = await json.decode(response.body);
    print("ghujdsgfyugfu====>>>>>" + data.toString());
    // var res1=res['response_userRegister'];
    setState(() {
      msg = res['status_message'];
      //vehcile_img=res['vehcile_img'];
      vehicle_name = res['vehicle_name'];
      security_money = res['security_money'];
      tax = res['tax'];
      delivery_charge = res['delivery_charge_pr_km'];
      latittude = res['latittude'];
      longitude = res['longitude'];
      self_location = res['self_location'];
    });
    print('data=========>>>>>>>>' + vehcile_img.toString());
    print('data=========>>>>>>>>' + vehicle_name.toString());
    print('data=========>>>>>>>>' + security_money.toString());
    print("hgvuhuygfu==--->>" + tax.toString());
    print("message ==--->>" + msg.toString());
    try {
      if (msg == "Success") {
        // await HelperFunctions.saveUserLoggedInSharedPreference(true);
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChoosedCarInfo(
                        vehcile_img: vehcile_img.toString(),
                        vehicle_name: vehicle_name.toString(),
                        security_money: security_money.toString(),
                        tax: tax.toString(),
                        totalRent: fueltotalrent,
                        delivery_charge: delivery_charge.toString(),
                        C_latittude: latittude.toString(),
                        C_longitude: longitude.toString(),
                        self_location: self_location.toString(),
                        pickup_date: widget.pickup_date.toString(),
                        pickup_time: widget.pickup_time.toString(),
                        drop_date: widget.drop_date.toString(),
                        drop_time: widget.drop_time.toString(),
                        vehicle_id: vehicle_id.toString(),
                        fix_km: fix_km1.toString(),
                        fuel_type: fuel_type1.toString(),
                        CityId: widget.city.toString(),
                      )));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCheckout2(Mobile) async {
    Map data = {
      'mobile': Mobile.toString(),
      'vehicle_id': vehicle_id2.toString(),
      'total_rent': fueltotalrent2.toString(),
    };
    Uri url =
        Uri.parse("https://bitacars.com/api/checkout_summary");
    var body1 = jsonEncode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "Application/json"}, body: body1);
    var res = await json.decode(response.body);
    print("ghujdsgfyugfu====>>>>>" + data.toString());
    // var res1=res['response_userRegister'];
    setState(() {
      msg = res['status_message'];
      // vehcile_img=res['vehcile_img'];
      vehicle_name = res['vehicle_name'];
      security_money = res['security_money'];
      tax = res['tax'];
      delivery_charge = res['delivery_charge_pr_km'];
      latittude = res['latittude'];
      longitude = res['longitude'];
      self_location = res['self_location'];
    });
    print('data=========>>>>>>>>' + vehcile_img.toString());
    print('data=========>>>>>>>>' + vehicle_name.toString());
    print('data=========>>>>>>>>' + security_money.toString());
    print("hgvuhuygfu==--->>" + tax.toString());
    try {
      if (msg == "Success") {
        // await HelperFunctions.saveUserLoggedInSharedPreference(true);
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChoosedCarInfo(
                        vehcile_img: vehcile_img.toString(),
                        vehicle_name: vehicle_name.toString(),
                        security_money: security_money.toString(),
                        tax: tax.toString(),
                        totalRent: fueltotalrent2,
                        delivery_charge: delivery_charge.toString(),
                        C_latittude: latittude.toString(),
                        C_longitude: longitude.toString(),
                        self_location: self_location.toString(),
                        pickup_date: widget.pickup_date.toString(),
                        pickup_time: widget.pickup_time.toString(),
                        drop_date: widget.drop_date.toString(),
                        drop_time: widget.drop_time.toString(),
                        vehicle_id: vehicle_id2.toString(),
                        fix_km: fix_km2.toString(),
                        fuel_type: fuel_type2.toString(),
                        CityId: widget.city.toString(),
                      )));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<ResponseUserRegister>> getSegment() async {
    var baseUrl = "https://bitacars.com/api/get_segment/$carbikeType";
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data = json.decode(response.body)["response_userRegister"];
      // print("bgfdhghfvgu==========>>>>>>"+data.toString());
      return data.map((data) => ResponseUserRegister.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<ResponseUserRegister1>> getBrand() async {
    var baseUrl = "https://bitacars.com/api/get_brand/$carbikeType";
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data = json.decode(response.body)["response_userRegister"];
      // print("bgfdhghfvgu==========>>>>>>"+data.toString());
      return data.map((data) => ResponseUserRegister1.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  Future<List<ResponseUserRegister2>> getFuelType() async {
    var baseUrl = "https://bitacars.com/api/get_fuel_type";
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data = json.decode(response.body)["response_userRegister"];
      // print("bgfdhghfvgu==========>>>>>>"+data.toString());
      return data.map((data) => ResponseUserRegister2.fromJson(data)).toList();
    } else {
      throw Exception('unexpected error occurred');
    }
  }

  List name = ["Automatic", "Manual"];
  @override
  void initState() {
    _getGeoLocationPosition();
    GetAddressFromLatLong();
    _getValue();
    super.initState();
    setState(() {
      getSegment();
      getBrand();
      getFuelType();
      getCheckout(Mobile);
      getCheckout2(Mobile);
      carbikeType = '${widget.vehicle_type.toString()}';
    });
  }

  var bookingSt, bookingSt2;
  String? search;
  TextEditingController carsearch = TextEditingController();

  bool checkedValue = false;
  bool checkedValue1 = false;
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              /* title: Row(
              children: [
                Icon(CupertinoIcons.location_solid),
                Text(
                  locality,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),*/
              actions: [
                /* PopUpCartypes(),*/
                InkWell(
                  onTap: () {
                    setState(() {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        context: context,
                        builder: (context) {
                          return buildsheet();
                        },
                        isScrollControlled: true,
                      );
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Filters',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        context: context,
                        builder: (context) {
                          return buildsheet();
                        },
                        isScrollControlled: true,
                      );
                    });
                  },
                  icon: Icon(
                    FontAwesomeIcons.filter,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _yourContainer(),
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  //color: Colors.green,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.lightGreenAccent.shade700
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: TextField(
                    cursorHeight: 25,
                    textInputAction: TextInputAction.search,
                    controller: carsearch,
                    onChanged: (String? value) {
                      setState(() {
                        search = value.toString();
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.green,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(width: 2, color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(width: 2, color: Colors.green),
                        ),
                        hintText: 'Search Here...'),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    gradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.lightGreenAccent.shade700
                        ],
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
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      fil1 == false
                          ? FutureBuilder<List<Response2>>(
                              future: getFuelCar(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  List<Response2>? data = snapshot.data;
                                  return Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(8),
                                        itemCount: data!.length,
                                        itemBuilder: (context, index) {
                                          bookingSt = data[index]
                                              .bookingStatus
                                              .toString();
                                          String? postion = data[index]
                                              .vehicleName
                                              .toString();
                                          if (carsearch.text.isEmpty) {
                                            return Container(
                                              width: 350,
                                              child: Card(
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            //"assets/tesla.png"
                                                            child:
                                                                Image.network(
                                                              data[index]
                                                                  .vehicleImage
                                                                  .toString(),
                                                              height: 100,
                                                              width: 140,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index]
                                                                          .vehicleName
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .model_training,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          data[index]
                                                                              .modelNo
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .chair_alt_outlined,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            data[index]
                                                                                .vehicleSeat
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 9,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54)),
                                                                        SizedBox(
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        Container(
                                                                          // width: MediaQuery.of(context).size.width/5.7,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.car_repair,
                                                                                color: Colors.black54,
                                                                                size: 15,
                                                                              ),
                                                                              Text(data[index].vehicleCategory.toString(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 125,
                                                    //   child: ListView.builder(
                                                    //       itemCount:data[index].slot1!.length,
                                                    //       itemExtent: 125,
                                                    //       scrollDirection: Axis.horizontal,
                                                    //       itemBuilder: (context, index) {
                                                    //         return Container(
                                                    //             alignment: Alignment.center,
                                                    //             decoration: BoxDecoration(
                                                    //                 color: Colors.white,
                                                    //                 borderRadius: BorderRadius.circular(8)),
                                                    //             child: Card(
                                                    //               elevation: 5,
                                                    //               shape: RoundedRectangleBorder(
                                                    //                   borderRadius: BorderRadius.circular(15)),
                                                    //               child: Padding(
                                                    //                 padding: EdgeInsets.all(8.0),
                                                    //                 child: Column(
                                                    //                   children: [
                                                    //                     SizedBox(
                                                    //                       height: 2,),
                                                    //                     Row(
                                                    //                       children: [
                                                    //                         Padding(
                                                    //                           padding: const EdgeInsets.only(left: 10),
                                                    //                           child: Icon( Icons .currency_rupee,
                                                    //                             size: 20,color: Colors.green,),
                                                    //                         ),
                                                    //                         Text(data[index].slot1![0].fixRate.toString(),
                                                    //                           style: TextStyle(
                                                    //                               fontSize: 18,
                                                    //                               fontWeight: FontWeight
                                                    //                                   .w700,
                                                    //                               color: Colors
                                                    //                                   .green),)
                                                    //                       ],
                                                    //                     ),
                                                    //                     SizedBox(
                                                    //                       height: 8,),
                                                    //                     Text(data[index].slot1![0].fixKm.toString()+" KM",
                                                    //                       style: TextStyle(
                                                    //                           fontSize: 13,
                                                    //                           fontWeight: FontWeight.w700,
                                                    //                           color: Colors.black54),),
                                                    //                     SizedBox(
                                                    //                       height: 15,),
                                                    //                     bookingSt=="0"? Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors
                                                    //                               .lightGreen,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             getCheckout2(Mobile);
                                                    //                             setState(() {
                                                    //                               vehicle_id=data[index].vehicleId.toString();
                                                    //                               fuel_type1=data[index].fuelType.toString();
                                                    //                               fueltotalrent=data[index].slot1![index].fixRate.toString();
                                                    //                               fix_km1=data[index].slot1![index].fixKm.toString();
                                                    //                             });
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOK NOW",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 11,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     bookingSt=="1"?Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors.grey.shade300,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             /* getCheckout2(Mobile);
                                                    //                    setState(() {
                                                    //                      vehicle_id2=data[index].vehicleId.toString();
                                                    //                      fuel_type2=data[index].fuelType.toString();
                                                    //                      fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                    //                      fix_km2=data[index].slot![0].fixKm.toString();
                                                    //                    });*/
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOKED",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 12,
                                                    //                                     color: Colors.grey,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     Container(),
                                                    //
                                                    //                   ],
                                                    //                 ),
                                                    //               ),
                                                    //             )
                                                    //         );
                                                    //       }
                                                    //   ),
                                                    // ),
                                                    widget.vehicle_type !=
                                                            "bike"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              data[index]
                                                                          .slot1!
                                                                          .length !=
                                                                      0
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![0].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot1![0].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot1![0].fixRate.toString();
                                                                                            fix_km1 = data[index].slot1![0].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot1!
                                                                          .length !=
                                                                      1
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![1].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot1![1].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot1![1].fixRate.toString();
                                                                                            fix_km1 = data[index].slot1![1].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot1![2].fixRate.toString();
                                                                                                fix_km1 = data[index].slot1![2].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot1!
                                                                          .length !=
                                                                      2
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![2].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot1![2].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot1![2].fixRate.toString();
                                                                                            fix_km1 = data[index].slot1![2].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                // vehicle_id=data[index].vehicleId.toString();
                                                                                                // fuel_type1=data[index].fuelType.toString();
                                                                                                // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : widget.vehicle_type !=
                                                                "car"
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  data[index]
                                                                              .slot1!
                                                                              .length !=
                                                                          0
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot1![0].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![0].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot1![0].fixRate.toString();
                                                                                                fix_km1 = data[index].slot1![0].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                  data[index]
                                                                              .slot1!
                                                                              .length !=
                                                                          1
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot1![1].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![1].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot1![1].fixRate.toString();
                                                                                                fix_km1 = data[index].slot1![1].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  // getCheckout(Mobile);
                                                                                                  setState(() {
                                                                                                    // vehicle_id=data[index].vehicleId.toString();
                                                                                                    // fuel_type1=data[index].fuelType.toString();
                                                                                                    // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                    // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                    // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                    // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                                  });
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                ],
                                                              )
                                                            : Container(),
                                                    /* FutureBuilder<List<Slot1>>(
                                                future: getSlotCar(),
                                                builder:(context, AsyncSnapshot snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else {
                                                    List<Slot1>? data=snapshot.data;
                                                    return  Container(
                                                      height: 125,
                                                      child: ListView.builder(
                                                          itemCount:data!.length,
                                                          itemExtent: 125,
                                                          scrollDirection: Axis.horizontal,
                                                          itemBuilder: (context, index) {
                                                            return Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8)),
                                                                child: Card(
                                                                  elevation: 5,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(15)),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 2,),
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Icon( Icons .currency_rupee,
                                                                                size: 20,color: Colors.green,),
                                                                            ),
                                                                            Text(data[index].fixRate.toString(),
                                                                              style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight
                                                                                      .w700,
                                                                                  color: Colors
                                                                                      .green),)
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 8,),
                                                                        Text(data[index].fixKm.toString()+" KM",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),),
                                                                        SizedBox(
                                                                          height: 15,),
                                                                        Container(
                                                                            height: 25,
                                                                            width: 85,
                                                                            child: MaterialButton(
                                                                              color: Colors
                                                                                  .lightGreen,
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10)),
                                                                              onPressed: () {
                                                                                  getCheckout(Mobile);
                                                                                setState(() {
                                                                                  fueltotalrent=data[index].fixRate.toString();
                                                                                  print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                  child: Text(
                                                                                    "BOOKED",
                                                                                    style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight
                                                                                            .w500),)),)
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                            );
                                                          }
                                                      ),
                                                    );
                                                  }
                                                }
                                            ),*/
                                                    /* GridView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:3,
                                                    ),
                                                    itemCount:data.length,
                                                    itemBuilder: (BuildContext ctx, index) {
                                                      return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(8)),
                                                          child:Card(elevation: 5,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2,),
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 10),
                                                                        child: Icon(Icons.currency_rupee,size: 20,color: Colors.green,),
                                                                      ),
                                                                      Text(data[index].slot1![index].fixRate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green),)
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 8,),
                                                                  Text(data[index].slot1![index].fixKm.toString() +" KM",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                                                  SizedBox(height:15,),
                                                                  Container(
                                                                      height: 25,width: 90,
                                                                      child: MaterialButton(
                                                                        color:Colors.lightGreen,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                        onPressed: (){
                                                                          // setState(() {
                                                                          //   onPress = !onPress;
                                                                          //
                                                                          // });
                                                                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedCarInfo()));
                                                                        },
                                                                        child: Center(child: Text("BOOKED",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),)
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    }),*/
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else if (postion
                                              .toLowerCase()
                                              .contains(carsearch.text
                                                  .toLowerCase())) {
                                            return Container(
                                              width: 350,
                                              child: Card(
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            //"assets/tesla.png"
                                                            child:
                                                                Image.network(
                                                              data[index]
                                                                  .vehicleImage
                                                                  .toString(),
                                                              height: 100,
                                                              width: 140,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index]
                                                                          .vehicleName
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .model_training,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          data[index]
                                                                              .modelNo
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .chair_alt_outlined,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            data[index]
                                                                                .vehicleSeat
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 9,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54)),
                                                                        SizedBox(
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        Container(
                                                                          // width: MediaQuery.of(context).size.width/5.7,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.car_repair,
                                                                                color: Colors.black54,
                                                                                size: 15,
                                                                              ),
                                                                              Text(data[index].vehicleCategory.toString(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 125,
                                                    //   child: ListView.builder(
                                                    //       itemCount:data[index].slot1!.length,
                                                    //       itemExtent: 125,
                                                    //       scrollDirection: Axis.horizontal,
                                                    //       itemBuilder: (context, index) {
                                                    //         return Container(
                                                    //             alignment: Alignment.center,
                                                    //             decoration: BoxDecoration(
                                                    //                 color: Colors.white,
                                                    //                 borderRadius: BorderRadius.circular(8)),
                                                    //             child: Card(
                                                    //               elevation: 5,
                                                    //               shape: RoundedRectangleBorder(
                                                    //                   borderRadius: BorderRadius.circular(15)),
                                                    //               child: Padding(
                                                    //                 padding: EdgeInsets.all(8.0),
                                                    //                 child: Column(
                                                    //                   children: [
                                                    //                     SizedBox(
                                                    //                       height: 2,),
                                                    //                     Row(
                                                    //                       children: [
                                                    //                         Padding(
                                                    //                           padding: const EdgeInsets.only(left: 10),
                                                    //                           child: Icon( Icons .currency_rupee,
                                                    //                             size: 20,color: Colors.green,),
                                                    //                         ),
                                                    //                         Text(data[index].slot1![0].fixRate.toString(),
                                                    //                           style: TextStyle(
                                                    //                               fontSize: 18,
                                                    //                               fontWeight: FontWeight
                                                    //                                   .w700,
                                                    //                               color: Colors
                                                    //                                   .green),)
                                                    //                       ],
                                                    //                     ),
                                                    //                     SizedBox(
                                                    //                       height: 8,),
                                                    //                     Text(data[index].slot1![0].fixKm.toString()+" KM",
                                                    //                       style: TextStyle(
                                                    //                           fontSize: 13,
                                                    //                           fontWeight: FontWeight.w700,
                                                    //                           color: Colors.black54),),
                                                    //                     SizedBox(
                                                    //                       height: 15,),
                                                    //                     bookingSt=="0"? Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors
                                                    //                               .lightGreen,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             getCheckout2(Mobile);
                                                    //                             setState(() {
                                                    //                               vehicle_id=data[index].vehicleId.toString();
                                                    //                               fuel_type1=data[index].fuelType.toString();
                                                    //                               fueltotalrent=data[index].slot1![index].fixRate.toString();
                                                    //                               fix_km1=data[index].slot1![index].fixKm.toString();
                                                    //                             });
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOK NOW",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 11,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     bookingSt=="1"?Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors.grey.shade300,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             /* getCheckout2(Mobile);
                                                    //                    setState(() {
                                                    //                      vehicle_id2=data[index].vehicleId.toString();
                                                    //                      fuel_type2=data[index].fuelType.toString();
                                                    //                      fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                    //                      fix_km2=data[index].slot![0].fixKm.toString();
                                                    //                    });*/
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOKED",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 12,
                                                    //                                     color: Colors.grey,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     Container(),
                                                    //
                                                    //                   ],
                                                    //                 ),
                                                    //               ),
                                                    //             )
                                                    //         );
                                                    //       }
                                                    //   ),
                                                    // ),
                                                    widget.vehicle_type !=
                                                            "bike"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              data[index]
                                                                          .slot1!
                                                                          .length !=
                                                                      0
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![0].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot1![0].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot1![0].fixRate.toString();
                                                                                            fix_km1 = data[index].slot1![0].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot1!
                                                                          .length !=
                                                                      1
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![1].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot1![1].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot1![1].fixRate.toString();
                                                                                            fix_km1 = data[index].slot1![1].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot1![2].fixRate.toString();
                                                                                                fix_km1 = data[index].slot1![2].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot1!
                                                                          .length !=
                                                                      2
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![2].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot1![2].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot1![2].fixRate.toString();
                                                                                            fix_km1 = data[index].slot1![2].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                // vehicle_id=data[index].vehicleId.toString();
                                                                                                // fuel_type1=data[index].fuelType.toString();
                                                                                                // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : widget.vehicle_type !=
                                                                "car"
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  data[index]
                                                                              .slot1!
                                                                              .length !=
                                                                          0
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot1![0].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![0].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot1![0].fixRate.toString();
                                                                                                fix_km1 = data[index].slot1![0].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                  data[index]
                                                                              .slot1!
                                                                              .length !=
                                                                          1
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot1![1].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot1![1].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot1![1].fixRate.toString();
                                                                                                fix_km1 = data[index].slot1![1].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  // getCheckout(Mobile);
                                                                                                  setState(() {
                                                                                                    // vehicle_id=data[index].vehicleId.toString();
                                                                                                    // fuel_type1=data[index].fuelType.toString();
                                                                                                    // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                    // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                    // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                    // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                                  });
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                ],
                                                              )
                                                            : Container(),
                                                    /* FutureBuilder<List<Slot1>>(
                                                future: getSlotCar(),
                                                builder:(context, AsyncSnapshot snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else {
                                                    List<Slot1>? data=snapshot.data;
                                                    return  Container(
                                                      height: 125,
                                                      child: ListView.builder(
                                                          itemCount:data!.length,
                                                          itemExtent: 125,
                                                          scrollDirection: Axis.horizontal,
                                                          itemBuilder: (context, index) {
                                                            return Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8)),
                                                                child: Card(
                                                                  elevation: 5,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(15)),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 2,),
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Icon( Icons .currency_rupee,
                                                                                size: 20,color: Colors.green,),
                                                                            ),
                                                                            Text(data[index].fixRate.toString(),
                                                                              style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight
                                                                                      .w700,
                                                                                  color: Colors
                                                                                      .green),)
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 8,),
                                                                        Text(data[index].fixKm.toString()+" KM",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),),
                                                                        SizedBox(
                                                                          height: 15,),
                                                                        Container(
                                                                            height: 25,
                                                                            width: 85,
                                                                            child: MaterialButton(
                                                                              color: Colors
                                                                                  .lightGreen,
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10)),
                                                                              onPressed: () {
                                                                                  getCheckout(Mobile);
                                                                                setState(() {
                                                                                  fueltotalrent=data[index].fixRate.toString();
                                                                                  print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                  child: Text(
                                                                                    "BOOKED",
                                                                                    style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight
                                                                                            .w500),)),)
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                            );
                                                          }
                                                      ),
                                                    );
                                                  }
                                                }
                                            ),*/
                                                    /* GridView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:3,
                                                    ),
                                                    itemCount:data.length,
                                                    itemBuilder: (BuildContext ctx, index) {
                                                      return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(8)),
                                                          child:Card(elevation: 5,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2,),
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 10),
                                                                        child: Icon(Icons.currency_rupee,size: 20,color: Colors.green,),
                                                                      ),
                                                                      Text(data[index].slot1![index].fixRate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green),)
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 8,),
                                                                  Text(data[index].slot1![index].fixKm.toString() +" KM",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                                                  SizedBox(height:15,),
                                                                  Container(
                                                                      height: 25,width: 90,
                                                                      child: MaterialButton(
                                                                        color:Colors.lightGreen,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                        onPressed: (){
                                                                          // setState(() {
                                                                          //   onPress = !onPress;
                                                                          //
                                                                          // });
                                                                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedCarInfo()));
                                                                        },
                                                                        child: Center(child: Text("BOOKED",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),)
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    }),*/
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  );
                                }
                              })
                          : FutureBuilder<List<ResponseF1>>(
                              future: filterlist1(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  List<ResponseF1>? data = snapshot.data;
                                  return Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.all(8),
                                        itemCount: data!.length,
                                        itemBuilder: (context, index) {
                                          bookingSt = data[index]
                                              .bookingStatus
                                              .toString();
                                          String? postion = data[index]
                                              .vehicleName
                                              .toString();
                                          if (carsearch.text.isEmpty) {
                                            return Container(
                                              width: 350,
                                              child: Card(
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            //"assets/tesla.png"
                                                            child:
                                                                Image.network(
                                                              data[index]
                                                                  .vehicleImage
                                                                  .toString(),
                                                              height: 100,
                                                              width: 140,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index]
                                                                          .vehicleName
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .model_training,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          data[index]
                                                                              .modelNo
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .chair_alt_outlined,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            data[index]
                                                                                .vehicleSeat
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 9,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54)),
                                                                        SizedBox(
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        Container(
                                                                          // width: MediaQuery.of(context).size.width/5.7,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.car_repair,
                                                                                color: Colors.black54,
                                                                                size: 15,
                                                                              ),
                                                                              Text(data[index].vehicleCategory.toString(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 125,
                                                    //   child: ListView.builder(
                                                    //       itemCount:data[index].slot1!.length,
                                                    //       itemExtent: 125,
                                                    //       scrollDirection: Axis.horizontal,
                                                    //       itemBuilder: (context, index) {
                                                    //         return Container(
                                                    //             alignment: Alignment.center,
                                                    //             decoration: BoxDecoration(
                                                    //                 color: Colors.white,
                                                    //                 borderRadius: BorderRadius.circular(8)),
                                                    //             child: Card(
                                                    //               elevation: 5,
                                                    //               shape: RoundedRectangleBorder(
                                                    //                   borderRadius: BorderRadius.circular(15)),
                                                    //               child: Padding(
                                                    //                 padding: EdgeInsets.all(8.0),
                                                    //                 child: Column(
                                                    //                   children: [
                                                    //                     SizedBox(
                                                    //                       height: 2,),
                                                    //                     Row(
                                                    //                       children: [
                                                    //                         Padding(
                                                    //                           padding: const EdgeInsets.only(left: 10),
                                                    //                           child: Icon( Icons .currency_rupee,
                                                    //                             size: 20,color: Colors.green,),
                                                    //                         ),
                                                    //                         Text(data[index].slot1![0].fixRate.toString(),
                                                    //                           style: TextStyle(
                                                    //                               fontSize: 18,
                                                    //                               fontWeight: FontWeight
                                                    //                                   .w700,
                                                    //                               color: Colors
                                                    //                                   .green),)
                                                    //                       ],
                                                    //                     ),
                                                    //                     SizedBox(
                                                    //                       height: 8,),
                                                    //                     Text(data[index].slot1![0].fixKm.toString()+" KM",
                                                    //                       style: TextStyle(
                                                    //                           fontSize: 13,
                                                    //                           fontWeight: FontWeight.w700,
                                                    //                           color: Colors.black54),),
                                                    //                     SizedBox(
                                                    //                       height: 15,),
                                                    //                     bookingSt=="0"? Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors
                                                    //                               .lightGreen,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             getCheckout2(Mobile);
                                                    //                             setState(() {
                                                    //                               vehicle_id=data[index].vehicleId.toString();
                                                    //                               fuel_type1=data[index].fuelType.toString();
                                                    //                               fueltotalrent=data[index].slot1![index].fixRate.toString();
                                                    //                               fix_km1=data[index].slot1![index].fixKm.toString();
                                                    //                             });
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOK NOW",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 11,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     bookingSt=="1"?Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors.grey.shade300,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             /* getCheckout2(Mobile);
                                                    //                    setState(() {
                                                    //                      vehicle_id2=data[index].vehicleId.toString();
                                                    //                      fuel_type2=data[index].fuelType.toString();
                                                    //                      fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                    //                      fix_km2=data[index].slot![0].fixKm.toString();
                                                    //                    });*/
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOKED",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 12,
                                                    //                                     color: Colors.grey,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     Container(),
                                                    //
                                                    //                   ],
                                                    //                 ),
                                                    //               ),
                                                    //             )
                                                    //         );
                                                    //       }
                                                    //   ),
                                                    // ),
                                                    widget.vehicle_type !=
                                                            "bike"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      0
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![0].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![0].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot![0].fixRate.toString();
                                                                                            fix_km1 = data[index].slot![0].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      1
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![1].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![1].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot![1].fixRate.toString();
                                                                                            fix_km1 = data[index].slot![1].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot![2].fixRate.toString();
                                                                                                fix_km1 = data[index].slot![2].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      2
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![2].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![2].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot![2].fixRate.toString();
                                                                                            fix_km1 = data[index].slot![2].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                // vehicle_id=data[index].vehicleId.toString();
                                                                                                // fuel_type1=data[index].fuelType.toString();
                                                                                                // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : widget.vehicle_type !=
                                                                "car"
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  data[index]
                                                                              .slot!
                                                                              .length !=
                                                                          0
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot![0].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![0].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot![0].fixRate.toString();
                                                                                                fix_km1 = data[index].slot![0].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                  data[index]
                                                                              .slot!
                                                                              .length !=
                                                                          1
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot![1].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![1].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot![1].fixRate.toString();
                                                                                                fix_km1 = data[index].slot![1].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  // getCheckout(Mobile);
                                                                                                  setState(() {
                                                                                                    // vehicle_id=data[index].vehicleId.toString();
                                                                                                    // fuel_type1=data[index].fuelType.toString();
                                                                                                    // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                    // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                    // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                    // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                                  });
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                ],
                                                              )
                                                            : Container(),
                                                    /* FutureBuilder<List<Slot1>>(
                                                future: getSlotCar(),
                                                builder:(context, AsyncSnapshot snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else {
                                                    List<Slot1>? data=snapshot.data;
                                                    return  Container(
                                                      height: 125,
                                                      child: ListView.builder(
                                                          itemCount:data!.length,
                                                          itemExtent: 125,
                                                          scrollDirection: Axis.horizontal,
                                                          itemBuilder: (context, index) {
                                                            return Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8)),
                                                                child: Card(
                                                                  elevation: 5,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(15)),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 2,),
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Icon( Icons .currency_rupee,
                                                                                size: 20,color: Colors.green,),
                                                                            ),
                                                                            Text(data[index].fixRate.toString(),
                                                                              style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight
                                                                                      .w700,
                                                                                  color: Colors
                                                                                      .green),)
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 8,),
                                                                        Text(data[index].fixKm.toString()+" KM",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),),
                                                                        SizedBox(
                                                                          height: 15,),
                                                                        Container(
                                                                            height: 25,
                                                                            width: 85,
                                                                            child: MaterialButton(
                                                                              color: Colors
                                                                                  .lightGreen,
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10)),
                                                                              onPressed: () {
                                                                                  getCheckout(Mobile);
                                                                                setState(() {
                                                                                  fueltotalrent=data[index].fixRate.toString();
                                                                                  print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                  child: Text(
                                                                                    "BOOKED",
                                                                                    style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight
                                                                                            .w500),)),)
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                            );
                                                          }
                                                      ),
                                                    );
                                                  }
                                                }
                                            ),*/
                                                    /* GridView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:3,
                                                    ),
                                                    itemCount:data.length,
                                                    itemBuilder: (BuildContext ctx, index) {
                                                      return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(8)),
                                                          child:Card(elevation: 5,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2,),
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 10),
                                                                        child: Icon(Icons.currency_rupee,size: 20,color: Colors.green,),
                                                                      ),
                                                                      Text(data[index].slot1![index].fixRate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green),)
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 8,),
                                                                  Text(data[index].slot1![index].fixKm.toString() +" KM",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                                                  SizedBox(height:15,),
                                                                  Container(
                                                                      height: 25,width: 90,
                                                                      child: MaterialButton(
                                                                        color:Colors.lightGreen,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                        onPressed: (){
                                                                          // setState(() {
                                                                          //   onPress = !onPress;
                                                                          //
                                                                          // });
                                                                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedCarInfo()));
                                                                        },
                                                                        child: Center(child: Text("BOOKED",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),)
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    }),*/
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else if (postion
                                              .toLowerCase()
                                              .contains(carsearch.text
                                                  .toLowerCase())) {
                                            return Container(
                                              width: 350,
                                              child: Card(
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            //"assets/tesla.png"
                                                            child:
                                                                Image.network(
                                                              data[index]
                                                                  .vehicleImage
                                                                  .toString(),
                                                              height: 100,
                                                              width: 140,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index]
                                                                          .vehicleName
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black87),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .model_training,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          data[index]
                                                                              .modelNo
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .chair_alt_outlined,
                                                                          color:
                                                                              Colors.black54,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                            data[index]
                                                                                .vehicleSeat
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                fontSize: 9,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54)),
                                                                        SizedBox(
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        Container(
                                                                          // width: MediaQuery.of(context).size.width/5.7,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.car_repair,
                                                                                color: Colors.black54,
                                                                                size: 15,
                                                                              ),
                                                                              Text(data[index].vehicleCategory.toString(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 125,
                                                    //   child: ListView.builder(
                                                    //       itemCount:data[index].slot1!.length,
                                                    //       itemExtent: 125,
                                                    //       scrollDirection: Axis.horizontal,
                                                    //       itemBuilder: (context, index) {
                                                    //         return Container(
                                                    //             alignment: Alignment.center,
                                                    //             decoration: BoxDecoration(
                                                    //                 color: Colors.white,
                                                    //                 borderRadius: BorderRadius.circular(8)),
                                                    //             child: Card(
                                                    //               elevation: 5,
                                                    //               shape: RoundedRectangleBorder(
                                                    //                   borderRadius: BorderRadius.circular(15)),
                                                    //               child: Padding(
                                                    //                 padding: EdgeInsets.all(8.0),
                                                    //                 child: Column(
                                                    //                   children: [
                                                    //                     SizedBox(
                                                    //                       height: 2,),
                                                    //                     Row(
                                                    //                       children: [
                                                    //                         Padding(
                                                    //                           padding: const EdgeInsets.only(left: 10),
                                                    //                           child: Icon( Icons .currency_rupee,
                                                    //                             size: 20,color: Colors.green,),
                                                    //                         ),
                                                    //                         Text(data[index].slot1![0].fixRate.toString(),
                                                    //                           style: TextStyle(
                                                    //                               fontSize: 18,
                                                    //                               fontWeight: FontWeight
                                                    //                                   .w700,
                                                    //                               color: Colors
                                                    //                                   .green),)
                                                    //                       ],
                                                    //                     ),
                                                    //                     SizedBox(
                                                    //                       height: 8,),
                                                    //                     Text(data[index].slot1![0].fixKm.toString()+" KM",
                                                    //                       style: TextStyle(
                                                    //                           fontSize: 13,
                                                    //                           fontWeight: FontWeight.w700,
                                                    //                           color: Colors.black54),),
                                                    //                     SizedBox(
                                                    //                       height: 15,),
                                                    //                     bookingSt=="0"? Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors
                                                    //                               .lightGreen,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             getCheckout2(Mobile);
                                                    //                             setState(() {
                                                    //                               vehicle_id=data[index].vehicleId.toString();
                                                    //                               fuel_type1=data[index].fuelType.toString();
                                                    //                               fueltotalrent=data[index].slot1![index].fixRate.toString();
                                                    //                               fix_km1=data[index].slot1![index].fixKm.toString();
                                                    //                             });
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOK NOW",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 11,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     bookingSt=="1"?Container(
                                                    //                         height: 30,
                                                    //                         width: 100,
                                                    //                         child: MaterialButton(
                                                    //                           color: Colors.grey.shade300,
                                                    //                           shape: RoundedRectangleBorder(
                                                    //                               borderRadius: BorderRadius
                                                    //                                   .circular(
                                                    //                                   10)),
                                                    //                           onPressed: () {
                                                    //                             /* getCheckout2(Mobile);
                                                    //                    setState(() {
                                                    //                      vehicle_id2=data[index].vehicleId.toString();
                                                    //                      fuel_type2=data[index].fuelType.toString();
                                                    //                      fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                    //                      fix_km2=data[index].slot![0].fixKm.toString();
                                                    //                    });*/
                                                    //                           },
                                                    //                           child: Center(
                                                    //                               child: Text(
                                                    //                                 "BOOKED",
                                                    //                                 style: TextStyle(
                                                    //                                     fontSize: 12,
                                                    //                                     color: Colors.grey,
                                                    //                                     fontWeight: FontWeight
                                                    //                                         .w700),)),)
                                                    //                     ):
                                                    //                     Container(),
                                                    //
                                                    //                   ],
                                                    //                 ),
                                                    //               ),
                                                    //             )
                                                    //         );
                                                    //       }
                                                    //   ),
                                                    // ),
                                                    widget.vehicle_type !=
                                                            "bike"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      0
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![0].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![0].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot![0].fixRate.toString();
                                                                                            fix_km1 = data[index].slot![0].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      1
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![1].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![1].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot![1].fixRate.toString();
                                                                                            fix_km1 = data[index].slot![1].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot![2].fixRate.toString();
                                                                                                fix_km1 = data[index].slot![2].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      2
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![2].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![2].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout(Mobile);
                                                                                            vehicle_id = data[index].vehicleId.toString();
                                                                                            fuel_type1 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            print("oijojhfh====>>>>" + vehicle_id);
                                                                                            fueltotalrent = data[index].slot![2].fixRate.toString();
                                                                                            fix_km1 = data[index].slot![2].fixKm.toString();
                                                                                            print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOk NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              // getCheckout(Mobile);
                                                                                              setState(() {
                                                                                                // vehicle_id=data[index].vehicleId.toString();
                                                                                                // fuel_type1=data[index].fuelType.toString();
                                                                                                // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : widget.vehicle_type !=
                                                                "car"
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  data[index]
                                                                              .slot!
                                                                              .length !=
                                                                          0
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot![0].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![0].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot![0].fixRate.toString();
                                                                                                fix_km1 = data[index].slot![0].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  /*  getCheckout(Mobile);
                                                                    setState(() {
                                                                      vehicle_id=data[index].vehicleId.toString();
                                                                      fuel_type1=data[index].fuelType.toString();
                                                                      print("oijojhfh====>>>>"+vehicle_id);
                                                                      fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                      fix_km1=data[index].slot1![2].fixKm.toString();
                                                                      print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                    });*/
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                  data[index]
                                                                              .slot!
                                                                              .length !=
                                                                          1
                                                                      ? Container(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3.22,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child: Card(
                                                                            elevation:
                                                                                5,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: 2,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                        child: Icon(
                                                                                          Icons.currency_rupee,
                                                                                          size: 20,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        data[index].slot![1].fixRate.toString(),
                                                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![1].fixKm.toString() + " KM",
                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 15,
                                                                                  ),
                                                                                  bookingSt == "0"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.lightGreen,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                getCheckout(Mobile);
                                                                                                vehicle_id = data[index].vehicleId.toString();
                                                                                                fuel_type1 = data[index].fuelType.toString();
                                                                                                vehcile_img = data[index].vehicleImage.toString();
                                                                                                print("oijojhfh====>>>>" + vehicle_id);
                                                                                                fueltotalrent = data[index].slot![1].fixRate.toString();
                                                                                                fix_km1 = data[index].slot![1].fixKm.toString();
                                                                                                print("fueltotalrent==--->>>>" + fueltotalrent);
                                                                                              });
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOk NOW",
                                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : bookingSt == "1"
                                                                                          ? Container(
                                                                                              height: 30,
                                                                                              width: 100,
                                                                                              child: MaterialButton(
                                                                                                color: Colors.grey.shade300,
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                onPressed: () {
                                                                                                  // getCheckout(Mobile);
                                                                                                  setState(() {
                                                                                                    // vehicle_id=data[index].vehicleId.toString();
                                                                                                    // fuel_type1=data[index].fuelType.toString();
                                                                                                    // print("oijojhfh====>>>>"+vehicle_id);
                                                                                                    // fueltotalrent=data[index].slot1![2].fixRate.toString();
                                                                                                    // fix_km1=data[index].slot1![2].fixKm.toString();
                                                                                                    // print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                                  });
                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "BOOKED",
                                                                                                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                                )),
                                                                                              ))
                                                                                          : Container(),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      : Container(),
                                                                ],
                                                              )
                                                            : Container(),
                                                    /* FutureBuilder<List<Slot1>>(
                                                future: getSlotCar(),
                                                builder:(context, AsyncSnapshot snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else {
                                                    List<Slot1>? data=snapshot.data;
                                                    return  Container(
                                                      height: 125,
                                                      child: ListView.builder(
                                                          itemCount:data!.length,
                                                          itemExtent: 125,
                                                          scrollDirection: Axis.horizontal,
                                                          itemBuilder: (context, index) {
                                                            return Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(8)),
                                                                child: Card(
                                                                  elevation: 5,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(15)),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 2,),
                                                                        Row(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Icon( Icons .currency_rupee,
                                                                                size: 20,color: Colors.green,),
                                                                            ),
                                                                            Text(data[index].fixRate.toString(),
                                                                              style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight
                                                                                      .w700,
                                                                                  color: Colors
                                                                                      .green),)
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 8,),
                                                                        Text(data[index].fixKm.toString()+" KM",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: Colors.black54),),
                                                                        SizedBox(
                                                                          height: 15,),
                                                                        Container(
                                                                            height: 25,
                                                                            width: 85,
                                                                            child: MaterialButton(
                                                                              color: Colors
                                                                                  .lightGreen,
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      10)),
                                                                              onPressed: () {
                                                                                  getCheckout(Mobile);
                                                                                setState(() {
                                                                                  fueltotalrent=data[index].fixRate.toString();
                                                                                  print("fueltotalrent==--->>>>"+fueltotalrent);
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                  child: Text(
                                                                                    "BOOKED",
                                                                                    style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight
                                                                                            .w500),)),)
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                            );
                                                          }
                                                      ),
                                                    );
                                                  }
                                                }
                                            ),*/
                                                    /* GridView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:3,
                                                    ),
                                                    itemCount:data.length,
                                                    itemBuilder: (BuildContext ctx, index) {
                                                      return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(8)),
                                                          child:Card(elevation: 5,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 2,),
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 10),
                                                                        child: Icon(Icons.currency_rupee,size: 20,color: Colors.green,),
                                                                      ),
                                                                      Text(data[index].slot1![index].fixRate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green),)
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 8,),
                                                                  Text(data[index].slot1![index].fixKm.toString() +" KM",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                                                  SizedBox(height:15,),
                                                                  Container(
                                                                      height: 25,width: 90,
                                                                      child: MaterialButton(
                                                                        color:Colors.lightGreen,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                        onPressed: (){
                                                                          // setState(() {
                                                                          //   onPress = !onPress;
                                                                          //
                                                                          // });
                                                                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedCarInfo()));
                                                                        },
                                                                        child: Center(child: Text("BOOKED",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),)
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    }),*/
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  );
                                }
                              }),
                      FutureBuilder<List<Response1>>(
                          future: getNonFuelCar(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<Response1>? data = snapshot.data;
                              return Container(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      bookingSt2 =
                                          data[index].bookingStatus.toString();
                                      String? postion =
                                          data[index].vehicleName.toString();
                                      if (carsearch.text.isEmpty) {
                                        return Container(
                                          width: 350,
                                          child: Card(
                                            elevation: 2,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        //"assets/tesla.png"
                                                        child: Image.network(
                                                          data[index]
                                                              .vehicleImage
                                                              .toString(),
                                                          height: 100,
                                                          width: 150,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5,
                                                                    bottom: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  data[index]
                                                                      .vehicleName
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .model_training,
                                                                      color: Colors
                                                                          .black54,
                                                                      size: 15,
                                                                    ),
                                                                    Text(
                                                                      data[index]
                                                                          .modelNo
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 1,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .chair_alt_outlined,
                                                                      color: Colors
                                                                          .black54,
                                                                      size: 15,
                                                                    ),
                                                                    Text(
                                                                        data[index]
                                                                            .vehicleSeat
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.black54)),
                                                                    SizedBox(
                                                                      width: 1,
                                                                    ),
                                                                    Container(
                                                                      //width: MediaQuery.of(context).size.width/6,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.car_repair,
                                                                            color:
                                                                                Colors.black54,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                              data[index].vehicleCategory.toString(),
                                                                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Container(
                                                //   height: 125,
                                                //   child: ListView.builder(
                                                //       itemCount:data[index].slot!.length,
                                                //       itemExtent: 125,
                                                //       scrollDirection: Axis.horizontal,
                                                //       itemBuilder: (context, index) {
                                                //         return Container(
                                                //             alignment: Alignment.center,
                                                //             decoration: BoxDecoration(
                                                //                 color: Colors.white,
                                                //                 borderRadius: BorderRadius.circular(8)),
                                                //             child: Card(
                                                //               elevation: 5,
                                                //               shape: RoundedRectangleBorder(
                                                //                   borderRadius: BorderRadius.circular(15)),
                                                //               child: Padding(
                                                //                 padding: EdgeInsets.all(8.0),
                                                //                 child: Column(
                                                //                   children: [
                                                //                     SizedBox(
                                                //                       height: 2,),
                                                //                     Row(
                                                //                       children: [
                                                //                         Padding(
                                                //                           padding: const EdgeInsets.only(left: 10),
                                                //                           child: Icon( Icons .currency_rupee,
                                                //                             size: 20,color: Colors.green,),
                                                //                         ),
                                                //                         Text(data[index].slot![0].fixRate.toString(),
                                                //                           style: TextStyle(
                                                //                               fontSize: 18,
                                                //                               fontWeight: FontWeight
                                                //                                   .w700,
                                                //                               color: Colors
                                                //                                   .green),)
                                                //                       ],
                                                //                     ),
                                                //                     SizedBox(
                                                //                       height: 8,),
                                                //                     Text(data[index].slot![0].fixKm.toString()+" KM",
                                                //                       style: TextStyle(
                                                //                           fontSize: 13,
                                                //                           fontWeight: FontWeight.w700,
                                                //                           color: Colors.black54),),
                                                //                     SizedBox(
                                                //                       height: 15,),
                                                //                     bookingSt2=="0"? Container(
                                                //                         height: 30,
                                                //                         width: 100,
                                                //                         child: MaterialButton(
                                                //                           color: Colors
                                                //                               .lightGreen,
                                                //                           shape: RoundedRectangleBorder(
                                                //                               borderRadius: BorderRadius
                                                //                                   .circular(
                                                //                                   10)),
                                                //                           onPressed: () {
                                                //                             getCheckout2(Mobile);
                                                //                             setState(() {
                                                //                               vehicle_id2=data[index].vehicleId.toString();
                                                //                               fuel_type2=data[index].fuelType.toString();
                                                //                               fueltotalrent2=data[index].slot![index].fixRate.toString();
                                                //                               fix_km2=data[index].slot![index].fixKm.toString();
                                                //                             });
                                                //                           },
                                                //                           child: Center(
                                                //                               child: Text(
                                                //                                 "BOOK NOW",
                                                //                                 style: TextStyle(
                                                //                                     fontSize: 11,
                                                //                                     fontWeight: FontWeight
                                                //                                         .w700),)),)
                                                //                     ):
                                                //                     bookingSt2=="1"?Container(
                                                //                         height: 30,
                                                //                         width: 100,
                                                //                         child: MaterialButton(
                                                //                           color: Colors.grey.shade300,
                                                //                           shape: RoundedRectangleBorder(
                                                //                               borderRadius: BorderRadius
                                                //                                   .circular(
                                                //                                   10)),
                                                //                           onPressed: () {
                                                //                             /* getCheckout2(Mobile);
                                                //                  setState(() {
                                                //                    vehicle_id2=data[index].vehicleId.toString();
                                                //                    fuel_type2=data[index].fuelType.toString();
                                                //                    fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                //                    fix_km2=data[index].slot![0].fixKm.toString();
                                                //                  });*/
                                                //                           },
                                                //                           child: Center(
                                                //                               child: Text(
                                                //                                 "BOOKED",
                                                //                                 style: TextStyle(
                                                //                                     fontSize: 12,
                                                //                                     color: Colors.grey,
                                                //                                     fontWeight: FontWeight
                                                //                                         .w700),)),)
                                                //                     ):
                                                //                     Container(),
                                                //
                                                //                   ],
                                                //                 ),
                                                //               ),
                                                //             )
                                                //         );
                                                //       }
                                                //   ),
                                                // ),
                                                widget.vehicle_type != "bike"
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          data[index]
                                                                      .slot!
                                                                      .length !=
                                                                  0
                                                              ? Container(
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      3.22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  Icons.currency_rupee,
                                                                                  size: 20,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![0].fixRate.toString(),
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data[index].slot![0].fixKm.toString() +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          bookingSt2 == "0"
                                                                              ? Container(
                                                                                  height: 30,
                                                                                  width: 100,
                                                                                  child: MaterialButton(
                                                                                    color: Colors.lightGreen,
                                                                                    highlightColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        getCheckout2(Mobile);
                                                                                        vehicle_id2 = data[index].vehicleId.toString();
                                                                                        vehcile_img = data[index].vehicleImage.toString();
                                                                                        fuel_type2 = data[index].fuelType.toString();
                                                                                        fueltotalrent2 = data[index].slot![0].fixRate.toString();
                                                                                        fix_km2 = data[index].slot![0].fixKm.toString();
                                                                                      });
                                                                                    },
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "BOOK NOW",
                                                                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                    )),
                                                                                  ))
                                                                              : bookingSt2 == "1"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.grey.shade300,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOKED",
                                                                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                          data[index]
                                                                      .slot!
                                                                      .length !=
                                                                  1
                                                              ? Container(
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      3.22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  Icons.currency_rupee,
                                                                                  size: 20,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![1].fixRate.toString(),
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data[index].slot![1].fixKm.toString() +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          bookingSt2 == "0"
                                                                              ? Container(
                                                                                  height: 30,
                                                                                  width: 100,
                                                                                  child: MaterialButton(
                                                                                    color: Colors.lightGreen,
                                                                                    highlightColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        getCheckout2(Mobile);
                                                                                        vehicle_id2 = data[index].vehicleId.toString();
                                                                                        fuel_type2 = data[index].fuelType.toString();
                                                                                        vehcile_img = data[index].vehicleImage.toString();
                                                                                        fueltotalrent2 = data[index].slot![1].fixRate.toString();
                                                                                        fix_km2 = data[index].slot![1].fixKm.toString();
                                                                                      });
                                                                                    },
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "BOOK NOW",
                                                                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                    )),
                                                                                  ))
                                                                              : bookingSt2 == "1"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.grey.shade300,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOKED",
                                                                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                          data[index]
                                                                      .slot!
                                                                      .length !=
                                                                  2
                                                              ? Container(
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      3.22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  Icons.currency_rupee,
                                                                                  size: 20,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![2].fixRate.toString(),
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data[index].slot![2].fixKm.toString() +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          bookingSt2 == "0"
                                                                              ? Container(
                                                                                  height: 30,
                                                                                  width: 100,
                                                                                  child: MaterialButton(
                                                                                    color: Colors.lightGreen,
                                                                                    highlightColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        getCheckout2(Mobile);
                                                                                        vehicle_id2 = data[index].vehicleId.toString();
                                                                                        fuel_type2 = data[index].fuelType.toString();
                                                                                        vehcile_img = data[index].vehicleImage.toString();
                                                                                        fueltotalrent2 = data[index].slot![2].fixRate.toString();
                                                                                        fix_km2 = data[index].slot![2].fixKm.toString();
                                                                                      });
                                                                                    },
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "BOOK NOW",
                                                                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                    )),
                                                                                  ))
                                                                              : bookingSt2 == "1"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.grey.shade300,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOKED",
                                                                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                        ],
                                                      )
                                                    : widget.vehicle_type !=
                                                            "car"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      0
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![0].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![0].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt2 == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        highlightColor: Colors.grey,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout2(Mobile);
                                                                                            vehicle_id2 = data[index].vehicleId.toString();
                                                                                            fuel_type2 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            fueltotalrent2 = data[index].slot![0].fixRate.toString();
                                                                                            fix_km2 = data[index].slot![0].fixKm.toString();
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOK NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt2 == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      1
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![1].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![1].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt2 == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        highlightColor: Colors.grey,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout2(Mobile);
                                                                                            vehicle_id2 = data[index].vehicleId.toString();
                                                                                            fuel_type2 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            fueltotalrent2 = data[index].slot![1].fixRate.toString();
                                                                                            fix_km2 = data[index].slot![1].fixKm.toString();
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOK NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt2 == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : Container(),
                                                /* FutureBuilder<List<Slot>>(
                                                    future: getNonSlotCar(),
                                                    builder:(context, AsyncSnapshot snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Center(child: CircularProgressIndicator());
                                                      } else {
                                                        List<Slot>? data=snapshot.data;
                                                        return  Container(
                                                          height: 125,
                                                          child: ListView.builder(
                                                              itemCount:data!.length,
                                                              itemExtent: 125,
                                                              scrollDirection: Axis.horizontal,
                                                              itemBuilder: (context, index) {
                                                                return Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius
                                                                            .circular(8)),
                                                                    child: Card(
                                                                      elevation: 5,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius .circular(15)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 2,),
                                                                            Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 10),
                                                                                  child: Icon( Icons .currency_rupee,
                                                                                    size: 20,color: Colors.green,),
                                                                                ),
                                                                                Text(data[index].fixRate.toString(),
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight
                                                                                          .w700,
                                                                                      color: Colors
                                                                                          .green),)
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8,),
                                                                            Text(data[index].fixKm.toString()+" KM",
                                                                              style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: Colors.black54),),
                                                                            SizedBox(
                                                                              height: 15,),
                                                                            Container(
                                                                                height: 25,
                                                                                width: 90,
                                                                                child: MaterialButton(
                                                                                  color: Colors
                                                                                      .lightGreen,
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          10)),
                                                                                  onPressed: () {
                                                                                    getCheckout2(Mobile);
                                                                                    setState(() {
                                                                                      fueltotalrent2=data[index].fixRate.toString();
                                                                                    });
                                                                                  },
                                                                                  child: Center(
                                                                                      child: Text(
                                                                                        "BOOKED",
                                                                                        style: TextStyle(
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight
                                                                                                .w500),)),)
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                );
                                                              }
                                                          ),
                                                        );
                                                      }
                                                    }
                                                ),*/
                                                /* GridView.count(
                                                crossAxisCount: 3,
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12.0, top: 8.0),
                                                scrollDirection: Axis.vertical,
                                                childAspectRatio:0.9,
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: List.generate(data.length, (index) {
                                                  return Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(8)),
                                                      child:Card(elevation: 5,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 2,),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10),
                                                                    child: Icon(Icons.currency_rupee,size: 20,color: Colors.green,),
                                                                  ),
                                                                  Text(data[index].slot![index].fixRate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green),)
                                                                ],
                                                              ),
                                                              SizedBox(height: 8,),
                                                              Text(data[index].slot![index].fixKm.toString() +" KM",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                                              SizedBox(height:15,),
                                                              Container(
                                                                  height: 25,width: 90,
                                                                  child: MaterialButton(
                                                                    color:Colors.lightGreen,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                    onPressed: (){
                                                                      // setState(() {
                                                                      //   onPress = !onPress;
                                                                      //
                                                                      // });
                                                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedCarInfo()));
                                                                    },
                                                                    child: Center(child: Text("BOOKED",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),)
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  );
                                                })),*/
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (postion.toLowerCase().contains(
                                          carsearch.text.toLowerCase())) {
                                        return Container(
                                          width: 350,
                                          child: Card(
                                            elevation: 2,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        //"assets/tesla.png"
                                                        child: Image.network(
                                                          data[index]
                                                              .vehicleImage
                                                              .toString(),
                                                          height: 100,
                                                          width: 150,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5,
                                                                    bottom: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  data[index]
                                                                      .vehicleName
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .model_training,
                                                                      color: Colors
                                                                          .black54,
                                                                      size: 15,
                                                                    ),
                                                                    Text(
                                                                      data[index]
                                                                          .modelNo
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 1,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .chair_alt_outlined,
                                                                      color: Colors
                                                                          .black54,
                                                                      size: 15,
                                                                    ),
                                                                    Text(
                                                                        data[index]
                                                                            .vehicleSeat
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: Colors.black54)),
                                                                    SizedBox(
                                                                      width: 1,
                                                                    ),
                                                                    Container(
                                                                      //width: MediaQuery.of(context).size.width/6,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.car_repair,
                                                                            color:
                                                                                Colors.black54,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                              data[index].vehicleCategory.toString(),
                                                                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Container(
                                                //   height: 125,
                                                //   child: ListView.builder(
                                                //       itemCount:data[index].slot!.length,
                                                //       itemExtent: 125,
                                                //       scrollDirection: Axis.horizontal,
                                                //       itemBuilder: (context, index) {
                                                //         return Container(
                                                //             alignment: Alignment.center,
                                                //             decoration: BoxDecoration(
                                                //                 color: Colors.white,
                                                //                 borderRadius: BorderRadius.circular(8)),
                                                //             child: Card(
                                                //               elevation: 5,
                                                //               shape: RoundedRectangleBorder(
                                                //                   borderRadius: BorderRadius.circular(15)),
                                                //               child: Padding(
                                                //                 padding: EdgeInsets.all(8.0),
                                                //                 child: Column(
                                                //                   children: [
                                                //                     SizedBox(
                                                //                       height: 2,),
                                                //                     Row(
                                                //                       children: [
                                                //                         Padding(
                                                //                           padding: const EdgeInsets.only(left: 10),
                                                //                           child: Icon( Icons .currency_rupee,
                                                //                             size: 20,color: Colors.green,),
                                                //                         ),
                                                //                         Text(data[index].slot![0].fixRate.toString(),
                                                //                           style: TextStyle(
                                                //                               fontSize: 18,
                                                //                               fontWeight: FontWeight
                                                //                                   .w700,
                                                //                               color: Colors
                                                //                                   .green),)
                                                //                       ],
                                                //                     ),
                                                //                     SizedBox(
                                                //                       height: 8,),
                                                //                     Text(data[index].slot![0].fixKm.toString()+" KM",
                                                //                       style: TextStyle(
                                                //                           fontSize: 13,
                                                //                           fontWeight: FontWeight.w700,
                                                //                           color: Colors.black54),),
                                                //                     SizedBox(
                                                //                       height: 15,),
                                                //                     bookingSt2=="0"? Container(
                                                //                         height: 30,
                                                //                         width: 100,
                                                //                         child: MaterialButton(
                                                //                           color: Colors
                                                //                               .lightGreen,
                                                //                           shape: RoundedRectangleBorder(
                                                //                               borderRadius: BorderRadius
                                                //                                   .circular(
                                                //                                   10)),
                                                //                           onPressed: () {
                                                //                             getCheckout2(Mobile);
                                                //                             setState(() {
                                                //                               vehicle_id2=data[index].vehicleId.toString();
                                                //                               fuel_type2=data[index].fuelType.toString();
                                                //                               fueltotalrent2=data[index].slot![index].fixRate.toString();
                                                //                               fix_km2=data[index].slot![index].fixKm.toString();
                                                //                             });
                                                //                           },
                                                //                           child: Center(
                                                //                               child: Text(
                                                //                                 "BOOK NOW",
                                                //                                 style: TextStyle(
                                                //                                     fontSize: 11,
                                                //                                     fontWeight: FontWeight
                                                //                                         .w700),)),)
                                                //                     ):
                                                //                     bookingSt2=="1"?Container(
                                                //                         height: 30,
                                                //                         width: 100,
                                                //                         child: MaterialButton(
                                                //                           color: Colors.grey.shade300,
                                                //                           shape: RoundedRectangleBorder(
                                                //                               borderRadius: BorderRadius
                                                //                                   .circular(
                                                //                                   10)),
                                                //                           onPressed: () {
                                                //                             /* getCheckout2(Mobile);
                                                //                  setState(() {
                                                //                    vehicle_id2=data[index].vehicleId.toString();
                                                //                    fuel_type2=data[index].fuelType.toString();
                                                //                    fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                //                    fix_km2=data[index].slot![0].fixKm.toString();
                                                //                  });*/
                                                //                           },
                                                //                           child: Center(
                                                //                               child: Text(
                                                //                                 "BOOKED",
                                                //                                 style: TextStyle(
                                                //                                     fontSize: 12,
                                                //                                     color: Colors.grey,
                                                //                                     fontWeight: FontWeight
                                                //                                         .w700),)),)
                                                //                     ):
                                                //                     Container(),
                                                //
                                                //                   ],
                                                //                 ),
                                                //               ),
                                                //             )
                                                //         );
                                                //       }
                                                //   ),
                                                // ),
                                                widget.vehicle_type != "bike"
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          data[index]
                                                                      .slot!
                                                                      .length !=
                                                                  0
                                                              ? Container(
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      3.22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  Icons.currency_rupee,
                                                                                  size: 20,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![0].fixRate.toString(),
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data[index].slot![0].fixKm.toString() +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          bookingSt2 == "0"
                                                                              ? Container(
                                                                                  height: 30,
                                                                                  width: 100,
                                                                                  child: MaterialButton(
                                                                                    color: Colors.lightGreen,
                                                                                    highlightColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        getCheckout2(Mobile);
                                                                                        vehicle_id2 = data[index].vehicleId.toString();
                                                                                        vehcile_img = data[index].vehicleImage.toString();
                                                                                        fuel_type2 = data[index].fuelType.toString();
                                                                                        fueltotalrent2 = data[index].slot![0].fixRate.toString();
                                                                                        fix_km2 = data[index].slot![0].fixKm.toString();
                                                                                      });
                                                                                    },
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "BOOK NOW",
                                                                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                    )),
                                                                                  ))
                                                                              : bookingSt2 == "1"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.grey.shade300,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOKED",
                                                                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                          data[index]
                                                                      .slot!
                                                                      .length !=
                                                                  1
                                                              ? Container(
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      3.22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  Icons.currency_rupee,
                                                                                  size: 20,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![1].fixRate.toString(),
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data[index].slot![1].fixKm.toString() +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          bookingSt2 == "0"
                                                                              ? Container(
                                                                                  height: 30,
                                                                                  width: 100,
                                                                                  child: MaterialButton(
                                                                                    color: Colors.lightGreen,
                                                                                    highlightColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        getCheckout2(Mobile);
                                                                                        vehicle_id2 = data[index].vehicleId.toString();
                                                                                        fuel_type2 = data[index].fuelType.toString();
                                                                                        vehcile_img = data[index].vehicleImage.toString();
                                                                                        fueltotalrent2 = data[index].slot![1].fixRate.toString();
                                                                                        fix_km2 = data[index].slot![1].fixKm.toString();
                                                                                      });
                                                                                    },
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "BOOK NOW",
                                                                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                    )),
                                                                                  ))
                                                                              : bookingSt2 == "1"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.grey.shade300,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOKED",
                                                                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                          data[index]
                                                                      .slot!
                                                                      .length !=
                                                                  2
                                                              ? Container(
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      3.22,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Icon(
                                                                                  Icons.currency_rupee,
                                                                                  size: 20,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![2].fixRate.toString(),
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            data[index].slot![2].fixKm.toString() +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.black54),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          bookingSt2 == "0"
                                                                              ? Container(
                                                                                  height: 30,
                                                                                  width: 100,
                                                                                  child: MaterialButton(
                                                                                    color: Colors.lightGreen,
                                                                                    highlightColor: Colors.grey,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        getCheckout2(Mobile);
                                                                                        vehicle_id2 = data[index].vehicleId.toString();
                                                                                        fuel_type2 = data[index].fuelType.toString();
                                                                                        vehcile_img = data[index].vehicleImage.toString();
                                                                                        fueltotalrent2 = data[index].slot![2].fixRate.toString();
                                                                                        fix_km2 = data[index].slot![2].fixKm.toString();
                                                                                      });
                                                                                    },
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "BOOK NOW",
                                                                                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                    )),
                                                                                  ))
                                                                              : bookingSt2 == "1"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.grey.shade300,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOKED",
                                                                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                              : Container(),
                                                        ],
                                                      )
                                                    : widget.vehicle_type !=
                                                            "car"
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      0
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![0].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![0].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt2 == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        highlightColor: Colors.grey,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout2(Mobile);
                                                                                            vehicle_id2 = data[index].vehicleId.toString();
                                                                                            fuel_type2 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            fueltotalrent2 = data[index].slot![0].fixRate.toString();
                                                                                            fix_km2 = data[index].slot![0].fixKm.toString();
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOK NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt2 == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                              data[index]
                                                                          .slot!
                                                                          .length !=
                                                                      1
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width /
                                                                          3.22,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              8)),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 2,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Icon(
                                                                                      Icons.currency_rupee,
                                                                                      size: 20,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].slot![1].fixRate.toString(),
                                                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.green),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data[index].slot![1].fixKm.toString() + " KM",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              bookingSt2 == "0"
                                                                                  ? Container(
                                                                                      height: 30,
                                                                                      width: 100,
                                                                                      child: MaterialButton(
                                                                                        color: Colors.lightGreen,
                                                                                        highlightColor: Colors.grey,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            getCheckout2(Mobile);
                                                                                            vehicle_id2 = data[index].vehicleId.toString();
                                                                                            fuel_type2 = data[index].fuelType.toString();
                                                                                            vehcile_img = data[index].vehicleImage.toString();
                                                                                            fueltotalrent2 = data[index].slot![1].fixRate.toString();
                                                                                            fix_km2 = data[index].slot![1].fixKm.toString();
                                                                                          });
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          "BOOK NOW",
                                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
                                                                                        )),
                                                                                      ))
                                                                                  : bookingSt2 == "1"
                                                                                      ? Container(
                                                                                          height: 30,
                                                                                          width: 100,
                                                                                          child: MaterialButton(
                                                                                            color: Colors.grey.shade300,
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            onPressed: () {
                                                                                              /* getCheckout2(Mobile);
                                                                   setState(() {
                                                                     vehicle_id2=data[index].vehicleId.toString();
                                                                     fuel_type2=data[index].fuelType.toString();
                                                                     fueltotalrent2=data[index].slot![0].fixRate.toString();
                                                                     fix_km2=data[index].slot![0].fixKm.toString();
                                                                   });*/
                                                                                            },
                                                                                            child: Center(
                                                                                                child: Text(
                                                                                              "BOOKED",
                                                                                              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700),
                                                                                            )),
                                                                                          ))
                                                                                      : Container(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Container(),
                                                            ],
                                                          )
                                                        : Container(),
                                                /* FutureBuilder<List<Slot>>(
                                                    future: getNonSlotCar(),
                                                    builder:(context, AsyncSnapshot snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Center(child: CircularProgressIndicator());
                                                      } else {
                                                        List<Slot>? data=snapshot.data;
                                                        return  Container(
                                                          height: 125,
                                                          child: ListView.builder(
                                                              itemCount:data!.length,
                                                              itemExtent: 125,
                                                              scrollDirection: Axis.horizontal,
                                                              itemBuilder: (context, index) {
                                                                return Container(
                                                                    alignment: Alignment
                                                                        .center,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius
                                                                            .circular(8)),
                                                                    child: Card(
                                                                      elevation: 5,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius .circular(15)),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 2,),
                                                                            Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 10),
                                                                                  child: Icon( Icons .currency_rupee,
                                                                                    size: 20,color: Colors.green,),
                                                                                ),
                                                                                Text(data[index].fixRate.toString(),
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight
                                                                                          .w700,
                                                                                      color: Colors
                                                                                          .green),)
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8,),
                                                                            Text(data[index].fixKm.toString()+" KM",
                                                                              style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: Colors.black54),),
                                                                            SizedBox(
                                                                              height: 15,),
                                                                            Container(
                                                                                height: 25,
                                                                                width: 90,
                                                                                child: MaterialButton(
                                                                                  color: Colors
                                                                                      .lightGreen,
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          10)),
                                                                                  onPressed: () {
                                                                                    getCheckout2(Mobile);
                                                                                    setState(() {
                                                                                      fueltotalrent2=data[index].fixRate.toString();
                                                                                    });
                                                                                  },
                                                                                  child: Center(
                                                                                      child: Text(
                                                                                        "BOOKED",
                                                                                        style: TextStyle(
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight
                                                                                                .w500),)),)
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                );
                                                              }
                                                          ),
                                                        );
                                                      }
                                                    }
                                                ),*/
                                                /* GridView.count(
                                                crossAxisCount: 3,
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, right: 12.0, top: 8.0),
                                                scrollDirection: Axis.vertical,
                                                childAspectRatio:0.9,
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: List.generate(data.length, (index) {
                                                  return Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(8)),
                                                      child:Card(elevation: 5,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 2,),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10),
                                                                    child: Icon(Icons.currency_rupee,size: 20,color: Colors.green,),
                                                                  ),
                                                                  Text(data[index].slot![index].fixRate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.green),)
                                                                ],
                                                              ),
                                                              SizedBox(height: 8,),
                                                              Text(data[index].slot![index].fixKm.toString() +" KM",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),),
                                                              SizedBox(height:15,),
                                                              Container(
                                                                  height: 25,width: 90,
                                                                  child: MaterialButton(
                                                                    color:Colors.lightGreen,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                    onPressed: (){
                                                                      // setState(() {
                                                                      //   onPress = !onPress;
                                                                      //
                                                                      // });
                                                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ChoosedCarInfo()));
                                                                    },
                                                                    child: Center(child: Text("BOOKED",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),)),)
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                  );
                                                })),*/
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                              );
                            }
                          }),
                    ],
                  ),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Contact()));
                } else if (_currentIndex == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Track()));
                } else if (_currentIndex == 3) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
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
            )),
      ),
    );
  }

  Widget buildsheet() => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0))),
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Brand",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Segment",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "________",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "___________",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 320,
                                  child: FutureBuilder<
                                          List<ResponseUserRegister1>>(
                                      future: getBrand(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          List<ResponseUserRegister1>? data =
                                              snapshot.data;
                                          return ListView.builder(
                                              itemCount: data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return CheckboxListTile(
                                                  activeColor: Colors.green,
                                                  title: Text(
                                                    data[index]
                                                        .brnadName
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  value: Brandlist.contains(
                                                      data[index]
                                                          .brnadName
                                                          .toString()),
                                                  onChanged: (bool? Value) {
                                                    setState(() {});
                                                    if (Value!) {
                                                      Brandlist.add(data[index]
                                                          .brnadName
                                                          .toString());
                                                      print("data==>>" +
                                                          Brandlist.toString());
                                                    } else {
                                                      Brandlist.remove(
                                                          data[index]
                                                              .brnadName
                                                              .toString());
                                                    }
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading, //  <-- leading Checkbox
                                                );
                                              });
                                        }
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 320,
                                  child: FutureBuilder<
                                          List<ResponseUserRegister>>(
                                      future: getSegment(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          List<ResponseUserRegister>? data =
                                              snapshot.data;
                                          return ListView.builder(
                                              itemCount: data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return CheckboxListTile(
                                                  activeColor: Colors.green,
                                                  title: Text(
                                                    data[index]
                                                        .vsubSubType
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  value: Segmentlist.contains(
                                                      data[index]
                                                          .vsubSubType
                                                          .toString()),
                                                  onChanged: (bool? Value) {
                                                    setState(() {});
                                                    if (Value!) {
                                                      Segmentlist.add(
                                                          data[index]
                                                              .vsubSubType
                                                              .toString());
                                                      print("data==>>" +
                                                          Segmentlist
                                                              .toString());
                                                    } else {
                                                      Segmentlist.remove(
                                                          data[index]
                                                              .vsubSubType
                                                              .toString());
                                                    }
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading, //  <-- leading Checkbox
                                                );
                                              });
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Transmission Type",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Fuel Type",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "_______________________",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "____________",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 220,
                                  child: ListView.builder(
                                      itemCount: name.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          child: CheckboxListTile(
                                            activeColor: Colors.green,
                                            title: Text(name[index].toString()),
                                            value: Transmissionlist.contains(
                                                name[index].toString()),
                                            onChanged: (bool? Value) {
                                              setState(() {});
                                              if (Value!) {
                                                Transmissionlist.add(
                                                    name[index].toString());
                                                print("data==>>" +
                                                    Transmissionlist
                                                        .toString());
                                              } else {
                                                Transmissionlist.remove(
                                                    name[index].toString());
                                              }
                                            },
                                            controlAffinity: ListTileControlAffinity
                                                .leading, //  <-- leading Checkbox
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 220,
                                  child: FutureBuilder<
                                          List<ResponseUserRegister2>>(
                                      future: getFuelType(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          List<ResponseUserRegister2>? data =
                                              snapshot.data;
                                          return ListView.builder(
                                              itemCount: data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return CheckboxListTile(
                                                  activeColor: Colors.green,
                                                  title: Text(
                                                    data[index]
                                                        .fixFuelType
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  value: FuelTypelist.contains(
                                                      data[index]
                                                          .fixFuelType
                                                          .toString()),
                                                  onChanged: (bool? Value) {
                                                    setState(() {});
                                                    if (Value!) {
                                                      FuelTypelist.add(
                                                          data[index]
                                                              .fixFuelType
                                                              .toString());
                                                      print("data==>>" +
                                                          FuelTypelist
                                                              .toString());
                                                    } else {
                                                      FuelTypelist.remove(
                                                          data[index]
                                                              .fixFuelType
                                                              .toString());
                                                    }
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading, //  <-- leading Checkbox
                                                );
                                              });
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: MaterialButton(
                                  height: 40,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 2.3,
                                  highlightColor: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      Brandlist.clear();
                                      Segmentlist.clear();
                                      FuelTypelist.clear();
                                      Transmissionlist.clear();
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return buildsheet();
                                        },
                                        isScrollControlled: true,
                                      );
                                    });
                                  },
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: MediaQuery.of(context).size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: MaterialButton(
                                  height: 40,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 2.3,
                                  highlightColor: Colors.grey,
                                  onPressed: () {
                                    setState(() {
                                      fil1 = true;
                                      //nonFuelFilter();
                                      filterlist1();
                                      // for(var i=0; i<Segmentlist.length; i++){
                                      //   if (Segmentlist[i].runtimeType == String){
                                      //     print("-it's a String");
                                      //   }else{
                                      //     print("Not int");
                                      //   }
                                      // }
                                      // FuelFilter();
                                      // Segmentlist.clear();
                                      // Brandlist.clear();
                                      // FuelTypelist.clear();
                                      // Transmissionlist.clear();
                                      Navigator.pop(context);
                                      // Navigator.pushAndRemoveUntil(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => CarDetails(
                                      //     StartDate: '', CityId: '',
                                      //     EndDate: '', city :widget.city.toString(),
                                      //     pickup_date: widget.pickup_date.toString(), pickup_time: widget.pickup_time.toString(),
                                      //     drop_date: widget.drop_date.toString(), drop_time: widget.drop_time.toString(),
                                      //     vehicle_type: widget.vehicle_type.toString(),)), // this mymainpage is your page to refresh
                                      //       (Route<dynamic> route) => false,
                                      // );
                                    });
                                  },
                                  child: Text(
                                    "Apply",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );

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
                child: Container(
                  width: 350,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Car1'),
                          Text('Car1'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* CheckboxListTile(
                    title: Text("title text"),
                    value: checkedValue,
                    onChanged: (bool? Value) {

                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),*/
                          Text('Car1'),
                        ],
                      ),
                    ],
                  ),
                ),
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
                  /* _selectStartDate(context);*/
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
                          widget.pickup_date + "    " + widget.pickup_time,
                          /*  _Starttime==null?startDate1:StartDate2.toString(),*/
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
                  /* _selectEndtDate(context);*/
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
                            widget.drop_date + "    " + widget.drop_time,
                            /*_Endtime==null?EndtDate1:EndDate2.toString(),*/
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
                  width: 160,
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
                  width: 160,
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

  _getValue() async {
    final pref = await SharedPreferences.getInstance();
    String? get1 = pref.getString('mobile');
    getCheckout(get1);
    getCheckout2(get1);
    setState(() {
      Mobile = get1!;
      print("jcbgkgc dggeg fgcg===>>>----" + Mobile.toString());
    });
  }
}

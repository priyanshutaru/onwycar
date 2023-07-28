import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Apply_offer.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'AvailableCars.dart';
import 'DuplicateHomeScreen.dart';


class ChoosedCarInfo extends StatefulWidget {
   ChoosedCarInfo({required this.vehcile_img,
     required this.vehicle_name,
     required this.security_money,
     required this.tax,
     required this.totalRent,
     required this.delivery_charge,
     required this.C_latittude,
     required this.C_longitude,
     required this.self_location,
     required this.pickup_date,
     required this.pickup_time,
     required this.drop_date,
     required this.drop_time,
     required this.vehicle_id,
     required this.fix_km,
     required this.fuel_type,
     required this.CityId
   });
  String vehcile_img, vehicle_name, security_money, tax,
   totalRent, delivery_charge, C_latittude, C_longitude,
   self_location, pickup_date, pickup_time,
   drop_date, drop_time, vehicle_id,fix_km,fuel_type,CityId
   ;

  @override
  State<ChoosedCarInfo> createState() => _ChoosedCarInfoState();
}

class _ChoosedCarInfoState extends State<ChoosedCarInfo> {
 final _formKey2 = GlobalKey<FormState>();
 final _formKey1 = GlobalKey<FormState>();
 String car = 'car';
  TextEditingController address = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController pin = TextEditingController();
 TextEditingController house2 = TextEditingController();
 TextEditingController pin2 = TextEditingController();
 String? Clatitude;
 String? Clongitude;
 double latitude = 0.0;
 double longitude = 0.0;
 String? selectedValue;
 String location1 = 'Search Location......';
 String location2 = 'Search Location......';
 String googleApikey = "AIzaSyAxx2cI6NVwCr9udAWg4NrPxGiyiajQ9tg";
  String locality = '';
  String filledAddress = '';
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
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

  Future<void> GetAddressFromLatLong() async {
    Position position = await _getGeoLocationPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];

    setState(() {
      locality =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      /* LoginActivity();*/
      filledAddress= ' ${place.subLocality}, ${place.locality} ';
    });
    print(
        '${place.name} ${place.subAdministrativeArea} ${place.locality} ${place.subLocality}');
  }

  bool isChecked = false;
  bool isUnChecked = false;
  bool isSelectDrop=false;
  bool isSelfDrop=false;
  bool isConfirm1=false;
  bool isConfirm2=false;
  bool payOnline=true;
  bool payWallet=false;
  String Car="Car";
 String Sel="Sel";
 var user_wallet;
  @override
  void initState() {
    _getGeoLocationPosition();
    GetAddressFromLatLong();
    initializeRazorPay();
    getApplyoffer();
    totalAmount='${widget.totalRent}';
    delivery='${widget.delivery_charge}';
    print("user_wallet  fgcg===>>>----"+user_wallet.toString());
    print("totalAmount===>>>>>>>"+totalAmount);
    setState(() {
      _getValue();
      veh_img='${widget.vehcile_img}';
      Clatitude='${widget.C_latittude}';
      Clongitude='${widget.C_longitude}';
      print("location ----->>>>>>>"+Clatitude.toString()+"  "+Clongitude.toString());
      Secutity=(double.parse('${widget.security_money}'));
      tax=(double.parse('${widget.tax}'));
      Rent=(int.parse('${widget.totalRent}'));
      print("location 888**********>>>>"+location1);
    });
    //getAllCity();
    super.initState();
  }

 @override
  void dispose() {
   super.dispose();
   _razorpay.clear();
  }

  amount(){
    setState(() {
      TotalPayAm=Rent!+Secutity!+tax!+delivery_charge;
      Amount=TotalPayAm!-discountAmount;
      ampay=Amount!.toStringAsFixed(0);
      print("TotalPayAm===>>>>>>>"+ampay.toString());
    });
    return ampay.toString();
   }
 Future<List<ResponseUserRegister>>  getApplyoffer() async {
   var baseUrl = "https://onway.creditmywallet.in.net/api/apply_offer";
   http.Response response = await http.get(Uri.parse(baseUrl));
   if (response.statusCode == 200) {
     //var jsonData = json.decode(response.body)["response"];
     List data=json.decode(response.body)["response_userRegister"];
     print("bgfdhghfvgu==========>>>>>>"+data.toString());
     return data.map((data) => ResponseUserRegister.fromJson(data)).toList();
   }else{
     throw Exception('unexpected error occurred');
   }
 }
  late Razorpay _razorpay;
  void initializeRazorPay(){
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
 void launchRazorPay() async{
   final pref= await SharedPreferences.getInstance();
   var Mobile=pref.getString('mobile');
   final pref1= await SharedPreferences.getInstance();
   var name=pref1.getString('name');
   final pref2= await SharedPreferences.getInstance();
   var email=pref2.getString('email');
   var options = {
     //'key': 'rzp_test_mXi7bqjhaWun9u',
     'key':'rzp_test_Pe22ngHbsykkYL',
     //'secret key': 'yIvmDLU6vJEcSswwWi4kUa2h',
     'amount': num.parse(amount().toString())*100,
     'name': name.toString(),
     'description': 'Vehicle Booking',
     'prefill': {
        'contact': Mobile.toString(),
        'email': email.toString(),
     }
   };
    try{
      _razorpay.open(options);
    }catch(e){
      print("Error: $e");
    }
 }
 void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  print("Payment Sucessfull");
  print("${response.orderId} \n${response.paymentId} \n${response.signature}");
  setState(() {
    print("transection_Id==>>"+'${response.paymentId}');
    print("response1234*******>>"+response.toString());
  });
  var transection_Id='${response.paymentId}';
  if(response!="PaymentSuccessResponse"){
  }else{
    final pref= await SharedPreferences.getInstance();
    var Mobile=pref.getString('mobile');
    Map data={
      'mobile' : Mobile.toString(),
      'transection_id':transection_Id.toString(),
      'pickupdate' : widget.pickup_date.toString(),
      'pickuptime' : widget.pickup_time.toString(),
      'dropdate' : widget.drop_date.toString(),
      'droptime' : widget.drop_time.toString(),
      'city_id' : widget.CityId.toString(),
      'vehicle_id' : widget.vehicle_id.toString(),
      'fuel_type' : widget.fuel_type.toString(), // With fuel = 0, without fuel = 1
      'slot_km' : widget.fix_km.toString(),
      'base_rent' : totalAmount.toString(),
      'delivery_charge' : delivery_charge.toStringAsFixed(2),
      'coupon_id' : coupon_id.toString(),
      'pickup_add' : location1.toString(),
      'houseno': house.text.toString(),
      'postal_code': pin.text.toString(),
      'pickup_address2':widget.self_location.toString(),
      'houseno2':house2.text.toString(),
      'postal_code2':pin2.text.toString(),
      'drop_add' : location2.toString(),
      'drop_address2':widget.self_location.toString(),
      'payment_method' :car.toString(), // Wallet=1 /  Online=0
      'doorstep' : Car.toString(),
      'droplocation' : Sel.toString(),
    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/booking_pay_now");
    var body1= jsonEncode(data);
    var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: body1);
    if(response.statusCode==200){
      var res = await json.decode(response.body);
      String msg= res['status_message'].toString();
      setState(() {
        print("bjhgbvfjhdfgbfu====>..."+msg);
      });
      if(msg=='Success'){
        Fluttertoast.showToast(msg: 'Successfully',backgroundColor: Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DuplicateHome()));
      }else if(msg=='Low Wallet Balance'){
        Fluttertoast.showToast(msg: 'Low Wallet Balance');
      }else if(msg=='Error'){
        Fluttertoast.showToast(msg: 'Error........',textColor: Colors.red,);
      }else if(msg=='Something Went Wrong'){
        Fluttertoast.showToast(msg: 'Something Went Wrong',backgroundColor:Colors.redAccent);
      }
    }
  }
 }

 void _handlePaymentError(PaymentFailureResponse response) {
  print("Payment Failed");
  print("${response.code} \n${response.message}");
 }

 void _handleExternalWallet(ExternalWalletResponse response) {
   print("Payment Failed");
 }

 Future Book_Vehicle_Api()async{
    final pref= await SharedPreferences.getInstance();
    var Mobile=pref.getString('mobile');
   Map data={
   'mobile' : Mobile.toString(),
   'pickupdate' : widget.pickup_date.toString(),
   'pickuptime' : widget.pickup_time.toString(),
   'dropdate' : widget.drop_date.toString(),
   'droptime' : widget.drop_time.toString(),
   'city_id' : widget.CityId.toString(),
   'vehicle_id' : widget.vehicle_id.toString(),
   'fuel_type' : widget.fuel_type.toString(), // With fuel = 0, without fuel = 1
   'slot_km' : widget.fix_km.toString(),
   'base_rent' : totalAmount.toString(),
   'delivery_charge' : delivery_charge.toStringAsFixed(2),
   'coupon_id' : coupon_id.toString(),
   'pickup_add' : location1.toString(),
   'houseno': house.text.toString(),
   'postal_code': pin.text.toString(),
   'pickup_address2':widget.self_location.toString(),
   'houseno2':house2.text.toString(),
   'postal_code2':pin2.text.toString(),
   'drop_add' : location2.toString(),
   'drop_address2':widget.self_location.toString(),
   'payment_method' :car.toString(), // Wallet=1 /  Online=0
   'doorstep' : Car.toString(),
   'droplocation' : Sel.toString(),
   };
   Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/booking_pay_now");
   var body1= jsonEncode(data);
   var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: body1);
   if(response.statusCode==200){
     var res = await json.decode(response.body);
     String msg= res['status_message'].toString();
     print("bjhgbvfjhdfgbfu====>..."+msg);
     if(msg=='Success'){
       Fluttertoast.showToast(msg: 'Successfully',backgroundColor: Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DuplicateHome()));
     }else if(msg=='Low Wallet Balance'){
       Fluttertoast.showToast(msg: 'Low Wallet Balance');
     }else if(msg=='Error'){
       Fluttertoast.showToast(msg: 'Error........',textColor: Colors.red,);
     }else if(msg=='Something Went Wrong'){
       Fluttertoast.showToast(msg: 'Something Went Wrong',backgroundColor:Colors.redAccent);
     }
   }
 }

 int? discount;
 int? coupon;
 double discountAmount=0;
 double delivery_charge=0;
 double delivery_charge1=0;
 double delivery_charge2=0;
 double delivery_charge3=0;
 double delivery_charge4=0;
 double? Secutity;
 double?tax;
 int?Rent;
  var totalAmount,veh_img,delivery,coupon_id;
  double ?TotalPayAm;
  double ?Amount;
 String? ampay;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(foregroundColor:Colors.black ,
            backgroundColor: Colors.white,elevation: 0.5,

           /* leading: Container(
                child: Image.asset("assets/logo.png",height: 60,))*/
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("CheckOut Summary",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  veh_img.toString() == null? Container(
                      height: 150,
                      child: Image.asset("assets/maruti.png")
                  ):Container(
                      height: 150,
                      child: Image.network(veh_img.toString())
                  ),
                  SizedBox(height: 10,),
                  //Mercedes-Benz C-Class
                  '${widget.vehicle_name.toString()}'==null?Text("Car",
                    style: TextStyle(fontSize: 16,color: Colors.black54,fontWeight: FontWeight.bold),):
                  Text("${widget.vehicle_name.toString()}",
                    style: TextStyle(fontSize: 16,color: Colors.grey.shade600,fontWeight: FontWeight.bold),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text("  ................  ",style: TextStyle(fontSize: 30,color: Colors.grey),),
                      Icon(Icons.car_repair),
                      Text("  ...............",style: TextStyle(fontSize: 30,color: Colors.grey),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Booking Fees:",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w400),),
                        Spacer(),
                        Text("Rs",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700),),
                        SizedBox(width: 5,),
                        Text('${widget.totalRent.toString()}',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  //Avail Drop Location....
                  Padding(
                    padding:  EdgeInsets.only(left: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Avai DoorStep Delivery :',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  )),
                              Radio(
                                value: "location",
                                activeColor: Colors.green,
                                groupValue: Car,
                                onChanged: (value){
                                  setState(() {
                                    Car = value.toString();
                                    isChecked=!isChecked;
                                    isConfirm1=!isConfirm1;
                                    isUnChecked=false;
                                  });
                                },
                              ),
                              Text('Self Pickup Delivery: ',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  )),
                              /*Checkbox(
                                checkColor: Colors.white,
                                // fillColor:
                                // MaterialStateProperty.resolveWith(getColor),
                                activeColor: Colors.blue,
                                value: isUnChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isUnChecked = value!;
                                  });
                                },
                              ),*/
                              Radio(
                                value: "self",
                                activeColor: Colors.green,
                                groupValue: Car,
                                onChanged: (value){
                                  setState(() {
                                    Car = value.toString();
                                    isUnChecked=!isUnChecked;
                                    isChecked=false;

                                    delivery_charge=delivery_charge-delivery_charge1;
                                    delivery_charge1=0;
                                    print('delivery_charge========>>>>>>>>>>'+delivery_charge1.toString());
                                  });
                                },
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Visibility(
                      visible: isChecked,
                      child:
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(locality),
                                    Form(
                                      key: _formKey1,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1,color: Colors.black),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                var place = await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleApikey,
                                                    mode: Mode.fullscreen,
                                                    strictbounds: false,
                                                    components: [Component(Component.country, 'IN')],
                                                    onError: (err) {});
                                                if (place != null) {
                                                  setState(() {
                                                    location1 = place.description.toString();
                                                  });
                                                  final plist = GoogleMapsPlaces(
                                                    apiKey: googleApikey,
                                                  );
                                                  String placeid = place.placeId ?? "0";
                                                  final detail =
                                                  await plist.getDetailsByPlaceId(placeid);
                                                  final geometry = detail.result.geometry!;
                                                  latitude = geometry.location.lat;
                                                  longitude = geometry.location.lng;
                                                  var newlatlang = LatLng(latitude, longitude);
                                                  print("dsfjds " + newlatlang.toString());
                                                }
                                              },
                                              child:/* TextFormField(
                                                controller: address,
                                                decoration:const InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 3)
                                                    ),hintText: 'Type Address....',
                                                    contentPadding: EdgeInsets.all(10)
                                                ),
                                              ),*/
                                              ListTile(
                                                title: Text(
                                                  location1.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                dense: true,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 155,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: house,
                                                  decoration:const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3)
                                                      ),hintText: 'House no./float no./Building no.....',
                                                      contentPadding: EdgeInsets.all(10)
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter house no.....';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                width: 155,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: pin,
                                                  decoration:const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3)
                                                      ),hintText: 'Pincode....',
                                                      contentPadding: EdgeInsets.all(10)
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter pin code.....';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Visibility(
                                      visible: isConfirm1,
                                      child: Container(
                                          width: 350,
                                          height: 50,
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            color: Colors.black,
                                            highlightColor: Colors.lightGreen,
                                            onPressed: (){
                                            if (_formKey1.currentState!.validate()) {
                                              setState(() {
                                                isConfirm1=false;
                                                double distanceInMeters =
                                                Geolocator.distanceBetween(
                                                    double.parse(
                                                        Clatitude.toString()),
                                                    double.parse(
                                                        Clongitude.toString()),
                                                    latitude, longitude);
                                                //var value="1000";
                                                String distance = distanceInMeters
                                                    .toStringAsFixed(2);
                                                double km = (double.parse(
                                                    distance) / 1000);
                                                String km2 = km.toStringAsFixed(
                                                    2);
                                                delivery_charge1 =
                                                ((double.parse(km2)) * (int.parse(
                                                    delivery.toString())));
                                                delivery_charge=delivery_charge1+delivery_charge2;
                                                print(
                                                    'distanceInMeters========>>>>>>>>>>' +
                                                        km2.toString());
                                                print(
                                                    'delivery_charge========>>>>>>>>>>' +
                                                        delivery_charge
                                                            .toString());
                                              });
                                            }
                                            },
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(fontSize: 16,
                                                  fontWeight: FontWeight.w500,color: Colors.white),),)),
                                    ),

                                  ],
                                )),
                          )
                      )
                  ),
                  Visibility(
                      visible: isUnChecked,
                      child: Container(
                        decoration:const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: [
                            /*  Container(
                                   height: 150,width: MediaQuery.of(context).size.width,
                                   child: Card(child: Padding(
                                     padding: const EdgeInsets.all(10),
                                     child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text("Address:"+ filledAddress),
                                           Padding(
                                             padding: const EdgeInsets.only(top: 10,bottom: 10),
                                             child: Text("House Number: ${house.text}"),
                                           ),Text("Pincode: ${pin.text}")
                                         ],
                                       ),
                                   ),
                                   ),
                                 )*/
                            Container(
                                height:50,
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Colors.black),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text('${widget.self_location}',style: TextStyle(fontSize: 15,color: Colors.black54),)
                            )
                          ],
                        ),
                      )
                  ),
                  //Select Drop Location......
                  Padding(
                    padding:  EdgeInsets.only(left: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('Select Drop Location :',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  )),
                              Radio(
                                value: "location",
                                activeColor: Colors.green,
                                groupValue: Sel,
                                onChanged: (value){
                                  setState(() {
                                    Sel = value.toString();
                                    isSelectDrop=!isSelectDrop;
                                    isConfirm2=true;
                                    isSelfDrop=false;
                                  });
                                },
                              ),
                              const Text('Self Drop Delivery: ',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  )),
                              Radio(
                                value: "self",
                                activeColor: Colors.green,
                                groupValue: Sel,
                                onChanged: (value){
                                  setState(() {
                                    Sel = value.toString();
                                    isSelfDrop=!isSelfDrop;
                                    isSelectDrop=false;

                                    delivery_charge=delivery_charge-delivery_charge2;
                                    delivery_charge2=0;
                                    print('delivery_charge========>>>>>>>>>>'+delivery_charge.toString());
                                  });
                                },
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Visibility(
                      visible: isSelectDrop,
                      child: Container(
                          decoration:const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(locality),
                                    Form(
                                      key: _formKey2,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1,color: Colors.black),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                var place = await PlacesAutocomplete.show(
                                                    context: context,
                                                    apiKey: googleApikey,
                                                    mode: Mode.fullscreen,
                                                    strictbounds: false,
                                                    components: [Component(Component.country, 'IN')],
                                                    onError: (err) {});
                                                if (place != null) {
                                                  setState(() {
                                                    location2 = place.description.toString();
                                                  });
                                                  final plist = GoogleMapsPlaces(
                                                    apiKey: googleApikey,
                                                  );
                                                  String placeid = place.placeId ?? "0";
                                                  final detail =
                                                  await plist.getDetailsByPlaceId(placeid);
                                                  final geometry = detail.result.geometry!;
                                                  latitude = geometry.location.lat;
                                                  longitude = geometry.location.lng;
                                                  var newlatlang = LatLng(latitude, longitude);
                                                  print("Latlang===>> " + newlatlang.toString());
                                                }
                                              },
                                              child:/* TextFormField(
                                                controller: address,
                                                decoration:const InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 3)
                                                    ),hintText: 'Type Address....',
                                                    contentPadding: EdgeInsets.all(10)
                                                ),
                                              ),*/
                                              ListTile(
                                                title: Text(
                                                  location2.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                dense: true,
                                              ),
                                            ),
                                          ),
                                          /*TextFormField(
                                            controller: address,
                                            decoration:const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(width: 3)
                                                ),hintText: 'Type Address....',
                                                contentPadding: EdgeInsets.all(10)
                                            ),
                                          ),*/
                                          SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 155,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: house2,
                                                  decoration:const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3)
                                                      ),hintText: 'House no./float no./Building no.....',
                                                      contentPadding: EdgeInsets.all(10)
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter house no.....';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                width: 155,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: pin2,
                                                  decoration:const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3)
                                                      ),hintText: 'Pincode....',
                                                      contentPadding: EdgeInsets.all(10)
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter house no.....';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Visibility(
                                      visible: isConfirm2,
                                      child: Container(
                                          width: 350,
                                          height: 50,
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            color: Colors.black,
                                            highlightColor: Colors.lightGreen,
                                            onPressed: (){
                                              if (_formKey2.currentState!.validate()) {
                                                setState(() {
                                                  isConfirm2 = !isConfirm2;
                                                  double distanceInMeters =
                                                  Geolocator.distanceBetween( double.parse(Clatitude.toString()),
                                                      double.parse(Clongitude.toString()), latitude, longitude);
                                                  //var value="1000";
                                                  String distance = distanceInMeters.toString();
                                                  double km = (double.parse( distance) / 1000);
                                                  String km2 = km.toString();
                                                  delivery_charge2 = ((double.parse(km2)) * (int.parse(delivery.toString())));
                                                  delivery_charge =delivery_charge2 +delivery_charge1;
                                                  print(
                                                      'distanceInMeters========>>>>>>>>>>' +km2.toString());
                                                  print(
                                                      'delivery_charge========>>>>>>>>>>' +delivery_charge.toString());
                                                });
                                              }
                                            },
                                            child: Text("Confirm",
                                              style: TextStyle(fontSize: 16,
                                                  fontWeight: FontWeight.w500,color: Colors.white),),)),
                                    ),

                                  ],
                                )),
                          ))),
                  Visibility(
                      visible: isSelfDrop,
                      child: Container(
                        decoration:const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: [
                            Container(
                                height:50,
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color: Colors.black),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Text('${widget.self_location}',style: TextStyle(fontSize: 15,color: Colors.black54),)
                            )
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children:const [
                        Text('( Extra Charges )',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w700
                            )),
                      ],
                    ),
                  ),

                  const   SizedBox(height: 20,),
                  const  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 40,
                        child: Image.asset("assets/discount.png"),
                      ),
                      const Text("View Offers:",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.black),),
                      // Text("Rs- 0.00 OFF",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.black),),

                      MaterialButton(
                        highlightColor: Colors.red,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        hoverColor: Colors.red,
                        onPressed: (){
                          dilog();
                        },
                        child:const  Text("Check Offer now",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.white),),)
                    ],
                  ),
                  const  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Text("Total Rent",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs "+'${widget.totalRent}',style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                      ],
                    ),
                  ),
                  const  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Security Money",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs "+"${widget.security_money}",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                      ],
                    ),
                  ),
                  const  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  /* Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const [
                        Text("Total Rent",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs 600",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs "+double.parse("${widget.tax}").toStringAsFixed(0),style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        discountAmount!=null? Text("Rs "+(discountAmount).toStringAsFixed(0),
                          style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),):
                        Text("Rs 0.00",
                          style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivary Charge",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        delivery_charge==null?
                        Text("Rs 0.00",
                          style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),):
                        Text("Rs "+(delivery_charge).toStringAsFixed(0),
                          style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),)
                      ],
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Payable Amount",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.black87)),
                        Text("Rs "+amount().toString(),style:TextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: Colors.black87),),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    thickness: 1,
                    color: Colors.black45
                    ,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Payment Method",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.black87)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Radio(
                        activeColor: Colors.green,
                        value:"0",
                        groupValue: car,
                        onChanged: (value) {
                          setState(() {
                            payOnline=true;
                            payWallet=false;
                            car = value.toString();
                            print("Online/UPI/Card=======>>"+car.toString());
                          });
                        },
                      ),
                      Container(
                        height: 20,
                        child:Text("Online/UPI/Card",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),) ,
                      ),SizedBox(width: 10,),
                       (int.parse(user_wallet.toString()))>=(double.parse(amount().toString()))?
                         Radio(
                           // title: Text("Bikes"),
                           activeColor: Colors.green,
                           value: "1",
                           groupValue: car,
                           onChanged: (value) {
                             setState(() {
                               payWallet=!payWallet;
                               payOnline=false;
                               car = value.toString();
                               print("Wallet/UPI/Card=======>>"+car.toString());
                             });
                           },
                         ): Radio(
                         // title: Text("Bikes"),
                         activeColor: Colors.green,
                         value: "1",
                         groupValue: car,
                         onChanged: (value) {
                           setState(() {
                             // payWallet=!payWallet;
                             // payOnline=false;
                             //car = value.toString();
                             print("Wallet/UPI/Card=======>>"+car.toString());
                           });
                         },
                       ),
                      (int.parse(user_wallet.toString()))>=(double.parse(amount().toString()))?
                      Container(
                        height: 20,
                        child:Row(
                          children: [
                            Text("Wallet",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                            SizedBox(width: 7,),
                            Text("₹ "+user_wallet.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.green),),
                          ],
                        ),
                      ): Container(
                        height: 20,
                        child:Row(
                          children: [
                            Text("Wallet",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black38),),
                            SizedBox(width: 7,),
                            Text("₹ "+user_wallet.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.redAccent),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Visibility(
                    visible: payOnline,
                    child: Container(
                      width:MediaQuery.of(context).size.width,
                      child:   MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        highlightColor: Colors.green,
                        color: Colors.green,
                        onPressed: (){
                        if (Car=="location" && Sel=="location" || Car=="location" &&  Sel=="self" || Car=="self" &&  Sel=="self" || Car=="self" &&  Sel=="location") {
                            launchRazorPay();
                          }else{
                          Fluttertoast.showToast(msg: 'Please fill all filds...',gravity: ToastGravity.CENTER,backgroundColor: Colors.red);
                        }
                        },
                        child:  Text("Pay Now",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.white),),),
                    ),
                  ),
                  Visibility(
                    visible: payWallet,
                    child: Container(
                      width:MediaQuery.of(context).size.width,
                      child:   MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        highlightColor: Colors.green,
                        color: Colors.green,
                        onPressed: (){
                        setState(() {
                          String amount1=amount().toString();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return  AlertDialog(
                                title: Text("Booking Wallet Amount",style: TextStyle(color: Colors.green),),
                                content: Text("Amount = "+amount1.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                actions: <Widget>[
                                  MaterialButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  MaterialButton(
                                    child: Text("Yes"),
                                    onPressed: () async{
                                      Book_Vehicle_Api();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        });

                        },
                        child:  Text("Pay Now",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.white),),),
                    ),
                  ),
                  SizedBox(height: 70,),
                ],
              ),
            ),

          )
      ),
    );
  }
  void SelectAddress() {
    showModalBottomSheet(isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (BuildContext context, State) {
                  return Container(
                  margin:  MediaQuery.of(context).viewInsets,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(
                            thickness: 5,
                            indent: 160,
                            endIndent: 160,
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Add New Delivery Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Container(  decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                              child: TextFormField(decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.zero,
                                hintText: "Landmark / Block / Building"
                              ),),
                            ),
                          ),

                          Padding(
                            padding: const  EdgeInsets.symmetric(horizontal: 18.0),
                            child: Container( height: 40, decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                              child: Center(child: Text(filledAddress)),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Color(0xff73c803)),onPressed: (){
                              Navigator.pop(context);
                            },child: Text('Save Address'),),
                          )
                     ,  SizedBox(height: 40,)
                        ],
                      ),
                    ),
                  );
                });
              });
        });

  }
  Widget tet(){
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
      ),
    );
  }
     dilog() async {
    return  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Apply Offer Code",textAlign: TextAlign.center,),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Divider(
                      thickness: 4,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: FutureBuilder<List<ResponseUserRegister>>(
                          future: getApplyoffer(),
                          builder:(context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<ResponseUserRegister>? data=snapshot.data;
                              return  ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  height:35,
                                                  //width: 150,
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.lightGreen,),
                                                  child: Center(child: Text(data[index].couponDescription.toString(),style: TextStyle(color: Colors.white),))
                                              ),
                                              TextButton(onPressed: (){
                                                var couponAmount=data[index].couponAmount.toString();
                                                   coupon = int.parse(couponAmount);
                                                   var value="100";
                                                  setState(() {
                                                    coupon_id=data[index].couponId.toString();
                                                    discount = ((int.parse(totalAmount))*(int.parse(couponAmount)));
                                                     discountAmount=((int.parse(discount.toString()))/(int.parse(value)));
                                                    print("discount Amount @@@@=====>>>>"+discountAmount.toString());
                                                  });
                                                Navigator.of(context).pop();
                                              },
                                                  child: Text("Apply Offer",style: TextStyle(fontSize: 16,color: Colors.blue),))
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }
                          }
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
 _getValue() async{
   final pref=await SharedPreferences.getInstance();
   String? get2=pref.getString('user_wallet');
   setState(() {
     user_wallet=get2!;
   });
 }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/get_ex_offer.dart';
import '../HomePageRelatedScreens/DuplicateHomeScreen.dart';
class Extract extends StatefulWidget {
   Extract({required this.vehicleImage,
     required this.picDate,
     required this.picTime,
     required this.vehiclename,
   required this.totalAmount,
     required this.booking_id,
     required this.slot_km,
     required this.tax
   }) ;
  String vehiclename,
  picDate,
  picTime,
  vehicleImage,
   totalAmount,booking_id,slot_km,tax;

  @override
  State<Extract> createState() => _ExtractState();
}

class _ExtractState extends State<Extract> {
  static DateTime date = DateTime.now();
  static var DropDate="Drop Date";
  static var DropTime="Drop Time";
  String car = 'car';
  bool payOnline=true;
  bool payWallet=false;
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
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
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        DropTime=' ${_time.format(context)}';
      });
    }
  }

  Future<List<ResponseUserRegister>>  get_ex_offer() async {
    final pref=await SharedPreferences.getInstance();
    String? Mobile=pref.getString('mobile');
    Map data1={
      'user_mobile':Mobile.toString(),
    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/get_ex_offer");
    var body1= jsonEncode(data1);
    var response=await http.post(url,headers: {"Content-Type":"application/json"},body: body1);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data=json.decode(response.body)["response_userRegister"];
      /* booking_id=data[0]['booking_id'];
       print("slot data====>>>>>"+booking_id);*/
      return data.map((data) => ResponseUserRegister.fromJson(data)).toList();
    }else{
      throw Exception('unexpected error occurred');
    }
  }

  Future Extract_Vehicle_Api()async{
    final pref= await SharedPreferences.getInstance();
    var Mobile=pref.getString('mobile');
    Map data={
    'mobile': Mobile.toString(),
    'booking_id': widget.booking_id.toString(),
    'pickup_date': widget.picDate.toString(),
    'pickup_time': widget.picTime.toString(),
    'drop_date': DropDate.toString(),
    'drop_time': DropTime.toString(),
    'coupon_id': coupon_id.toString(),
    'slot': widget.slot_km.toString(),
    'base_rent': totalamount.toString(),
    'tax': widget.tax.toString(),
    'total': amount().toString(),
    'transection_id': '',
    'payment_method': car.toString(),
    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/extend_bookings");
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
      'description': 'Extend Booking',
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
    print(
        "${response.orderId} \n${response.paymentId} \n${response.signature}");
    setState(() {});
    var transection_Id = '${response.paymentId}';
    if (response != "PaymentSuccessResponse") {}
    else {
      final pref = await SharedPreferences.getInstance();
      var Mobile = pref.getString('mobile');
      Map data={
        'mobile': Mobile.toString(),
        'booking_id': widget.booking_id.toString(),
        'pickup_date': widget.picDate.toString(),
        'pickup_time': widget.picTime.toString(),
        'drop_date': DropDate.toString(),
        'drop_time': DropTime.toString(),
        'coupon_id': coupon_id.toString(),
        'slot': widget.slot_km.toString(),
        'base_rent': totalamount.toString(),
        'tax': widget.tax.toString(),
        'total': amount().toString(),
        'transection_id':transection_Id.toString(),
        'payment_method': car.toString(),
      };
      Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/extend_bookings");
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
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed");
    print("${response.code} \n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
  }
  @override
  void initState() {
    super.initState();
    initializeRazorPay();
    setState(() {
      _getValue();
      get_ex_offer();
      totalamount='${widget.totalAmount.toString()}';
      Rent=(int.parse('${totalamount.toString()}'));
      Tax=(double.parse('${widget.tax}'));
    });
  }
  @override
  void dispose() {
    super.dispose();
    //_razorpay.clear();
  }
  amount(){
    setState(() {
      TotalPayAm=(Rent!+Tax!);
      Amount=TotalPayAm!-discountAmount;
      ampay=Amount!.toStringAsFixed(0);
      print("TotalPayAm===>>>>>>>"+ampay.toString());
    });
    return ampay.toString();
  }
   int?Rent;
    double?Tax;
   double ?TotalPayAm;
  double ?Amount;
  String? ampay;
  var coupon_id,totalamount;
  int? discount;
  int? coupon;
  double discountAmount=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor:Colors.black ,
        backgroundColor: Colors.white,elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10,),
                widget.vehicleImage.toString() == null? Container(
                    height: 150,
                    child: Image.asset("assets/maruti.png")
                ):Container(
                    height: 150,
                    child: Image.network(widget.vehicleImage.toString())
                ),
                SizedBox(height: 10,),
                //Mercedes-Benz C-Class
                '${widget.vehiclename.toString()}'==null?Text("Car",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),):
                Text("${widget.vehiclename.toString()}",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("  ................  ",style: TextStyle(fontSize: 30),),
                    Icon(Icons.car_repair),
                    Text("  ...............",style: TextStyle(fontSize: 30),),
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
                      Text(totalamount.toString(),style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700),),
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
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Pick Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text("Pick Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.green,width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range,color: Colors.green,size: 30,),
                          SizedBox(width: 15,),
                          Text(widget.picDate,style: TextStyle(fontSize: 15),)
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width/2.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.green,width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.timer_outlined,color: Colors.green,size: 30,),
                          SizedBox(width: 15,),
                          Text(widget.picTime,style: TextStyle(fontSize: 15),)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Drop Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    Text("Drop Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.green,width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.date_range,color: Colors.green,size: 30,),
                          MaterialButton(
                            minWidth: MediaQuery.of(context).size.width/3.5,
                            height: 40,
                            child: Text(DropDate),
                            onPressed: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
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
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  setState(() {
                                    date = selectedDate;
                                    DropDate = DateFormat('d-MM-yyyy').format(selectedDate);
                                  });
                                }
                              }
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 45,
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width/2.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.green,width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.timer_outlined,color: Colors.green,size: 30,),
                          MaterialButton(
                            onPressed: _selectTime,
                            child: Text(DropTime),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
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
                    children:[
                      Text("Total Rent",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                      Text("Rs "+totalamount.toString(),style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
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
                  padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tax",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                     // Text("Rs "+double.parse("${widget.tax}").toStringAsFixed(0),style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
                      Text("Rs "+double.parse('${widget.tax.toString()}').toStringAsFixed(0),style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),

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
                      Text("Rs "+discountAmount.toStringAsFixed(0),
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
                    children:[
                      Text("Total",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                      Text("Rs "+amount().toString(),style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
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
                          Text("₹ "+"00",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.redAccent),),
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
                        // if (Car=="location" && Sel=="location" || Car=="location" &&  Sel=="self" || Car=="self" &&  Sel=="self" || Car=="self" &&  Sel=="location") {
                        //  // launchRazorPay();
                        // }else{
                        //   Fluttertoast.showToast(msg: 'Please fill all filds...',gravity: ToastGravity.CENTER,backgroundColor: Colors.red);
                        // }
                        launchRazorPay();
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
                              title: Text("Extend Wallet Amount",style: TextStyle(color: Colors.green),),
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
                                    Extract_Vehicle_Api();
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
        ),
      ),
    );
  }
  var user_wallet;
  _getValue() async{
    final pref=await SharedPreferences.getInstance();
    String? get2=pref.getString('user_wallet');
    setState(() {
      user_wallet=get2!;
    });
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
                        future: get_ex_offer(),
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
                                                discount = ((int.parse(totalamount))*(int.parse(couponAmount)));
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
}

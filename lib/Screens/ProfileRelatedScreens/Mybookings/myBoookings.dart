import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../model/transactionHistory.dart';

class MyBookings extends StatefulWidget {
  String booking_id;
  MyBookings({required this.booking_id});
  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {


  /*Future<List<ResponseUserRegister1>>  getMyBookingHistory() async {
    Map data1={
      'booking_id':'15',
    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/my_booking_history");
    var body1= jsonEncode(data1);
    var response=await http.post(url,headers: {"Content-Type":"application/json"},body: body1);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data=json.decode(response.body)["response_userRegister"];

      return data.map((data) => ResponseUserRegister1.fromJson(data)).toList();
    }else{
      throw Exception('unexpected error occurred');
    }
  }*/
  var image,vehilce_no,fuel,
      model,booking_status,
      total_km,total_hrs,
      pickup_date,pickup_time,
      drop_date,drop_time,booking_date_time,
      payment_method,payment_status,
      transection_id,start_meter_reading,
      end_meter_reading,booking_rent,
      security_money,delivery_charge,vehilcle_extension,tax,discount,total;
  Future getMyBookingHistory() async{
    Map data={
      'booking_id':widget.booking_id.toString(),
    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/my_booking_history");
    var body1= jsonEncode(data);
    var response=await http.post(url,headers: {"Content-Type":"Application/json"},body: body1);
    var res = await json.decode(response.body);
     var res1=res['response_userRegister'];
    print("ghujdsgfyugfu====>>>>>"+res.toString());
    setState(() {
     image=res1['image'];
     vehilce_no=res1['vehilce_no'];
     fuel=res1['fuel'];
     model=res1['model'];
     booking_status=res1['booking_status'];
     total_km=res1['total_km'];
     total_hrs=res1['total_hrs'];
     pickup_date=res1['pickup_date'];
     pickup_time=res1['pickup_time'];
     drop_date=res1['drop_date'];
     drop_time=res1['drop_time'];
     booking_date_time=res1['booking_date_time'];
     payment_method=res1['payment_method'];
     payment_status=res1['payment_status'];
     transection_id=res1['transection_id'];
     start_meter_reading=res1['start_meter_reading'];
     end_meter_reading=res1['end_meter_reading'];
     booking_rent=res1['booking_rent'];
     security_money=res1['security_money'];
     delivery_charge=res1['delivery_charge'];
     vehilcle_extension=res1['vehilcle_extension'];
     tax=res1['tax'];
     discount=res1['discount'];
     total=res1['total'];
    });
    print("hdfgvyu image===>>"+vehilce_no);
    if(response.statusCode==200){
    }
  }

  @override
  void initState() {
    super.initState();
    getMyBookingHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      elevation: 0.5,
      title: Text('Booking History'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    body: ListView.builder(
          itemCount:1,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  IntrinsicHeight (
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      image.toString().isEmpty? Container(
                          height: 120,
                          width: 120,
                          child: Image.asset('assets/car.jpg'),
                        ):Container(
                        height: 120,
                        width: 120,
                        child: Image.network(image.toString()),
                      ),
                        VerticalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
                            Text(vehilce_no.toString()),
                            Text(model.toString()),
                            Text('Fuel:'+fuel.toString()),
                            Text(total_km.toString()+'Km ,'+total_hrs.toString()+'hrs'),
                          ],),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking Status'),
                      booking_status=="0"?Text('Pending ',style: TextStyle(color: Colors.yellow.shade900),):
                          booking_status=="1"?Text('Booked',style: TextStyle(color: Colors.green),):
                          booking_status=="2"?Text('On Going ',style: TextStyle(color: Colors.green),):
                          booking_status=="3"?Text('End Ride',style: TextStyle(color: Colors.green),):
                          booking_status=="4"?Text('Cancelled by User',style: TextStyle(color: Colors.red),):
                          booking_status=="5"?Text('Finished(Cancel) by vendor ',style: TextStyle(color: Colors.red),):
                          booking_status=="6"?Text('Cancelled by admin',style: TextStyle(color: Colors.red),):
                          booking_status=="7"?Text('Extended',style: TextStyle(color: Colors.green),):
                          Text('Cancel',style: TextStyle(color: Colors.red),),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pickup Date and Time'),
                      Text(pickup_date.toString()+"  "+ pickup_time.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Drop Date and Time'),
                      Text(drop_date.toString()+"  "+ drop_time.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking Date and Time'),
                      Text(booking_date_time.toString())
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method'),
                      Text(payment_method==null?"0":payment_method.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Status'),
                      Text(payment_status.toString(),style: TextStyle(color: Colors.green)),
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TranscationId'),
                      Text(transection_id.toString())
                    ],
                  ),  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start Meter Reading'),
                      start_meter_reading == null?Text("0"):
                      Text(start_meter_reading.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('End Meter reading'),
                      Text(end_meter_reading.toString())
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Security Money'),
                      Text('₹ '+security_money.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rent'),
                      Text('₹ '+booking_rent.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Charge '),
                      Text('₹ '+delivery_charge.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Extended Rent '),
                      Text('₹ '+vehilcle_extension.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax'),
                      Text('₹ '+tax.toString())
                    ],
                  ), SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount'),
                      Text('₹ '+discount.toString())
                    ],
                  ),
                  SizedBox(height: 5,),
                  Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('₹ '+total.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ), SizedBox(height: 5,),

                  Divider(thickness: 3,),
                ],
              ),
            );
          }),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/transactionHistory.dart';
class transactionHisory extends StatefulWidget {
  String user_id;
  transactionHisory({required this.user_id});

  @override
  State<transactionHisory> createState() => _transactionHisoryState();
}

class _transactionHisoryState extends State<transactionHisory> {

  Future<List<Response>>  getTransactionHis() async {
    Map data1={
      'user_id':'${widget.user_id}'.toString(),
     // 'user_id':'30',
    };
    Uri url=Uri.parse("https://onway.creditmywallet.in.net/api/transection_history");
    var body1= jsonEncode(data1);
    var response=await http.post(url,headers: {"Content-Type":"application/json"},body: body1);
    if (response.statusCode == 200) {
      //var jsonData = json.decode(response.body)["response"];
      List data=json.decode(response.body)["response"];
      /* booking_id=data[0]['booking_id'];
       print("slot data====>>>>>"+booking_id);*/
      return data.map((data) => Response.fromJson(data)).toList();
    }else{
      throw Exception('unexpected error occurred');
    }
  }

  @override
  void initState() {
    super.initState();
    getTransactionHis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,title: Text('Transaction History'),),

    body:  FutureBuilder<List<Response>>(
        future: getTransactionHis(),
        builder:(context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Response>? data=snapshot.data;
            return  Container(
              child: ListView.builder(
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:data!.length,
                  itemBuilder: (BuildContext,int index){
                    return Card(
                      child: Column(
                        children: [
                           Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    Expanded(
                                        child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data[index].description.toString()),
                                            Divider(),
                                            data[index].transectionID.toString()==null?Container():
                                            Text(data[index].transectionID.toString()),
                                            data[index].damageAmt.toString()=="0"? Container():
                                            Text(data[index].damageAmt.toString()),
                                            data[index].penalityAmt.toString()=="0"?Container():
                                            Text(data[index].penalityAmt.toString()),
                                            data[index].securityAmt.toString()=="0"?Container():
                                            Text(data[index].securityAmt.toString().toString()),
                                            data[index].createdAt.toString()==null?Container():
                                            Text(data[index].createdAt.toString()),
                                          ],)
                                       // Text(data[index].description.toString())
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      height: MediaQuery.of(context).size.width/4.5,
                                      child: Column(
                                        children: [
                                          SizedBox(height:3,),
                                          Text('+₹ '+data[index].paymentAmount.toString(),style: TextStyle(color: Colors.green),),
                                          SizedBox(height:3,),
                                          Text(data[index].paymentType.toString()),
                                          SizedBox(height:3,),
                                          data[index].paymentStatus.toString()=="0"?
                                          Text("Pending",style: TextStyle(color: Colors.yellow.shade900),):
                                          data[index].paymentStatus.toString()=="1"?
                                          Text("Processing",style: TextStyle(color: Colors.greenAccent),):
                                          data[index].paymentStatus.toString()=="2"?
                                          Text("success",style: TextStyle(color: Colors.green),):
                                          Text("Reject",style: TextStyle(color: Colors.red),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                         /* Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data[index].transectionID.toString()==null?Container():
                                  Text(data[index].transectionID.toString()),
                                  data[index].damageAmt==null? Container():
                                  Text(data[index].damageAmt.toString()),
                                  data[index].penalityAmt==null?Container():
                                  Text(data[index].penalityAmt.toString()),
                                  data[index].securityAmt==null?Container():
                                  Text(data[index].securityAmt.toString()),
                                  data[index].createdAt.toString()==null?Container():
                                  Text(data[index].createdAt.toString()),
                                ],)
                            ],
                          )*/
                        ],
                      ),
                    );
                  }),
            );

          } else {
            return  Center(child: CircularProgressIndicator());
          }
        }
    ),
    );
  }
}

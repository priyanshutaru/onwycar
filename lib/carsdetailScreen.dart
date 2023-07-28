import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onwycar/Screens/HomePageRelatedScreens/AvailableCars.dart';
import 'package:onwycar/carresult.dart';

import 'Screens/HomePageRelatedScreens/ChoosedCarInfo.dart';
class CarsDetailScreen extends StatefulWidget {
  const CarsDetailScreen({Key? key}) : super(key: key);

  @override
  State<CarsDetailScreen> createState() => _CarsDetailScreenState();
}

class _CarsDetailScreenState extends State<CarsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(

          child: InkWell(
            onTap: (){
             /* Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>
                      ChoosedCarInfo(vehcile_img: '',
                        vehicle_name: '',
                        security_money: '',
                        tax: '', totalRent: '',
                        delivery_charge: '', C_latittude: '', C_longitude: '', self_location: '',)));*/
            },
            child: Column(
              children: [

                ],
            ),
          ),
        ),
      ),
    );
  }

  Widget carsDetail(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          width: 350,
          child: Card(
            elevation: 10,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                     Container(
                       child: Image.asset("assets/maruti.png",height: 100,width: 150,),
                     ),
                      Container(
                        child: Column(
                          children: [
                            Text("Cars Name"),
                            Text("About Cars"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 140,
                //   child: Image.asset("assets/$img",fit: BoxFit.fill,height: 140,width: 200,),
                // ),
                // Divider(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: Row(
                //     children: [
                //       Icon(Icons.business_center_sharp),
                //
                //       Padding(
                //         padding: const EdgeInsets.only(left: 5,right: 5),
                //         child: Text(time),
                //       ),
                //       Icon(Icons.person,),
                //
                //       Padding(
                //         padding: const EdgeInsets.only(left: 5,right: 5),
                //         child: Icon(Icons.compare_arrows_outlined),
                //       ),
                //       Text(filter,style: TextStyle(fontWeight: FontWeight.w700),),
                //       Spacer(),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Row(
                //             children: [
                //               Icon(Icons.currency_rupee,size: 14,),
                //               Text(price,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),)
                //             ],
                //           ),
                //           Text("Total",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black54),),
                //         ],
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

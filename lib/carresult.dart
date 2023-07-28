import 'package:flutter/material.dart';
class CarsResult extends StatefulWidget {
  const CarsResult({Key? key}) : super(key: key);

  @override
  State<CarsResult> createState() => _CarsResultState();
}

class _CarsResultState extends State<CarsResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Booking Confirmed",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black)),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(onPressed: (){}, icon:Icon(Icons.home)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Compact Car",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                                    Text("Dodgi Neon or Similar",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),)
                                  ],
                                ),
                                Spacer(),
                                Container(
                                    height: 30,width: 80,
                                    child: Image.asset("assets/logo.png"))
                              ],
                            ),
                          ),
                          Container(
                            height: 140,
                            child: Image.asset("assets/car.jpg",fit: BoxFit.fill,height: 140,width: 200,),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(Icons.business_center_sharp),

                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                  child: Text("10"),
                                ),
                                Icon(Icons.person,),

                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                  child: Icon(Icons.compare_arrows_outlined),
                                ),
                                Text("Autometic",style: TextStyle(fontWeight: FontWeight.w700),),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.currency_rupee,size: 14,),
                                        Text("850",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),)
                                      ],
                                    ),
                                    Text("Total",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black54),),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 350,
                child: Card(
                  elevation: 5,

                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,left: 20,bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pick Up & Return",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.only(top: 18,bottom: 5),
                          child: Text("Pickup",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                        ),
                        Text("07 April 2021 - 10:00am",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black54),),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 5),
                          child: Text("Return",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black87),),
                        ),
                        Text("10 April 2021 - 10:00am",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

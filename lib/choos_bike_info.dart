import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onwycar/Screens/HomePageRelatedScreens/AvailableCars.dart';



class ChoosedBikeInfo extends StatefulWidget {
  const ChoosedBikeInfo({Key? key}) : super(key: key);

  @override
  State<ChoosedBikeInfo> createState() => _ChoosedCarInfoState();
}

class _ChoosedCarInfoState extends State<ChoosedBikeInfo> {
  final _formKey = GlobalKey();
  TextEditingController address = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController pin = TextEditingController();
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
      '${place.street}, ${place.subLocality}, ${place.locality},\n ${place.postalCode}, ${place.country}';
      /* LoginActivity();*/
      filledAddress= ' ${place.subLocality}, ${place.locality}  ';
    });
    print(
        '${place.name} ${place.subAdministrativeArea} ${place.locality} ${place.subLocality}');
  }

  bool isChecked = true;
  bool isUnChecked = true;
  @override
  void initState() {
    _getGeoLocationPosition();
    GetAddressFromLatLong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /*Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CarDetails()));*/
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//           floatingActionButton:    Column(
//       mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
// style: ElevatedButton.styleFrom(primary: Colors.green),
//               onPressed: () {
// /*                Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOut()));*/
//               },
//               child: Text('Pay ₹1200'),
//             ),
//           ),SizedBox(height: 60,)
//         ],
//       ),
          appBar: AppBar(foregroundColor:Colors.black ,
              backgroundColor: Colors.white,elevation: 0.5,

              leading: Container(
                height: 100,
                  width: 150,
                  child: Image.asset("assets/logo.png",height: 80,))
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("CheckOut Summary",style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                      height: 150,
                      child: Image.asset("assets/bike.png")),
                  SizedBox(height: 10,),

                  Text("Mercedes-Benz C-Class",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),

                  Row(
                    children: const[
                      Text("  ................  ",style: TextStyle(fontSize: 30),),
                      Icon(Icons.car_repair),
                      Text("  ...............",style: TextStyle(fontSize: 30),),
                    ],
                  ),
                  const
                  SizedBox(height: 15,),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Row(
                      children:const [
                        Text("Booking Fees:",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w400),),
                        Spacer(),
                        Text("Rs",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700),),
                        SizedBox(width: 5,),
                        Text("1160",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700),),
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
                    padding:  EdgeInsets.only(left: 5),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('Avai DoorStep Delivery :',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  )),
                              Checkbox(
                                checkColor: Colors.white,
                                // fillColor:
                                // MaterialStateProperty.resolveWith(getColor),
                                activeColor: Colors.blue,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                    // print(isChecked);

                                  });
                                },
                              ),
                              const Text('Self Pickup Delivery: ',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                  )),
                              Checkbox(
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
                              ),

                              // Text('₹ 99',
                              //     style: TextStyle(
                              //       fontSize: 18,
                              //     ))
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 5,),
                  Visibility(
                      visible: isChecked,
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
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: address,
                                            decoration:const InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(width: 3)
                                                ),hintText: 'Type Address....',
                                                contentPadding: EdgeInsets.all(10)
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 155,
                                                child: TextFormField(
                                                  controller: house,
                                                  decoration:const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3)
                                                      ),hintText: 'House no./float no./Building no.....',
                                                      contentPadding: EdgeInsets.all(10)
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 155,
                                                child: TextFormField(
                                                  controller: pin,
                                                  decoration:const InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3)
                                                      ),hintText: 'Pincode....',
                                                      contentPadding: EdgeInsets.all(10)
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Container(
                                        width: 350,
                                        height: 50,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          color: Colors.black,
                                          highlightColor: Colors.lightGreen,
                                          onPressed: (){},child: Text("Conform",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),)),

                                  ],
                                )),
                          ))),
                  Visibility(
                      visible: isUnChecked,
                      child: Container(
                        decoration:const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: [Container(
                            height: 150,width: MediaQuery.of(context).size.width,
                            child: Card(child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address: ${address.text}"),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                    child: Text("House Number: ${house.text}"),
                                  ),Text("Pincode: ${pin.text}")
                                ],
                              ),
                            ),
                            ),
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
                        color: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        hoverColor: Colors.red,
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  height: 132,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  child:  Column(
                                    children: [
                                      const
                                      Text("Apply Offer Code"),
                                      const   Divider(
                                        thickness: 4,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  height:30,width: 120,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.lightGreen,),
                                                  child:const Center(child: Text("Get 10% OFF",style: TextStyle(color: Colors.white),))),
                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();
                                              }, child:const Text("Apply Offer",style: TextStyle(fontSize: 16,color: Colors.blue),))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  height:30,width: 120,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.lightGreen,),
                                                  child:const Center(child: Text("Get 20% OFF",style: TextStyle(color: Colors.white),))),
                                              TextButton(onPressed: (){}, child:const Text("Apply Offer",style: TextStyle(fontSize: 16,color: Colors.blue),))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 88),
                                    child: Row(
                                      children: [
                                        MaterialButton(
                                          child: new Text("Yes"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        MaterialButton(
                                          child:  Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          );

                        },child:const  Text("Check Offer now",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.white),),)
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
                      children: const[
                        Text("Total Rent",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs 600",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
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
                      children:const [
                        Text("Security Money",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs 600",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black)),
                        Text("Rs 0.00",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
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
                        Text("Rs 0.00",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
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
                        Text("Total Payable Amount",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black)),
                        Text("Rs 2400",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    width: 350,

                    child:   MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      highlightColor: Colors.green,
                      color: Colors.black,
                      onPressed: (){},child:  Text("Pay Now",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.white),),),
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
}

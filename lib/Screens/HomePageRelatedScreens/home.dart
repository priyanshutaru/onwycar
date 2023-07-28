// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:onwycar/Screens/HomePageRelatedScreens/ChoosedCarInfo.dart';

import '../../HelperFunctions/helperfunctions.dart';
import 'AvailableCars.dart';

class Home extends StatefulWidget {
  const Home({Key? key,required this.CityId}) : super(key: key);
final String CityId;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String DemoTime = '8:00 AM';
  String? StartDate;
  String? EndDate;
  String Datee = '2022-03-28';
  TimeOfDay? _Starttime;
  TimeOfDay? _Endtime;
  TimeOfDay initialStartTime = TimeOfDay.now();
  TimeOfDay initialEndTime = TimeOfDay.now();

  DateTime currentStartDate = DateTime.now();
  DateTime currentEndDate = DateTime.now();

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
        StartDate='${currentStartDate.year}-${currentStartDate.month}-${currentStartDate.day}  ${_Starttime?.hour}:${_Starttime?.minute} ${_Starttime?.period.name.toUpperCase()}';
     /*print("StartDate"+StartDate.toString());*/
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
        EndDate='${currentEndDate.year}-${currentEndDate.month}-${currentEndDate.day}  ${_Endtime?.hour}:${_Endtime?.minute} ${_Endtime?.period.name.toUpperCase()}';
      });
    }
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
  bool? openDialogueBox;
  void openDialoguebox() async {

    print(openDialogueBox);
    if (openDialogueBox != true) {
      Future.delayed(Duration.zero, () {
      /*  _showMyDialog(context);*/
      });
    }

  }

  @override
  void initState() {
    openDialoguebox();
    _getGeoLocationPosition();
    _Starttime = TimeOfDay.now();
    _Endtime = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      title: Row(
        children: [
          Icon(FontAwesomeIcons.accusoft),SizedBox(width: 10,),
          Text(
            'Onway Car',
            style: GoogleFonts.lobster(fontSize: 25),
          ),
        ],
      ),centerTitle: true,),
      body:  Scaffold(
        body: Column(
          children: [

            BannerSlider(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Select Date & Time',
                        style: TextStyle(

                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Colors.black54, width: 0.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container( decoration: BoxDecoration(color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                       ),

                        width: 300,
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              /*key: formKey,*/
                              Column(
                                children: [
                                  Text(
                                    'Choose Start Date',
                                    style: TextStyle(

                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {

                                      _selectStartDate(context);
                                    },
                                    child: Container(
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white70,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                '${currentStartDate.day}/${currentStartDate.month}/${currentStartDate.year}  ${_Starttime?.hour}:${_Starttime?.minute} ${_Starttime?.period.name.toUpperCase()}'),
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Choose End Date',
                                    style: TextStyle(

                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {

                                      _selectEndtDate(context);
                                    },
                                    child: Container(
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white70,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1+0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                '${currentEndDate.day}/${currentEndDate.month}/${currentEndDate.year}  ${_Endtime?.hour}:${_Endtime?.minute} ${_Endtime?.period.name.toUpperCase()}'),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              ButtonTheme(
                                minWidth: 150.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 1)),
                                child: MaterialButton(
                                  elevation: 0.0,
                                  hoverColor: Colors.green,
                                  color: Colors.white,
                                  child: Text(
                                    "Search",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>CarDetails(CityId: widget.CityId,EndDate: EndDate.toString(),StartDate: StartDate.toString(),)));
                                  },
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              thickness: 1,
                              color: Colors.white,
                              indent: 30,
                              height: 36,
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                                thickness: 1,
                                color: Colors.white,
                                height: 36,
                                endIndent: 30)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class BannerSlider extends StatefulWidget {
  const BannerSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
         Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imgList[4]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //2nd Image of Slider
          Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imgList[3]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //3rd Image of Slider
          Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imgList[2]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //4th Image of Slider
          Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imgList[1]),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //5th Image of Slider
          Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imgList[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),


      ],
      options: CarouselOptions(
        enlargeCenterPage: true,
        height: 140.0,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1.0,
      ),
    );
  }
}

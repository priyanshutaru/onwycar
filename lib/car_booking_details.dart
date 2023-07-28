import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarBookingDetails extends StatefulWidget {
  const CarBookingDetails({Key? key}) : super(key: key);

  @override
  State<CarBookingDetails> createState() => _CarBookingDetailsState();
}

class _CarBookingDetailsState extends State<CarBookingDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration:const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[Colors.blue, Colors.green]))),
          title:const TabBar(
            labelPadding: EdgeInsets.only(left: 80, right: 80),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4,
                  color: Colors.white,
                ),
                insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Cars',
              ),
              Tab(
                text: 'PEDL',
              ),
            ],
          ),
        ),

        body:const TabBarView(
          children: <Widget>[
            Car(),
            Pedl(),
          ],
        ),
      ),
    );
  }
}

class Car extends StatefulWidget {
  const Car({Key? key}) : super(key: key);

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext, int index) {
          return CardWidget();
        });
  }

  Widget CardWidget() {
    return Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('My Booking',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20,),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text('Booking Status',
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children:const [
                        Text(
                          'Id:JPS62WIHW',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 15,),
                        Icon(Icons.arrow_forward_ios,size: 20,)
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height:80,
                          child: Image.asset(
                            'assets/car.jpg',
                            scale: 4,
                          ),
                        ),
                        const Text('Tata Tiago'),
                        const Text(
                          'UP 32 AA 1684',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        )
                      ],
                    ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children:const [
                            Icon(
                              CupertinoIcons.largecircle_fill_circle,
                              color: Colors.red,
                            ),
                            Text('--------------------------------'),
                            Icon(
                              CupertinoIcons.largecircle_fill_circle,
                              color: Colors.lightGreen,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:const [
                            Text('Start',
                                style: TextStyle(
                                  color: Colors.black54,
                                )),
                            SizedBox(width: 120,),
                            Text('End',
                                style: TextStyle(
                                  color: Colors.black54,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:const [
                            Text(
                              '9 Aug',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              '9 Aug',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:const [
                            Text(
                              '7 AM',
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              '11 AM',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              height: 20,
                              child: Text(
                                'Sector-12,Gomti Nagar, Lucknow',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text('Refund of 700 initiated',
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class Pedl extends StatefulWidget {
  const Pedl({Key? key}) : super(key: key);

  @override
  State<Pedl> createState() => _PedlState();
}

class _PedlState extends State<Pedl> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

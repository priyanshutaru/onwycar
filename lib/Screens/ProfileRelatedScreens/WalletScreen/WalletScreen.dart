import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({required this.user_id, required this.user_wallet});
  String user_id, user_wallet;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController addMoney = TextEditingController();
  late Razorpay _razorpay;
  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void launchRazorPay() async {
    final pref = await SharedPreferences.getInstance();
    var Mobile = pref.getString('mobile');
    final pref1 = await SharedPreferences.getInstance();
    var name = pref1.getString('name');
    final pref2 = await SharedPreferences.getInstance();
    var email = pref2.getString('email');

    int amountTopay = int.parse(addMoney.text) * 100;
    var options = {
      'key': 'rzp_test_mXi7bqjhaWun9u',
      'amount': "$amountTopay",
      'name': name.toString(),
      'description': 'Add Money Your Wallet',
      'prefill': {
        'contact': Mobile.toString(),
        'email': email.toString(),
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Sucessfull");
    print(
        "${response.orderId} \n${response.paymentId} \n${response.signature}");
    setState(() {});
    var transection_Id = '${response.paymentId}';
    if (response == "PaymentSuccessResponse") {
    } else {
      final pref = await SharedPreferences.getInstance();
      var Mobile = pref.getString('mobile');
      var dio = Dio();
      var formData = FormData.fromMap({
        'user_id': '${widget.user_id}'.toString(),
        'mobile': Mobile.toString(),
        'recharge_amt': addMoney.text.toString(),
        'transection_id': transection_Id.toString(),
        'amount': addMoney.text.toString(),
        'entity': '5',
        'status': '3',
        'contact': '125',
        'fee': '100',
      });
      var response = await dio
          .post('https://bitacars.com/api/add_money_in_wallet', data: formData);
      print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
      print("response ====>>>" + response.toString());
      var res = response.data;
      String msg = res['status_message'];
      print("bjhgbvfjhdfgbfu====>..." + msg);
      if (msg == 'Success') {
        Fluttertoast.showToast(
            msg: 'Add Money Successfully', gravity: ToastGravity.CENTER);
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

  Future WithdrawApi() async {
    final pref = await SharedPreferences.getInstance();
    var Mobile = pref.getString('mobile');
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': '${widget.user_id}'.toString(),
      'mobile': Mobile.toString(),
      'withdraw_amount': addMoney.text.toString(),
    });
    var response = await dio.post('https://bitacars.com/api/withdraw_money',
        data: formData);
    print(formData.toString() + "^^^^^^^^^^^^^^^^^^^");
    print("response ====>>>" + response.toString());
    var res = response.data;
    String msg = res['status_message'];
    print("bjhgbvfjhdfgbfu====>..." + msg);
    if (msg == 'Success') {
      Fluttertoast.showToast(
          msg: 'Withdraw Money Successfully', gravity: ToastGravity.CENTER);
      setState(() {});
      addMoney.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeRazorPay();
    setState(() {
      amountWallet1 = '${widget.user_wallet}';
    });
  }

  /*amountWallet(){
    setState(() {
      amountWallet1='${widget.user_wallet}';
    });
    return amountWallet1.toString();
  }*/
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  var amountWallet1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Money'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          Container(
            //height: 400,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.wallet),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Add Money in Your Wallet',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      /* Text(
                        'TopUp your wallet',
                        style: TextStyle(color: Colors.black54),
                      ),*/
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: addMoney,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: '₹ ',
                          hintStyle:
                              TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                addMoney.text = '10';
                                addMoney.selection = TextSelection.fromPosition(
                                    TextPosition(offset: addMoney.text.length));
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('+ ₹ 10'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addMoney.text = '100';
                              addMoney.selection = TextSelection.fromPosition(
                                  TextPosition(offset: addMoney.text.length));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('+ ₹ 100'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addMoney.text = '200';
                              addMoney.selection = TextSelection.fromPosition(
                                  TextPosition(offset: addMoney.text.length));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('+ ₹ 200'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addMoney.text = '300';
                              addMoney.selection = TextSelection.fromPosition(
                                  TextPosition(offset: addMoney.text.length));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('+ ₹ 300'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addMoney.text = '500';
                              addMoney.selection = TextSelection.fromPosition(
                                  TextPosition(offset: addMoney.text.length));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('+ ₹ 500'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/discount.png',
                            scale: 6,
                          ),

                          ElevatedButton(
                            style:
                            ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () {},
                            child: Text('Apply Coupan'),
                          )
                        ],
                      ),*/
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                amountWallet1 =
                                    (int.parse(widget.user_wallet.toString()) +
                                        (int.parse(addMoney.text.toString())));
                                launchRazorPay();
                              });
                            },
                            child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.2,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  // gradient: LinearGradient(colors: [Colors.green, Color(0xff64B6FF)]),
                                ),
                                child: const Text(
                                  'Add Money',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Are You Saure Withdraw Amount",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red),
                                    ),
                                    content: Text(
                                      "Amount = " + addMoney.text.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green),
                                    ),
                                    actions: <Widget>[
                                      MaterialButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      MaterialButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          setState(() {
                                            if ((int.parse(widget.user_wallet
                                                    .toString())) <=
                                                (double.parse(addMoney.text
                                                    .toString()))) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Not Found  Wallet Amount in Withdraw Amount',
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor: Colors.red);
                                            } else {
                                              amountWallet1 = (int.parse(widget
                                                      .user_wallet
                                                      .toString()) -
                                                  (int.parse(addMoney.text
                                                      .toString())));
                                              WithdrawApi();
                                            }
                                          });
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2.2,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  //gradient: LinearGradient(colors: [Colors.red, Color(0xff64B6FF)]),
                                ),
                                child: const Text(
                                  'Withdraw Money',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 110,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Available Balance',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (int.parse(widget.user_wallet.toString())) >= 0
                          ? Text(
                              '₹ ' + amountWallet1.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '₹ ' + "00",
                              style: TextStyle(
                                  color: Colors.redAccent.shade200,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/cash.png',
                    scale: 1.5,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';



class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId, this.totalAmount,}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  double totalAmount;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
             colors: [Color(0xFFFDBE3B), Color(0xFF5C4057)],
             begin: const FractionalOffset(0.0, 0.0),
             end: const FractionalOffset(1.0,0.0),
             stops: [0.0, 1.0],
             tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("images/cash.png"),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Color(0xFF5C4057),
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Color(0xFFFDBE3B),
                onPressed: ()=> addOrderDetails(), 
                child: Text("Place Order", style: TextStyle(fontSize: 30.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails()
  {
    saveOrderDetailsForUser({
       DropItApp.addressID: widget.addressId,
       DropItApp.totalAmount: widget.totalAmount,
       "orderBy": DropItApp.sharedPreferences.getString(DropItApp.userUID),
       DropItApp.productID: DropItApp.sharedPreferences.getStringList(DropItApp.userCartList),
       DropItApp.paymentDetails: "Cash On delivery",
       DropItApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
       DropItApp.isSuccess: true,
    });

    saveOrderDetailsForAdmin({
       DropItApp.addressID: widget.addressId,
       DropItApp.totalAmount: widget.totalAmount,
       "orderBy": DropItApp.sharedPreferences.getString(DropItApp.userUID),
       DropItApp.productID: DropItApp.sharedPreferences.getStringList(DropItApp.userCartList),
       DropItApp.paymentDetails: "Cash On delivery",
       DropItApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
       DropItApp.isSuccess: true,
    }).whenComplete(() => {
      emptyCart()
    });
   
  }

  emptyCart()
  {
    DropItApp.sharedPreferences.setStringList(DropItApp.userCartList, ["garbageValue"]);
    List tempList = DropItApp.sharedPreferences.getStringList(DropItApp.userCartList);

    FirebaseFirestore.instance.collection("users").doc(DropItApp.sharedPreferences.getString(DropItApp.userUID)).update({
     DropItApp.userCartList: tempList,
    }).then((value)
    {
      DropItApp.sharedPreferences.setStringList(DropItApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Congragulations Your Order has been placed successfully. ");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);
  }
  Future saveOrderDetailsForUser(Map<String,dynamic> data) async
  {
    await DropItApp.firestore.collection(DropItApp.collectionUser)
          .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID))
          .collection(DropItApp.collectionOrders)
          .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID) + data['orderTime']).set(data);
  }

  Future saveOrderDetailsForAdmin(Map<String,dynamic> data) async
  {
    await DropItApp.firestore
          .collection(DropItApp.collectionOrders)
          .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID) + data['orderTime']).set(data);
  }
}


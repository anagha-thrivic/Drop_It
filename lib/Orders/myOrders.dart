import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}



class _MyOrdersState extends State<MyOrders> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: ()
            {
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
             icon: Icon(Icons.arrow_back),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(0xFF5C4057), Color(0xFFFDBE3B)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0,0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          centerTitle: true,
          title: Text("My Orders",style: TextStyle(color: Color(0xFF5C4057)),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle,color:Color(0xFF5C4057),), 
              onPressed: ()
              {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: DropItApp.firestore
                  .collection(DropItApp.collectionUser)
                  .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID))
                  .collection(DropItApp.collectionOrders).snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
              ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (c, index) {
                  return FutureBuilder<QuerySnapshot>(
                     future: FirebaseFirestore.instance
                            .collection("items")
                            .where("shortInfo",whereIn: snapshot.data.docs[index].data()[DropItApp.productID])
                            .get(),
                     builder: (c , snap)
                     {
                       return snap.hasData 
                       ? OrderCard(
                         itemCount: snap.data.docs.length,
                         data: snap.data.docs,
                         orderID: snapshot.data.docs[index].id,
                       )
                       :Center(child: circularProgress(),);
                     },
                  );
                },     
               )
            : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}

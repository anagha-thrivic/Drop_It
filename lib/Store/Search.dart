import 'dart:js';

import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Widgets/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../Widgets/customAppBar.dart';

class SearchService {
}



class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}



class _SearchProductState extends State<SearchProduct> {
  String data="";
  @override
  Widget build(BuildContext context) {
  width = MediaQuery.of(context).size.width;
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
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(0xFFFDBE3B),Color(0xFF5C4057)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0,0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
         title: Text(
          "DROP IT",
          style: TextStyle(fontSize: 55.0, color:Colors.white, fontFamily: "Signatra" ),

         ),
          centerTitle: true,
          actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,color: Colors.pink,), 
                onPressed:()
                {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                },
                
             ),
             Positioned(
               child: Stack(
                 children: [
                   Icon(
                     Icons.brightness_1,
                     size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 4.0 ,
                      child: Consumer<CartItemCounter>(
                        builder: (context,counter, _)
                        {
                           return Text(
                             (DropItApp.sharedPreferences.getStringList(DropItApp.userCartList).length-1).toString(),
                              style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w500),
                           );
                        },
                      ),
                    ),
                  ],
               ),
              ),
            ],
          ),
         ],
         bottom: PreferredSize(
           preferredSize: Size(50,60),
           child: Container(
             width: 300,
              child :TextField(
                 decoration: InputDecoration(
                   prefixIcon: Icon(Icons.search),
                   hintText: ("Search"),
                   border: OutlineInputBorder(),
                 ),
                onChanged: (value)
                {
                 setState(() {
                   data= value;
                 });
                },
              ),
            ),
         ),
        ),
        body: buildResultCard(data),
      ),
    );
  }
}
  Widget buildResultCard(String data) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
              .collection("items")
              .where('shortInfo',isEqualTo: data)
              .snapshots(),
      builder: (context,snapshot)
      {
        if(!snapshot.hasData) return new Text("Loading..");
        return new ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index)=>
            _buildListItem(snapshot.data.documents[index]),
        );
      },
    );
  }
   Widget _buildListItem(DocumentSnapshot document){
     return new ListTile(
        title : document['title'],
     );
   }

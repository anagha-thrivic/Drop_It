import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Widgets/searchBox.dart';
import 'package:flutter/cupertino.dart';
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
  String query;
  TextEditingController _searchController = TextEditingController();

  
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
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget> [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: TextField(
                        onChanged:(val){
                          setState(() {
                            query = val;
                          });
                        },
                        controller: _searchController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed:() => _searchController.clear()
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search here",
                          hintStyle: TextStyle(
                            fontFamily: 'Signatra', color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (query == null || query.trim() == '')
                       ? FirebaseFirestore.instance.collection("items").snapshots()
                       : FirebaseFirestore.instance.collection("items").where("shortInfo", isGreaterThanOrEqualTo: query).snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.hasError){
                          return Text("we got an error ${snapshot.error}");
                        }
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting:
                           return SizedBox(
                             child: Center(
                               child: circularProgress()
                             ),
                           );
                          case ConnectionState.none:
                            return Text("No data");
                          case ConnectionState.done:
                            return Text("Done");
                          default:
                           return new ListView.builder(
                             itemCount: snapshot.data.docs.length,
                             itemBuilder: (c,index){
                               ItemModel model= ItemModel.fromJson(snapshot.data.docs[index].data());
                                return sourceInfo(model, context);
                             },
                           );
                        }
                      },
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background})
{
  width =  MediaQuery.of(context).size.width;

  return  Container(
     color: Colors.grey[100],
     height: 170.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 180.0,),
            SizedBox(width: 10.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title,style: TextStyle(color: Colors.black, fontSize: 14.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo,style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:20.0,),
                  Row(
                    children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: EdgeInsets.only(top: 5.0),
                           child: Row(
                             children: [
                               Text(
                                 r"Total Price: ",
                                 style: TextStyle(
                                   fontSize: 14.0,
                                   color: Color(0xFF5C4057),
                                 ),
                               ),
                               Text(
                                 "₹ ",
                                 style: TextStyle(color:Color(0xFFFDBE3B),fontSize: 16.0),
                                ),
                               Text(
                                 (model.price).toString(),
                                 style: TextStyle(
                                   fontSize: 15.0,
                                   color: Color(0xFF5C4057),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ],
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Divider(
                    height: 5.0,
                    color: Color(0xFF5C4057),
                  ),
                ],
              ),
            ),
          ],
        ),
  );
}

 /* Widget buildResultCard(String query) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
              .collection("items")
              .snapshots(),
      builder: (context,snapshot)
      {
        if(!snapshot.hasData) return Text("Loading..");
        return new ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index)
          {
             if(snapshot.hasError)
              return Text('Something went wrong');
             if(snapshot.connectionState == ConnectionState.waiting)
              return Column(
                children: [
                  Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ],
              );
              var len = snapshot.data.docs.length;
              if(len == 0)
               return Column(
                 children: [
                   SizedBox(height: 100),
                   Center(
                     child: Text("No Items", style: TextStyle(fontSize: 20,color: Colors.grey)),
                   )
                 ],
               );
              List<ItemModel> items = snapshot.data.docs.map((doc)=> ItemModel(
                title : doc['title'],
                shortInfo : doc['shortInfo'],
                publishedDate : doc['publishedDate'],
                thumbnailUrl : doc['thumbnailUrl'],
                longDescription : doc['longDescription'],
                status : doc['status'],
              )).toList();
              items = items.where((s)=>s.shortInfo.toLowerCase().contains(query.toLowerCase())).toList();

              return
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context,index){
                      return ItemModel(items[index]);
                    },
                  ),
                );
          },
        );
      },
    );
  }
  Widget _buildListItem(DocumentSnapshot document){
     return new ListTile(
        title : document['title'],
     );
   }
   */

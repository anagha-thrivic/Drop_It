import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  @override
  void initState(){
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context,listen: false).display(0);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          if(DropItApp.sharedPreferences.getStringList(DropItApp.userCartList).length == 1)
          {
            Fluttertoast.showToast(msg: "Cart is Empty");
          }
          else
          {
            Route route = MaterialPageRoute(builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          } 
        },
        label: Text("Check out"),
        backgroundColor: Color(0xFF5C4057),
        icon: Icon(Icons.navigate_next),
      ), 
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);
          },
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF5C4057)
        ),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
             colors: [Color(0xFFFDBE3B)],
             begin: const FractionalOffset(0.0, 0.0),
             end: const FractionalOffset(1.0,0.0),
             stops: [0.0, 1.0],
             tileMode: TileMode.clamp,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "DROP IT",
          style: TextStyle(fontSize: 55.0, color:Color(0xFF5C4057), fontFamily: "Signatra" ),

        ),
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
                             style: TextStyle(color: Color(0xFF5C4057), fontSize: 12.0,fontWeight: FontWeight.w500),
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

      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context,amountProvider, cartProvider, c)
            {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                  ? Container()
                  :Text(
                    "Total Price: ₹ ${amountProvider.totalAmount.toString()}",
                    style: TextStyle(color: Color(0xFF5C4057),fontSize: 20.0,fontWeight: FontWeight.w500),
                  ),
                ),
              );
            },),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: DropItApp.firestore.collection("items")
            .where("shortInfo", whereIn: DropItApp.sharedPreferences.getStringList(DropItApp.userCartList)).snapshots(),
            builder: (context,snapshot)
            {
              return !snapshot.hasData
                ?SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                : snapshot.data.docs.length == 0
                ? beginbuildingCart()
                : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context,index)
                    {
                      //check
                      ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());

                      if(index == 0)
                      {
                        totalAmount = 0;
                        totalAmount = model.price + totalAmount;
                      }
                      else
                      {
                        totalAmount = model.price + totalAmount;
                      }
                      if(snapshot.data.docs.length -1 == index)
                      {
                        WidgetsBinding.instance.addPostFrameCallback((t) {
                          Provider.of<TotalAmount>(context, listen: false).display(totalAmount);
                        });
                      }
                      return sourceInfo(model, context, removeCartFunction: () => removeItemFromUserCart(model.shortInfo)); 
                    },

                    childCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                  ),
                );
            }
          ),
        ],
      ),
   );
  }
  
  beginbuildingCart()
  {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon, color: Colors.white,),
              Text("Cart is empty"),
              Text("Start Adding Items to the cart"),
            ],
          ),
           
        )
      ),
    );

  }

  removeItemFromUserCart(String shortinfoAsId)
  {
    List tempCartList = DropItApp.sharedPreferences.getStringList(DropItApp.userCartList);
    tempCartList.remove(shortinfoAsId);

   DropItApp.firestore.collection(DropItApp.collectionUser)
    .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID))
    .update({
      DropItApp.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item Removed succesfullly.");
      DropItApp.sharedPreferences.setStringList(DropItApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      totalAmount = 0;
    });

  }
}

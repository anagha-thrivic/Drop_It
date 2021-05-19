import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context)
  {
    Size _screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Color(0xFFFDBE3B),
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemModel.longDescription,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "₹ " + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()=> checkItemInCart(widget.itemModel.shortInfo, context) ,
                        child: Container(
                           decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [Color(0xFFFDBE3B),Color(0xFF5C4057)],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0,0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 40.0 ,
                          height: 50.0,
                          child: Center(
                            child: Text("Add to Cart",style: TextStyle(color: Colors.white,),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

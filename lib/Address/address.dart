import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Orders//placeOrder.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{
  final double totalAmount;
  const Address({Key key, this.totalAmount}): super(key:key);
  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            Route route = MaterialPageRoute(builder: (c) => CartPage());
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Address",
                  style: TextStyle(color: Color(0xFF5C4057), fontWeight: FontWeight.bold, fontSize: 20.0,),                
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context,address,c){
              return Flexible(
                 child: StreamBuilder<QuerySnapshot>(
                   stream: DropItApp.firestore.collection(DropItApp.collectionUser)
                   .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID))
                   .collection(DropItApp.subCollectionAddress).snapshots(),

                   builder: (context,snapshot)
                   {
                     return !snapshot.hasData
                       ? Center(child: circularProgress(),)
                       : snapshot.data.docs.length == 0
                       ? noAddressCard()
                       : ListView.builder(
                         itemCount: snapshot.data.docs.length,
                         shrinkWrap: true,
                         itemBuilder: (context, index)
                         {
                           return AddressCard(
                             currentIndex: address.count,
                             value: index,
                             addressId: snapshot.data.docs[index].id,
                             totalAmount: widget.totalAmount,
                             model: AddressModel.fromJson(snapshot.data.docs[index].data()),
                             //check
                           );
                         },
                       );
                   },
                 ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add new Address"),
          backgroundColor:  Color(0xFF5C4057),
          icon: Icon(Icons.add_location),
          onPressed: ()
          {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white,),
            Text("No shipment address has been saved."),
            Text("Please add your Shipment Address so that we can deliver Product"),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model ;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;

  AddressCard({Key key,this.model,this.currentIndex,this.addressId,this.totalAmount,this.value}): super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: ()
      {
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Color(0xFFFDBE3B).withOpacity(0.4),
        child: Column(
          children : [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor:  Color(0xFF5C4057),
                  onChanged: (val)
                  {
                    Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth*0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children:[
                              KeyText(msg: "Name",),
                              Text(widget.model.name),
                            ]
                          ),

                          TableRow(
                            children:[
                              KeyText(msg: "Phone Number",),
                              Text(widget.model.phoneNumber),
                            ]
                          ),

                          TableRow(
                            children:[
                              KeyText(msg: "Flat Number",),
                              Text(widget.model.flatNumber),
                            ]
                          ),

                          TableRow(
                            children:[
                              KeyText(msg: "City",),
                              Text(widget.model.city),
                            ]
                          ),

                          TableRow(
                            children:[
                              KeyText(msg: "State",),
                              Text(widget.model.state),
                            ]
                          ),

                          TableRow(
                            children:[
                              KeyText(msg: "Pin Code",),
                              Text(widget.model.pincode),
                            ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
              ? WideButton(
                   message: "Proceed",
                   onPressed: () 
                   {
                     Route route = MaterialPageRoute(builder: (c)=> PaymentPage(
                       addressId : widget.addressId,
                       totalAmount: widget.totalAmount,
                     ));
                     Navigator.push(context, route);
                   },
                ) 
              : Container(),
          ],
        ),
      ),
    );

    
  }
}





class KeyText extends StatelessWidget {
 final String msg;
 KeyText({Key key, this.msg}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
    );
  }
}

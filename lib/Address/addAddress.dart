import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            Route route = MaterialPageRoute(builder: (c) => Address());
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()
          { 
            if(formKey.currentState.validate())
            {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              DropItApp.firestore.collection(DropItApp.collectionUser)
               .doc(DropItApp.sharedPreferences.getString(DropItApp.userUID))
               .collection(DropItApp.subCollectionAddress)
               .doc(DateTime.now().millisecondsSinceEpoch.toString())
               .set(model) 
               .then((value){
                 final snack = SnackBar(content: Text("New Address added successfully"));
                 scaffoldKey.currentState.showSnackBar(snack);
                 FocusScope.of(context).requestFocus(FocusNode());
                 formKey.currentState.reset();
               });

              Route route = MaterialPageRoute(builder: (c)=> StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: Color(0xFF5C4057),
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(color:Color(0xFF5C4057), fontWeight:FontWeight.bold, fontSize: 20.0 ),
                  ),
                ),
              ),
              Form(
                 key: formKey,
                 child: Column(
                   children: [
                     MyTextField(
                       hint: "Name",
                       controller: cName,
                     ),
                     MyTextField(
                       hint: "Phone Number",
                       controller: cPhoneNumber,
                     ),
                     MyTextField(
                       hint: "Flat Number/ House Number",
                       controller: cFlatHomeNumber,
                     ),
                     MyTextField(
                       hint: "City",
                       controller: cCity,
                     ),
                     MyTextField(
                       hint: "State",
                       controller: cState,
                     ),
                     MyTextField(
                       hint: "Pin Code",
                       controller: cPinCode,
                     ),
                   ],
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
 final String hint;
 final TextEditingController controller;
 MyTextField({Key key, this.hint, this.controller,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=> val.isEmpty ? "Complete the form" : null,
      ),
    );
  }
}

import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
           padding: EdgeInsets.only(top:25.0, bottom: 10.0),
           decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(0xFFFDBE3B),Color(0xFF5C4057) ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0,0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                 borderRadius: BorderRadius.all(Radius.circular(00.0)),
                 elevation: 0.0,
                  child: Container(
                   height: 160.0,
                   width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        DropItApp.sharedPreferences.getString(DropItApp.userAvatarUrl),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:10.0,),
                Text(
                 DropItApp.sharedPreferences.getString(DropItApp.userName),
                 style: TextStyle(color: Color(0xFF5C4057), fontSize: 35.0, fontFamily: "Signatra" ),
                ),
              ],
            ),
          ),
          SizedBox(height:12.0,),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(0xFFFDBE3B),Color(0xFF5C4057)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0,0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home,color: Color(0xFF5C4057),),
                  title: Text("Home",style: TextStyle(color: Color(0xFF5C4057)),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color:  Color(0xFF5C4057),thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.reorder,color: Color(0xFF5C4057),),
                  title: Text("My Orders",style: TextStyle(color: Color(0xFF5C4057)),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color:  Color(0xFF5C4057),thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.shopping_cart,color: Color(0xFF5C4057),),
                  title: Text("My Cart",style: TextStyle(color:  Color(0xFF5C4057)),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color:  Color(0xFF5C4057),thickness: 6.0,),

               ListTile(
                  leading: Icon(Icons.search,color: Color(0xFF5C4057),),
                  title: Text("Search",style: TextStyle(color:  Color(0xFF5C4057)),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color:  Color(0xFF5C4057),thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.add_location,color: Color(0xFF5C4057),),
                  title: Text("Add new address",style: TextStyle(color:  Color(0xFF5C4057)),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color: Color(0xFF5C4057),thickness: 6.0,),

                ListTile(
                  leading: Icon(Icons.exit_to_app,color: Color(0xFF5C4057),),
                  title: Text("Logout",style: TextStyle(color: Color(0xFF5C4057)),),
                  onTap: (){
                    DropItApp.auth.signOut().then((c){
                    Route route = MaterialPageRoute(builder: (c) => AuthenticScreen());
                    Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(height: 10.0,color:  Color(0xFF5C4057),thickness: 6.0,),

              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
       appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
             colors: [Color(0xFFFDBE3B), Color(0xFF5C4057)],
             begin: const FractionalOffset(0.0, 0.0),
             end: const FractionalOffset(1.0,0.0),
             stops: [0.0, 1.0],
             tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "DROP IT",
          style: TextStyle(fontSize: 55.0, color:Color(0xFF5C4057), fontFamily: "Signatra" ),

        ),
        centerTitle: true,
        bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.lock, color: Color(0xFF5C4057),),
              text: "Login",
            ),
            Tab(
              icon: Icon(Icons.person, color: Color(0xFF5C4057),),
              text: "Register",
            ),
          ],
          indicatorColor: Colors.white38,
          indicatorWeight: 5.0,
        ),
       ),
        body: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
             colors: [Color(0xFF5C4057), Color(0xFFFDBE3B)],
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
            ),
          ),
          child: TabBarView(
            children: [
              Login(),
              Register(), 
            ]),
        ),
      ),  
    );
  }
}

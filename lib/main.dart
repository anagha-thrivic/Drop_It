import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/itemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DropItApp.auth = FirebaseAuth.instance;
  DropItApp.sharedPreferences = await SharedPreferences.getInstance();
  DropItApp.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=>CartItemCounter()),
        ChangeNotifierProvider(create: (c)=>ItemQuantity()),
        ChangeNotifierProvider(create: (c)=>AddressChanger()),
        ChangeNotifierProvider(create: (c)=>TotalAmount()),
      ],
      child:MaterialApp(
        title: 'e-Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFFDBE3B),
       ),
        home: SplashScreen()
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
     super.initState();
     displaySplash();
  }

  displaySplash()
  {
    Timer(Duration(seconds:5), () async{
      if( await DropItApp.auth.currentUser != null)
      {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route); 
      }
      else
      {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }
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
            Image.asset("images/welcome.png"),
            SizedBox(height: 20.0),
            Text(
              "Drop IT",
              style: TextStyle(color: Colors.white ),
           ),
          ],
        ),
       ),
      ),
    );
  }
}

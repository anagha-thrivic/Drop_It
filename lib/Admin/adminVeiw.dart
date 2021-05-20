import 'package:e_shop/Admin/adminStockDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';



class adminveiw extends StatelessWidget {
  const adminveiw({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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

           actions: [
             TextButton(
               child: Text("Logout", style:TextStyle(color: Color(0xFFFDBE3B), fontSize: 16.0, fontWeight: FontWeight.bold,),),
               onPressed: ()
               {
                 Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                 Navigator.pushReplacement(context, route);
                 },
             ),
           ],
         ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  iconSize: 100.0,
                  icon: ImageIcon(
                    new AssetImage('assets/icons/deliveryman.png'),
                    size: 100.0,),
                  onPressed: (){}),
              Text("Delivery Person Details",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
              SizedBox(height: 50.0,),

              IconButton(
                  iconSize: 100.0,
                  icon: ImageIcon(
                    new AssetImage('assets/icons/goods.png'),
                    size: 100.0,),
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> StockDetails()));}),
              Text("In Stock Details",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),



            ], ),
        ),
      ),
    );
  }
}

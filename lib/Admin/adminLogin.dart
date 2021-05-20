import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminVeiw.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
             colors: [Color(0xFF5C4057), Color(0xFFFDBE3B)],
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
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  


  @override
  Widget build(BuildContext context) {
   double _screenWidth = MediaQuery.of(context).size.width,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
        child:Column(
         mainAxisSize: MainAxisSize.max,
         children: [
           Container(
             child: Image.asset(
               "images/admin.png",
               height: 240.0,
               width: 240.0,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Admin",
              style: TextStyle(color: Color(0xFF5C4057),fontSize: 28.0,fontWeight: FontWeight.bold ),
            ),
          ),
           Form(
             key: _formkey,
             child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "Id",
                    isObsecure: false,
                  ),
                   CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
             ),
           ),
            MaterialButton(
             onPressed: () {
               _adminIDTextEditingController.text.isNotEmpty
                && _passwordTextEditingController.text.isNotEmpty
                ? loginAdmin()
                :showDialog(
                   context: context,
                   builder: (c)
                   {
                     return ErrorAlertDialog(message:"Please write email and password.", );
                   }
                );
              },
             color: Color(0xFF5C4057),
             child: Text("Login", style: TextStyle(color: Colors.white),
             ),
            ),
           SizedBox(
             height:50.0,
           ),
           Container(
             height: 4.0,
             width: _screenWidth * 0.8,
             color:Color(0xFF5C4057),
           ),
           SizedBox(
             height: 20.0,
           ),
           TextButton.icon(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthenticScreen())),
            icon: (Icon(Icons.nature_people,color:Color(0xFF5C4057),)),
            label: Text("I am not an Admin",style: TextStyle(color: Color(0xFF5C4057),fontWeight: FontWeight.bold),),
           ),
           SizedBox(
             height: 50.0,
           ),
         ],
        )
      )
    );
  }

  loginAdmin() 
  {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot){
      snapshot.docs.forEach((result) {
       if(result.get("id") !=_adminIDTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("your id is not correct")));
        }
        else if(result.get("password") !=_passwordTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("your password is not correct")));
        }
        else
        {
          //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin"+ result.get(['name']))));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => adminveiw());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}

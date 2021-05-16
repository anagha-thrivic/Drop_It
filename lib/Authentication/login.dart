import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child:Column(
         mainAxisSize: MainAxisSize.max,
         children: [
           Container(
             child: Image.asset(
               "images/login.png",
               height: 240.0,
               width: 240.0,
             ),
           ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Login to your account",
              style: TextStyle(color: Colors.white),
            ),
          ),
           Form(
             key: _formkey,
             child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
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
            RaisedButton(
             onPressed: () {
               _emailTextEditingController.text.isNotEmpty
                && _passwordTextEditingController.text.isNotEmpty
                ? loginUser()
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
             height: 10.0,
           ),
           FlatButton.icon(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminSignInPage())),
            icon: (Icon(Icons.nature_people,color: Color(0xFF5C4057),)),
            label: Text("I am an Admin",style: TextStyle(color: Color(0xFF5C4057),fontWeight: FontWeight.bold),),
           ),
         ],
        )
      )
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async
  {
    showDialog(
      context: context, 
      builder: (c)
      {
        return LoadingAlertDialog(message:"Authenticating. Please wait..",);
      }
    );
   User firebaseUser;
    await _auth.signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(), 
      password: _passwordTextEditingController.text.trim(),
    ).then((authUser){
      firebaseUser = authUser.user ;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c)
       {
        return ErrorAlertDialog(message: error.message.toString(),);
       }  
      );
    });
    if(firebaseUser !=null)
    {
      readData(firebaseUser).then((s){
       Navigator.pop(context);
       Route route = MaterialPageRoute(builder: (c) => StoreHome());
       Navigator.pushReplacement(context, route);
     });
    }
  }

  Future readData(User fUser) async
  {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then((dataSnapshot)
    async {
      await DropItApp.sharedPreferences.setString("uid",dataSnapshot.data()[DropItApp.userUID]);

      await DropItApp.sharedPreferences.setString(DropItApp.userEmail,dataSnapshot.data()[DropItApp.userEmail]);

      await DropItApp.sharedPreferences.setString(DropItApp.userName,dataSnapshot.data()[DropItApp.userName]);

      await DropItApp.sharedPreferences.setString(DropItApp.userAvatarUrl,dataSnapshot.data()[DropItApp.userAvatarUrl]);

      List<String> cartList = dataSnapshot.data()[DropItApp.userCartList].cast<String>();
      await DropItApp.sharedPreferences.setStringList(DropItApp.userCartList,cartList);
    });
  }
}


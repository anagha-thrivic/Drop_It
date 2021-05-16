import 'dart:io';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{ 
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cpasswordTextEditingController = TextEditingController(); 
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imagefile;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap:_selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imagefile==null ? null : FileImage(_imagefile),
                child: _imagefile ==null
                    ? Icon(Icons.add_photo_alternate, size: _screenWidth *0.15, color:Color(0xFF5C4057))
                    : null,
              ),
            ),
           SizedBox(height:8.0,),
           Form(
             key: _formkey,
             child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
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
                   CustomTextField(
                    controller: _cpasswordTextEditingController,
                    data: Icons.person,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
             ),
           ),
           RaisedButton(
             onPressed: () {uploadAndSaveImage();},
             color: Color(0xFF5C4057),
             child: Text("Sign Up", style: TextStyle(color: Colors.white),
             ),
           ),
           SizedBox(
             height:30.0,
           ),
           Container(
             height: 4.0,
             width: _screenWidth * 0.8,
             color: Colors.pink,
           ),
           SizedBox(
             height: 15.0,
           ),
          ],
        ),
      ),
    );
  }
  Future<void> _selectAndPickImage() async
  {
   _imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async
  {
    if(_imagefile == null)
    {
      showDialog(
        context: context, 
        builder: (c)
        {
          return ErrorAlertDialog(message: "Please select an image file",);
        }
      );
    }
    else
    {
      _passwordTextEditingController.text == _cpasswordTextEditingController.text
        ?_emailTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty && _cpasswordTextEditingController.text.isNotEmpty && _nameTextEditingController.text.isNotEmpty
        ? uploadToStorage()
        : displayDialog("Please fill up the complete form")

        : displayDialog("Password do not match");
    }
  }

  displayDialog(String msg)
  {
    showDialog(
      context: context, 
      builder: (c)
      {
        return ErrorAlertDialog(message:msg,);
      }
    );
  }

 uploadToStorage() async
 {
    showDialog(
      context: context,
       builder: (c)
       {
         return LoadingAlertDialog(message: "'Registering, Please wait.....'",);
       }
    );
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference = FirebaseStorage.instance.ref().child(imageFileName) ;
            
    UploadTask storageUploadTask = storageReference.putFile(_imagefile);
                                        
    TaskSnapshot taskSnapshot = (await storageUploadTask) ;
                                                                            
    await taskSnapshot.ref.getDownloadURL().then((urlImage){
     userImageUrl = urlImage;
     _registerUser();
    });
 }
 FirebaseAuth _auth = FirebaseAuth.instance;
 void _registerUser() async
{
  User firebaseUser;
  await _auth.createUserWithEmailAndPassword
  (
   email: _emailTextEditingController.text.trim(), 
   password: _passwordTextEditingController.text.trim(),
  ).then((auth){
    firebaseUser = auth.user ;
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
   saveUserInfoToFirestore(firebaseUser).then((value){
     Navigator.pop(context);
     Route route = MaterialPageRoute(builder: (c) => StoreHome());
     Navigator.pushReplacement(context, route);
   });
  }
}
                                                              
Future saveUserInfoToFirestore(User fUser) async
{
   FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
   "uid": fUser.uid,
   "email": fUser.email,
   "name": _nameTextEditingController.text.trim(),
   "url": userImageUrl,
   DropItApp.userCartList: ["garbageValue"],
  });
  await DropItApp.sharedPreferences.setString("uid",fUser.uid);
  await DropItApp.sharedPreferences.setString(DropItApp.userEmail,fUser.email);
  await DropItApp.sharedPreferences.setString(DropItApp.userName,_nameTextEditingController.text);
  await DropItApp.sharedPreferences.setString(DropItApp.userAvatarUrl,userImageUrl);
  await DropItApp.sharedPreferences.setStringList(DropItApp.userCartList, ["garbageValue"]);
}
}



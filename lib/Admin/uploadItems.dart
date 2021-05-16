import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptiontextEditingController = TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shortInfotextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;


  @override
  Widget build(BuildContext context) {
    return file==null ? displayAdminHomeScreen(): displayUploadFormScreen();
  }

  displayAdminHomeScreen()
  {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(Icons.border_color,color:Color(0xFF5C4057),),
          onPressed: ()
          {
             Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
             Navigator.pushReplacement(context, route);
          }
        ),
        actions: [
          FlatButton(
             child: Text("Logout", style:TextStyle(color: Color(0xFFFDBE3B), fontSize: 16.0, fontWeight: FontWeight.bold,),),
             onPressed: ()
             {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
             },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody()
  {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
         colors: [Color(0xFF5C4057), Color(0xFFFDBE3B)],
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
            Icon(Icons.shop_two, color: Colors.white, size: 200.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text("Add new item", style: TextStyle(fontSize: 20.0,color: Colors.white),),
                color: Color(0xFF5C4057),
                onPressed: ()=> takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (con)
      {
        return SimpleDialog(
          title: Text("Item Image", style: TextStyle(color: Color(0xFF5C4057),fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              child: Text("Capture with Camera",style: TextStyle(color: Color(0xFF5C4057),)),
              onPressed: capturePhotoWithCamera,
            ),
           SimpleDialogOption(
              child: Text("Select from gallery",style: TextStyle(color: Color(0xFF5C4057),)),
              onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel",style: TextStyle(color: Color(0xFF5C4057),)),
              onPressed: ()
              {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  capturePhotoWithCamera() async
  {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async
  {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });
  }

  displayUploadFormScreen()
  {
    return Scaffold(
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
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Color(0xFF5C4057),onPressed: clearFormInfo),//back
        title: Text("New Product",style: TextStyle(color: Color(0xFF5C4057), fontSize: 24.0,fontWeight: FontWeight.bold,),),
        actions: [
          FlatButton(
            onPressed: uploading ? null : ()=> uploadImageAndSaveItemInfo() ,
            child: Text("Add", style: TextStyle(color:Color(0xFFFDBE3B), fontSize: 16.0, fontWeight: FontWeight.bold,),),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width *0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Color(0xFFFDBE3B),),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Color(0xFF5C4057)),
                controller: _shortInfotextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Color(0xFF5C4057)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Color(0xFF5C4057),),

          ListTile(
            leading: Icon(Icons.perm_device_information, color:Color(0xFFFDBE3B),),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Color(0xFF5C4057)),
                controller: _titletextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Color(0xFF5C4057)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color:Color(0xFF5C4057),),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Color(0xFFFDBE3B),),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Color(0xFF5C4057)),
                controller: _descriptiontextEditingController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Color(0xFF5C4057)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Color(0xFF5C4057),),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Color(0xFFFDBE3B),),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Color(0xFF5C4057)),
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Color(0xFF5C4057)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Color(0xFF5C4057),)
        ],
      ),
    );
  }

  clearFormInfo()
  {
    setState(() {
       file = null;
       _descriptiontextEditingController.clear();
       _titletextEditingController.clear();
       _pricetextEditingController.clear();
       _shortInfotextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });

   String imageDownloadUrl = await uploadItemImage(file);
    
   saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async
  {
    final Reference storageReference = FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = (await uploadTask);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downlooadUrl)
  {
    final itemRef = FirebaseFirestore.instance.collection("items").doc(productId).set({
      "shortInfo": _shortInfotextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downlooadUrl,
      "title": _titletextEditingController.text.trim(),

    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _shortInfotextEditingController.clear();
      _pricetextEditingController.clear();
    });
  }
}

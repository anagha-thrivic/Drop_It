import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/itemVeiw.dart';
import 'package:e_shop/Models/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StockDetails extends StatefulWidget {
  final ItemModel itemModel;

  const StockDetails({Key key, this.itemModel}) : super(key: key);

  @override
  _StockDetailsState createState() => _StockDetailsState();
}

class _StockDetailsState extends State<StockDetails> with AutomaticKeepAliveClientMixin<StockDetails>
{

  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptiontextEditingController = TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shortInfotextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  CollectionReference ref = FirebaseFirestore.instance.collection('items');
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file==null ? displayAdminHomeScreen(): displayUploadFormScreen();
  }

  displayAdminHomeScreen(){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0,0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            "DROP IT",
            style: TextStyle(fontSize: 55.0, color:Colors.white, fontFamily: "Signatra" ),

          ),
          centerTitle: true,

        ),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: false, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
             stream: FirebaseFirestore.instance.collection("items")
                  .limit(15).orderBy("publishedDate",descending: true).snapshots(),
              builder: (context, dataSnapshot)
              {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                  itemBuilder: (context,index)
                  {
                    ItemModel model= ItemModel.fromJson(dataSnapshot.data.docs[index].data());
                    return sourceInfo(model, context);
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              },

            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()=> takeImage(context),
          child: Icon(Icons.add),
        ),
      ),
    );

  }


  Widget sourceInfo(ItemModel model, BuildContext context,
      {Color background, removeCartFunction}) {
    return InkWell(
      onTap: ()
      {
        Route route = MaterialPageRoute(builder: (c) => ItemView(itemModel: model));
        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.pink,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: 190.0,
          width: width,
          child: Row(
            children: [
              Image.network(model.thumbnailUrl,width: 140.0,height:140.0,),
              SizedBox(width: 4.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.title,style: TextStyle(color: Colors.black, fontSize: 14.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:5.0,),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(model.shortInfo,style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:20.0,),
                    Row(
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Description: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    (model.longDescription).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6.0,),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Currently: ",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    (model.status).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Price: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "₹ ",
                                    style: TextStyle(color:Colors.red,fontSize: 16.0),
                                  ),
                                  Text(
                                    (model.price).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),


                    Divider(
                      height: 5.0,
                      color: Colors.pink,
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


  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con)
        {
          return SimpleDialog(
            title: Text("Item Image", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera",style: TextStyle(color: Colors.green,)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select from gallery",style: TextStyle(color: Colors.green,)),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel",style: TextStyle(color: Colors.green,)),
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
  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }
  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });
  }
  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0,0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.white,onPressed: clearFormInfo),
        title: Text("New Product",style: TextStyle(color: Colors.white, fontSize: 24.0,fontWeight: FontWeight.bold,),),
        actions: [
          TextButton(
            onPressed: uploading ? null : ()=> uploadImageAndSaveItemInfo() ,
            child: Text("Add", style: TextStyle(color:Colors.pink, fontSize: 16.0, fontWeight: FontWeight.bold,),),
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
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfotextEditingController,
                decoration: InputDecoration(
                  hintText: "Short Info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titletextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Divider(color: Colors.pink,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptiontextEditingController,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Divider(color: Colors.pink,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          Divider(color: Colors.pink,)
        ],
      ),
    );
  }
  clearFormInfo() {
    setState(() {
      file = null;
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _pricetextEditingController.clear();
      _shortInfotextEditingController.clear();
    });
  }
  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mFileImage) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = (await uploadTask);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downlooadUrl) {
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









import 'package:e_shop/Admin/adminStockDetails.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';


class ItemView extends StatefulWidget {
  final ItemModel itemModel;
  ItemView({this.itemModel});
  @override
  _ItemViewState createState() => _ItemViewState();
}



class _ItemViewState extends State<ItemView> {


  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context)
  {
    Size _screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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

        ),

        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Color(0xFFFDBE3B),
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Title: "+
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Info: "+
                            widget.itemModel.shortInfo,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Description: "+
                            widget.itemModel.longDescription,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Status: "+
                            widget.itemModel.status,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text("Price: "+
                            "₹ " + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 40.0,
                          ),

                          MaterialButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> StockDetails()));
                            },
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(
                              "Go Back",
                            ),
                          ),
                        ],
                      ),

                    ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

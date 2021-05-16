import 'package:flutter/material.dart';


circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:12.0),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF5C4057)),),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top:12.0),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF5C4057)),),
  );
}

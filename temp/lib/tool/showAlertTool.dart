
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future showAlertTool(BuildContext context,String hint,String info,void callback(),void Function() callbackfalse) async {//选择框
  var alert = await showDialog(context:context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hint),
          content: Text(info),
          actions: <Widget>[
            CupertinoButton(
              color: Colors.blueAccent,
              onPressed: () {
                callback();
                Navigator.pop(context,"true");
              },
              child: const Text("确认",style: TextStyle(color: Colors.white,fontSize: 10),),
            ),
            SizedBox(height: 20,),
            CupertinoButton(
              color: Colors.blueAccent,
              onPressed: () {
                callbackfalse();
                Navigator.pop(context,"false");
              },
              child: const Text("否认",style: TextStyle(color: Colors.white,fontSize: 10),),
            ),
          ],
        );
      }

  );
  return alert;

}
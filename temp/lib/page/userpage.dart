import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langsisiswn/VO/user_info.dart';
import '../common/LoginPrefs.dart';
import '../tool/showAlertTool.dart';
import '../ui/AvatarScreen.dart';
class UserPage extends StatefulWidget{
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String header="http://192.168.1.111:8040/upload/userinfo/"+LoginPrefs.getUSERFILDID().toString();
  String username=LoginPrefs.getUserName().toString();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        final result= await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  AvatarScreen(header: pickedImage.path)),);
        if(result){
          setState(() {
            header="http://192.168.1.111:8040/upload/userinfo/"+LoginPrefs.getUSERFILDID().toString();
          });
        }

    }
  }
  @override
  Widget build(BuildContext context) {
    /// 界面框架
    return Scaffold(
      /// 居中组件
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight),
            CupertinoButton(//头像
                child: Container(
              width: 100,
              height: 100,
              //超出部分，可裁剪
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.network(
                header,
                fit: BoxFit.cover,
              ),
            ),
                onPressed: ()=>{
                  _pickImage(ImageSource.gallery)


            }),
            TextButton(
                onPressed: ()=>{
            }, child: Text(username,style: TextStyle(fontSize: 20))
            ),
             const SizedBox(height: 10.0,),
            Statlelist(1,"切换账号"),
            Statlelist(2,"关于我们"),
            Statlelist(3,"账号认证"),
            Statlelist(4,"设置"),
          ],
        ),
      ),
    );


  }
 nider(String x){//切换账号方法
    print("切换账号？111"+x);
  }
   switchaccount() {//切换账号
    showAlertTool(context,"提示","是否切换账号",(){nider("账号");},(){});

  }

  Widget Statlelist (int num,String text) {
    return  Material(

      color: Colors.black45,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 40.0,
        child: InkWell(
          onTap: (){
            if(num==1){
              switchaccount();
            }else if(num==4){
              
            }
          },
          child: Row(
            children:[
              Padding(padding: EdgeInsets.only(left: 10.0),
                child:
                Text(text,style: TextStyle(color: Colors.white),),

              )

            ],
          ),
        ),
      ),
    );
  }
}
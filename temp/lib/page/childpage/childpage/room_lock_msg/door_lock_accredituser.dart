import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/common/lock_psw.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../VO/Internet_msg.dart';
import '../../../../method/http/httpUtil.dart';
import '../../../../method/methopchannel/flutterMethodChannel.dart';
import '../associated_apparatus.dart';

class DoorLockAccredituser extends StatefulWidget {
  final String hid;
  DoorLockAccredituser({required this.hid});

  @override
  _DoorLockAccredituserState createState() => _DoorLockAccredituserState();
}

class _DoorLockAccredituserState extends State<DoorLockAccredituser> {
  List<dynamic> tenantlist = [];
  String lx="";
  @override
  void initState() {
    super.initState();
    gettenantlist(widget.hid);
  }

  void gettenantlist(String hid) async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"hid":widget.hid});
    String url = "${urlModel.url}/housed/getRentMsg";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    setState(() { tenantlist = result["data"];});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('授权'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: tenantlist.length,
            itemBuilder: (context, index) {
              final item = tenantlist[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                        SizedBox(
                        height:50,
                        width: 50,
                        child:item["rentsex"]=="女"?Image(image: AssetImage("images/peoplew.png")):Image(image: AssetImage("images/people.png")) ,),
                          SizedBox(width:30.0),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 130.0,
                                    height: 50,
                                    child:  Text(item["rentname"],style: TextStyle(fontSize: 8,color: Colors.grey),)
                                  ),
                                  SizedBox(
                                    width: 130.0,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) =>
                                            AssociatedApparatus(hid: widget.hid,rid: item["rentNo"]),
                                        ));
                                      }, child: Text('选择',style: TextStyle(fontSize: 10),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                    ],
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

}

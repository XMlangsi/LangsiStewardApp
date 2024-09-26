import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../../../../VO/Internet_msg.dart';

class DoorLockInformation extends StatefulWidget {
    final String dsn;
    const DoorLockInformation({required this.dsn});

    @override
    _DoorLockInformationState createState() => _DoorLockInformationState();
}
class _DoorLockInformationState extends State<DoorLockInformation> {
  Map<String, dynamic> lockinfo = {"dsn":"无"};
  @override
  void initState() {
    // TODO: implement initState
    print(widget.dsn);
    setDoorLockInformation();
    super.initState();
  }

  Future<void> setDoorLockInformation() async {//查找该门锁基本信息
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":widget.dsn});
    String url = "${urlModel.url}/sdiRhSbb/lockinfo";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    setState(() {
      lockinfo=result["data"][0];
      print(lockinfo);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('门锁信息'),
    ),
        body:
      Column(
      children: [
        const Divider(
          color: Colors.grey, // 分隔线颜色
          thickness: 1.0,     // 分隔线厚度
        ),
        SizedBox(height: 10,),
      Row(children: [
        SizedBox(width:100,child: Text("门锁编号:",textAlign: TextAlign.center,),),
        Text('${lockinfo["dsn"]}')
      ],),
        SizedBox(height: 10,),
        const Divider(
          color: Colors.grey, // 分隔线颜色
          thickness: 1.0,     // 分隔线厚度
        ),
        SizedBox(height: 10,),
        Row(children: [
          SizedBox(width:100,child: Text("门锁名称:",textAlign: TextAlign.center,),),
          Text('${lockinfo["mc"]}')
        ],),
        SizedBox(height: 10,),
        const Divider(
          color: Colors.grey, // 分隔线颜色
          thickness: 1.0,     // 分隔线厚度
        ),
        SizedBox(height: 10,),
        Row(children: [
          SizedBox(width:100,child: Text("门锁电量:",textAlign: TextAlign.center,),),
          Text("${lockinfo["power"]}%")
        ],),
        SizedBox(height: 10,),
        const Divider(
          color: Colors.grey, // 分隔线颜色
          thickness: 1.0,     // 分隔线厚度
        ),
        SizedBox(height: 10,),
        Row(children: [
          SizedBox(width:100,child: Text("上报时间:",textAlign: TextAlign.center,),),
          Text("${lockinfo["onlineRefreshTime"]}")
        ],),
        SizedBox(height: 10,),
        const Divider(
          color: Colors.grey, // 分隔线颜色
          thickness: 1.0,     // 分隔线厚度
        ),
        SizedBox(height: 10,),
        Row(children: [
          SizedBox(width:100,child: Text("门锁信号:",textAlign: TextAlign.center,),),
          Text("${lockinfo["csq"]}")
        ],),
        SizedBox(height: 10,),
        const Divider(
          color: Colors.grey, // 分隔线颜色
          thickness: 1.0,     // 分隔线厚度
        ),
      ],
    ));
  }

}
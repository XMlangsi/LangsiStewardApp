import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/page/childpage/childpage/link_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../VO/Internet_msg.dart';
import '../../common/LoginPrefs.dart';
import '../../method/http/httpUtil.dart';
import '../../method/methopchannel/flutterMethodChannel.dart';


class ProcessingList extends StatefulWidget{

  ProcessingList({super.key});
  @override
  _ProcessingListState createState() => _ProcessingListState();
}

class _ProcessingListState extends State<ProcessingList> {
  List<dynamic> passwordList = [
    {"mc": "房间101", "lx": "03", "yhbh": "001"}
  ];
  Future<void> sellisting() async {
      final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
      Dio dio = new Dio();
      FormData formData = FormData.fromMap({"yhbh":LoginPrefs.getToken().toString()});
      String url = "${urlModel.url}/sdiRhyhb/sel_yhb";
      Response response = await dio.post(url, data: formData);
      var result = response.data;
      if(result==null){
        setState(() {
          passwordList=[];
        });
      }else{
        setState(() {
          passwordList=result["data"];
        });
      }

  }

   @override
   void initState() {
     super.initState();
     sellisting();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('未处理列表'),
      ),
      body: ListView.builder(
        itemCount: passwordList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              leading:passwordList[index]['channel']=='2'? Icon(Icons.lock, color: Color(0xFF3CAAFA)):Icon(Icons.bluetooth_audio_rounded, color:  Color(0xFF3CAAFA)),
              title: Text("房间名称: ${passwordList[index]['mc']}"),
              subtitle: Text("密码类型: ${passwordList[index]['lx']=='01'?'指纹':passwordList[index]['lx']=='02'?'卡片':'密码'}"
                  "\n设备编号: ${passwordList[index]['dsn']}\n"
                  "用户编号: ${passwordList[index]['yhbh']}"),
              trailing: ElevatedButton(
                onPressed: () {
                  // 点击处理按钮后的操作逻辑
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('删除'),
                        content: Text('确定要删除此权限吗？'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              del_Privilege(passwordList[index]['hid'],passwordList[index]['password'],passwordList[index]['yhbh'],passwordList[index]['dsn'],passwordList[index]['aesKey'],passwordList[index]['adminAuthCode'],passwordList[index]['lx']);
                            },
                            child: Text('删除'),
                          ),
                          TextButton(
                            onPressed: () {
                              // 处理逻辑
                              Navigator.of(context).pop();

                            },
                            child: Text('取消'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('删除'),
              ),
            ),
          );
        },
      ),
    );
  }
  void requestBluetoothScanPermission() async {

    var status = await Permission.bluetoothScan.status;
    if (!status.isGranted) {
      await Permission.bluetoothConnect.request();
      await Permission.bluetoothScan.request();
    }
  }
  void del_psw(String yhbh,String psw,String dsn,String hid) async {//删除密码
    final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
    Map<String, dynamic> params = {};
    params["yhbh"] =yhbh;
    params["dsn"] = dsn;
    HttpUtil.request(
      "${urlModel.url}/sdiRhyhb/del_yhb",
      method: "post",
      params: params,
    ).then((value) {
      final urlModel =
      Provider.of<Internet_msg>(context, listen: false); //获取url
      Map<String, dynamic> params = {};
      params["users"] = LoginPrefs.getToken().toString();
      params["equipNo"] = dsn;
      params["hid"] = hid;
      params["equipType"] = "门锁";
      params["operationType"] = "删除";
      params["pwdType"] = "蓝牙用户($yhbh)";
      params["operationDate"] ="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
      params["pwd"] =psw;
      params["xfly"] = "朗思APP";
      HttpUtil.request(
        "${urlModel.url}/operationlog/insert",
        method: "post",
        params: params,
      ).then((value) {
        Navigator.pop(context);
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info,color: Colors.blueAccent,),
                Text("提示")
              ],
            ),
            content:const Text("操作成功"),
            actions: [
              TextButton(onPressed: () {
                sellisting();
                Navigator.of(context).pop();
              }, child:const Text("确定")),
            ],
          );
        },
      );
    });
  }
  Future<void> del_Privilege(String hid,String psw,String yhbh,String dsn,String aesKey,String adminAuthCode,String lx) async {
    if(yhbh.contains("B")){//当是蓝牙下发的数据
        requestBluetoothScanPermission();
        var status = await Permission.bluetoothScan.status;
        if (status.isGranted) {
          var result = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_CONNECTION", {"mac":dsn});
          if(result["message"]=="true"){
            sleep(const Duration(seconds: 5));
            print( {"keyType":1,
              "type":lx,
              "userid":yhbh,
              "mac":dsn,
              "authCode":adminAuthCode,
              "dnaKey":aesKey,
            });
            var resulte = await FlutterMethodChannel.invokeNativeMethod("BLUELIST_DELETEPW",
                {"keyType":1,
                  "type":lx,
                  "userid":yhbh,
                  "mac":dsn,
                  "authCode":adminAuthCode,
                  "dnaKey":aesKey,
                });
            print(resulte.toString());
            print(resulte["message"]);
            if(resulte["message"]=="1"){
              del_psw(yhbh,psw,dsn,hid);
            }

          }else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.dangerous,color: Colors.red,),
                      Text("警告")
                    ],
                  ),
                  content: const Text("蓝牙无法连接该设备"),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, child: const Text("确定")),
                  ],
                );
              },
            );
          }
          }
      }else{//非蓝牙下发的数据

      }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/common/lock_psw.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../../VO/Internet_msg.dart';
import '../../../../common/LoginPrefs.dart';
import '../../../../method/http/httpUtil.dart';
import '../../../../method/methopchannel/flutterMethodChannel.dart';

class DoorLockCard extends StatefulWidget {
  final String dsn;
  final String hid;
  final String authCode;
  final String dnaKey;
  final String rid;
  final bool bl;//是否连接蓝牙
  DoorLockCard({required this.rid,required this.dsn, required this.hid, required this.bl, required this.authCode, required this.dnaKey});
  @override
  _DoorLockCardState createState() => _DoorLockCardState();
}

class _DoorLockCardState extends State<DoorLockCard> {
  late String dsn;
  late String lx="20";
  List<Map<String, String>> collectorlist = [];
  String collector = ""; //选择的采集器
  late String password = Random().nextInt(999999).toString().padLeft(6, '0');
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now().add(const Duration(days: 3650)); // 默认：当前时间加1天
  TextEditingController passwordController = TextEditingController();

  bool isLoading =false;
  @override
  void initState() {

    isLoading = true;
    super.initState();
    dsn = widget.dsn;
    getlocklx(dsn);
    select_lockmsg(dsn);
    sel_cj();
    setState(() {
      password = Random().nextInt(999999).toString().padLeft(6, '0');
      passwordController.text=password;
      isLoading = false;
    });
  }
  @override
  sel_cj() async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"userid": LoginPrefs.getToken()});
    String url = "${urlModel.url}/IBSpider/sel_spider";
    Response response = await dio.post(url, data: formData);
    var result = response.data;
    print(result);
    if (result["code"] == 0) {
      // 检查返回的代码是否为成功
      List<dynamic> dataList = result["data"]; // 获取数据列表
      for (var data in dataList) {
        // 处理每个字典对象
        setState(() {
          collectorlist.add({"spiderId": data["spiderId"].toString(), "deptid": data["deptid"].toString()});
          collector = collectorlist[0]["spiderId"]!;
        });
      }
    } else {
      print("请求失败：${result["msg"]}");
    }
    // setState(() {
    //   collectorlist=result["data"];
    // });
  }
  void dispose() {
    // 销毁TextEditingController对象
    passwordController.dispose();
    super.dispose();
  }
  void getlocklx(String dsn) async {

    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":dsn});
    String url = "${urlModel.url}/housed/getlocklx";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    setState(() {
      lx=result["data"][0]["lx"];
    });

  }
  void select_lockmsg(String dsn) async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":dsn});
    String url = "${urlModel.url}/housed/get-room-lock-msgs";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    setState(() {
      print(result);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('卡片下发'),
      ),
      body:
      isLoading
          ? Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                    width: 100.0,
                    child: Text(
                      '采集器:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(width: 20.0),
                DropdownButton(
                  value: collector,
                  items: collectorlist.map<DropdownMenuItem<String>>((Map<String, String> item) {
                    return DropdownMenuItem<String>(
                      value: item["spiderId"],
                      child: Text(
                        item["spiderId"]!,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      collector = value!;
                    });
                  },
                )
              ],
            ),
            const Divider(
              color: Colors.grey, // 分隔线颜色
              thickness: 1.0,     // 分隔线厚度
            ),
            const SizedBox(height: 10.0),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text(
                  '开始日期:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.0),
                Text(
                  '${startDate.year}-${startDate.month}-${startDate.day}',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // 显示开始日期选择器
                    showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          startDate = selectedDate;
                          int result = startDate.compareTo(endDate);
                          if(result>0){
                            endDate=selectedDate.add(Duration(days: 365));
                          }

                        });
                      }
                    });
                  },
                  child:const Text('选择开始日期'),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey, // 分隔线颜色
              thickness: 1.0,     // 分隔线厚度
            ),
            const SizedBox(height: 20.0),
        Row(
          children: [
            const Text(
              '结束日期:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10.0),
            Text(
              '${endDate.year}-${endDate.month}-${endDate.day}',
              textAlign: TextAlign.center,
              style:const TextStyle(fontSize: 20.0),
            ),

            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () {
                // 显示结束日期选择器
                showDatePicker(
                  context: context,
                  initialDate: endDate,
                  firstDate: startDate,
                  lastDate: DateTime(2100),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.blue, // 设置确认按钮的颜色
                        ),
                      ),
                      child: child!,
                    );
                  },

                ).then((selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      endDate = selectedDate;
                      int result = startDate.compareTo(endDate);
                      if(result>0){
                        startDate =selectedDate.add(const Duration(days: -365));
                      }

                    });
                  }
                });
              },
              child:const Text('选择结束日期'),
            ),
          ]),
            const Divider(
              color: Colors.grey, // 分隔线颜色
              thickness: 1.0,     // 分隔线厚度
            ),
            const SizedBox(height: 10.0,),
            ElevatedButton(
              onPressed: () async {
              if(widget.bl){
                var resulte = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_ADD_PERMISSION",
                    {"keyType":4,
                      "mac":widget.dsn,
                      "authCode":widget.authCode,
                      "dnaKey":widget.dnaKey,
                      "password":"",
                      "sdate":startDate.millisecondsSinceEpoch,
                      "edate":endDate.millisecondsSinceEpoch
                    });
                var bdate="${startDate.year}/${startDate.month}/${startDate.day} 00:00:00";
                var edate="${endDate.year}/${endDate.month}/${endDate.day} 23:59:00";
                //if(resulte["message"]!='-100'){
                //String newcode="B${resulte["message"]}";
                String newcode=int.parse(resulte["message"].toString())<10 ? "00"+resulte["message"].toString() :int.parse(resulte["message"].toString())<100 ? "0"+resulte["message"].toString() : resulte["message"].toString();
                final urlModel =
                Provider.of<Internet_msg>(context, listen: false); //获取url
                Map<String, dynamic> params = {};
                params["yhbh"] =newcode;
                params["dsn"] = widget.dsn;
                params["lx"] = "02";
                params["yhlx"] = "02";
                params["zt"] = "1";
                params["renterid"] = widget.rid;
                params["password"] = "";
                params["bdate"] = bdate;
                params["edate"] = edate;
                HttpUtil.request(
                  "${urlModel.url}/sdiRhyhb/add_yhb",
                  method: "post",
                  params: params,
                ).then((value) {
                  final urlModel =
                  Provider.of<Internet_msg>(context, listen: false); //获取url
                  Map<String, dynamic> params = {};
                  params["users"] = LoginPrefs.getToken().toString();
                  params["equipNo"] = dsn;
                  params["hid"] = widget.hid;
                  params["equipType"] = "门锁";
                  params["operationType"] = "下发";
                  params["pwdType"] = "蓝牙下发卡片(${newcode})";
                  params["operationDate"] ="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                  params["pwd"] = "";
                  params["xfly"] = "朗思APP";
                  HttpUtil.request(
                    "${urlModel.url}/operationlog/insert",
                    method: "post",
                    params: params,
                  ).then((value) {
                    Navigator.pop(context);
                  });

                });
              }else{
               if(collector==""||collector==null){
                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       title: const Row(
                         children: [
                           Icon(Icons.error,color: Colors.red,),
                           Text("错误")
                         ],
                       ),
                       content: const Text("请选择采集器"),
                       actions: [
                         TextButton(onPressed: () {
                           Navigator.of(context).pop();
                         }, child: const Text("确定")),
                       ],
                     );
                   },
                 );
               }else{

               }
      }
                },
              child: const Text('下发卡片'),
            ),
          ],
        ),
      ),
    );
  }
}

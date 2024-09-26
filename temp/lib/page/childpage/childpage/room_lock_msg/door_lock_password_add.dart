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

class DoorLockPasswordAdd extends StatefulWidget {
  final String dsn;
  final String hid;
  final String authCode;
  final String dnaKey;
  final String rid;
  final bool bl;//是否连接蓝牙

  DoorLockPasswordAdd({required this.rid,required this.dsn, required this.hid, required this.bl, required this.authCode, required this.dnaKey});
  @override
  _DoorLockPasswordAddState createState() => _DoorLockPasswordAddState();
}

class _DoorLockPasswordAddState extends State<DoorLockPasswordAdd> {
  late String dsn;
  late String lx="20";
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
    setState(() {
      password = Random().nextInt(999999).toString().padLeft(6, '0');
      passwordController.text=password;
      isLoading = false;
    });
  }
  @override
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
        title: const Text('下发密码'),
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
               Text(
                  '请输入密码:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              SizedBox(width: 10.0),
                SizedBox(width: 220,
                child:
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) {
                    if (value.length <= 6) {
                      setState(() {
                        password = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: '输入6位数字密码',
                    counterText: '', // 隐藏字符计数器
                  ),
                )
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
                        startDate =selectedDate.add(Duration(days: -365));
                      }

                    });
                  }
                });
              },
              child: Text('选择结束日期'),
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
                    {"keyType":2,
                      "mac":widget.dsn,
                      "authCode":widget.authCode,
                      "dnaKey":widget.dnaKey,
                      "password":password,
                      "sdate":startDate.millisecondsSinceEpoch,
                      "edate":endDate.millisecondsSinceEpoch
                    });
                print(resulte["message"]);
                var bdate="${startDate.year}/${startDate.month}/${startDate.day} 00:00:00";
                var edate="${endDate.year}/${endDate.month}/${endDate.day} 23:59:00";
                print(edate);
                //if(resulte["message"]!='-100'){
                //String newcode="B"+resulte["message"].toString();
                String newcode=int.parse(resulte["message"].toString())<10 ? "00"+resulte["message"].toString() :int.parse(resulte["message"].toString())<100 ? "0"+resulte["message"].toString() : resulte["message"].toString();
                final urlModel =
                Provider.of<Internet_msg>(context, listen: false); //获取url
                Map<String, dynamic> params = {};
                params["yhbh"] =newcode;
                params["dsn"] = widget.dsn;
                params["lx"] = "03";
                params["yhlx"] = "02";
                params["zt"] = "1";
                params["renterid"] = widget.rid;
                params["password"] = password;
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
                  params["equipNo"] = widget.dsn;
                  params["hid"] = widget.hid;
                  params["equipType"] = "门锁";
                  params["operationType"] = "下发";
                  params["pwdType"] = "蓝牙下发密码(${newcode})";
                  params["operationDate"] ="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                  params["pwd"] = password;
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
                setState(() {
                  isLoading = true;
                });
               LockPsw.Dropsw(widget.hid,dsn,password,widget.rid,'${startDate.year}-${startDate.month}-${startDate.day}','${endDate.year}-${endDate.month}-${endDate.day}',lx,context, () {
                 Navigator.pop(context);
                 Map<String, dynamic> params = {};
                 params["act"] = "dx_fs";
                 params["hid"] = widget.hid;
                 params["pwd"] = password;
                 params["renterNo"] = widget.rid;
                 final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
                 String url = "${urlModel.url}/apt/langsi_local";
                 HttpUtil.request(
                   url,
                   method: "post",
                   params: params,
                 ).then((value) {
                    print(value);
                 });
                 setState(() {
                   isLoading = false;
                 });
               });
      }
                },
              child: const Text('下发密码'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../../../../VO/Internet_msg.dart';
import '../../../../common/LoginPrefs.dart';
import '../../../../generated/l10n.dart';
import '../../../../method/http/httpUtil.dart';
import '../../../../method/methopchannel/flutterMethodChannel.dart';

class Doorlockfingerprint extends StatefulWidget {
  final String dsn;
  final String hid;
  final bool bl;//是否连接蓝牙
  final String authCode;
  final String dnaKey;
  final String rid;
  Doorlockfingerprint({required this.dsn,required this.rid, required this.hid, required this.bl, required this.authCode, required this.dnaKey});
  @override
  _DoorlockfingerprintState createState() => _DoorlockfingerprintState();
}

class _DoorlockfingerprintState extends State<Doorlockfingerprint> {
  late DateTime startDate = DateTime.now().add(const Duration(days: -1));
  late DateTime endDate = DateTime.now().add(const Duration(days: 3650));
  List<Map<String, String>> collectorlist = [];
  bool isLoading = false; // 添加此变量以跟踪加载状态
  List imagelist = ["fingerprint0.png", "fingerprint1.png", "fingerprint2.png", "fingerprint3.png", "fingerprint4.png"];
  int fingerprint_num = 0; //采集次数
  String collector = ""; //选择的采集器
  String _message = 'No message received';
  late S lang;
  late IOWebSocketChannel channel;

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    String langCode = LoginPrefs.getlang().toString(); // 假设 getlang() 返回正确的语言代码
    Locale locale = Locale(langCode);
    // 根据当前区域加载语言数据
    lang = await delegate.load(locale);
  }

  fingeradd() async {
    if(widget.bl){
      var resulte = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_ADD_PERMISSION",
          {"keyType":1,
            "mac":widget.dsn,
            "authCode":widget.authCode,
            "dnaKey":widget.dnaKey,
            "password":null,
            "sdate":startDate.millisecondsSinceEpoch,
            "edate":endDate.millisecondsSinceEpoch
          });
      print(resulte["message"]);
            var bdate="${startDate.year}/${startDate.month}/${startDate.day} 00:00:00";
            var edate="${endDate.year}/${endDate.month}/${endDate.day} 23:59:00";
           print(edate);
            //if(resulte["message"]!='-100'){
      String newcode=int.parse(resulte["message"].toString())<10 ? "00"+resulte["message"].toString() :int.parse(resulte["message"].toString())<100 ? "0"+resulte["message"].toString() : resulte["message"].toString();
      //String newcode=int.parse(resulte["message"].toString())<10 ? "B"+resulte["message"].toString() :int.parse(resulte["message"].toString())<100 ? "B"+resulte["message"].toString() : "B"+resulte["message"].toString();
      final urlModel =
            Provider.of<Internet_msg>(context, listen: false); //获取url
            Map<String, dynamic> params = {};
            params["yhbh"] =newcode;
            params["dsn"] = widget.dsn;
            params["lx"] = "01";
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
              params["equipNo"] = widget.dsn;
              params["hid"] = widget.hid;
              params["equipType"] = "门锁";
              params["operationType"] = "下发";
              params["pwdType"] = "蓝牙下发指纹(${newcode})";
              params["operationDate"] ="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
              params["pwd"] = "";
              params["xfly"] = "朗思APP";
              HttpUtil.request(
                "${urlModel.url}/operationlog/insert",
                method: "post",
                params: params,
              ).then((value) {
                Navigator.pop(context, "蓝牙断开");
              });

            });
      //      }else{

      // }

    }else{
      //添加指纹
      //使用websocket
      channel = IOWebSocketChannel.connect('wss://langsi.com.cn:7500/webSocket');
      if (collector == "") {
        return;
      }
      channel.sink.add(collector);
      channel.stream.listen((message) {
        Map<String, dynamic> _message = json.decode(message);
        print(message);
        if (double.tryParse(_message["data"].toString()) == null) {
          if (mounted) {
            setState(() {
              print(_message);
              fingerprint_num = _message["data"]["indexNum"] * 1;
              if (_message["data"]["indexNum"] * 1 == 4) {
                //{ "ac":"lockauth","partnerid":"hongqi","deviceid":this.msxx.equip_no,"userdata":characteristic.data.fingerPrint,"usertype":"02","begindate":Stime2,"enddate":Etime2,"channel":"2","type":"01"}
                Map<String, dynamic> params = {};
                params["act"] = "langsi_Get_fingerprints";
                params["eqnumber"] = collector;
                params["url"] = "https://139.9.182.161:7500";
                final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
                String url = "${urlModel.url}/apt/langsi_Get_fingerprints";
                HttpUtil.request(
                  url,
                  method: "post",
                  params: params,
                ).then((value) {
                  print("指纹采集完成");
                  setState(() {
                    isLoading = true; // 开始加载
                  });
                  print(_message["data"]["fingerPrint"]);
                  Dio dio = new Dio();
                  Map<String, dynamic> params2 = {};
                  params2["ac"] = "lockauth";
                  params2["partnerid"] = "hongqi";
                  params2["deviceid"] = widget.dsn;
                  params2["userdata"] = _message["data"]["fingerPrint"];
                  params2["usertype"] = "02";
                  params2["begindate"] = "${startDate.year}-${startDate.month}-${startDate.day}";
                  params2["enddate"] = "${endDate.year}-${endDate.month}-${endDate.day}";
                  params2["channel"] = "2";
                  params2["type"] = "01";
                  // String url2 = "http://aiot.langsi.com.cn/api/lock/tx_add_user";
                  String url2 = "http://192.168.1.111/api/v1/lock/tx_add_user";
                  HttpUtil.request(url2, method: "post", params: params2).then((value) {
                    channel.sink.close();
                    setState(() {
                      isLoading = false; // 开始加载
                    });
                    fingerprint_num = 0;
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                  //{ "ac":"lockauth","partnerid":"hongqi","deviceid":this.msxx.equip_no,"userdata":_message["data"]["fingerPrint"],"usertype":"02","begindate":Stime2,"enddate":Etime2,"channel":"2","type":"01"}

                });
              }
            });
          }
        } else if (_message["data"] * 1 == -1) {
          //当前设备使用中
        } else if (_message["data"] * 1 == 1) {
          Map<String, dynamic> params = {};
          params["act"] = "langsi_Get_fingerprints";
          params["eqnumber"] = collector;
          params["url"] = "https://139.9.182.161:7500";
          final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
          String url = "${urlModel.url}/apt/langsi_Get_fingerprints";
          HttpUtil.request(
            url,
            method: "post",
            params: params,
          ).then((value) {
            print(value);
          });
        }
      });
    }

  }

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

  @override
  void initState() {
    print(widget.bl);
    super.initState();
    _updateLang();
    sel_cj();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('下发指纹'),
      ),
      body: Center(
        child:
        isLoading
            ? Center(child: CircularProgressIndicator()):
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 100.0,
                        child: Text(
                          '开始日期:',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(width: 10.0),
                    Text(
                      '${startDate.year}-${startDate.month}-${startDate.day}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(width: 40.0),
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
                              if (result > 0) {
                                endDate = selectedDate.add(Duration(days: 365));
                              }
                            });
                          }
                        });
                      },
                      child: const Text('选择开始日期'),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey, // 分隔线颜色
                  thickness: 1.0, // 分隔线厚度
                ),
                const SizedBox(height: 20.0),
                Row(children: [
                  SizedBox(
                      width: 100.0,
                      child: Text(
                        '结束日期:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(width: 10.0),
                  Text(
                    '${endDate.year}-${endDate.month}-${endDate.day}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(width: 40.0),
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
                            if (result > 0) {
                              startDate = selectedDate.add(Duration(days: -365));
                            }
                          });
                        }
                      });
                    },
                    child: Text('选择结束日期'),
                  ),
                ]),
              ],
            ),
            const Divider(
              color: Colors.grey, // 分隔线颜色
              thickness: 1.0, // 分隔线厚度
            ),
            widget.bl?Text("Null"):
            Row(
              children: [
                const SizedBox(
                    width: 100.0,
                    child: Text(
                      '指纹采集器:',
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
              thickness: 1.0, // 分隔线厚度
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                "images/${imagelist[fingerprint_num]}",
                fit: BoxFit.contain,
              ),
            ),
            const Divider(
              color: Colors.grey, // 分隔线颜色
              thickness: 1.0, // 分隔线厚度
            ),
            SizedBox(
                width: 200.0,
                child: ElevatedButton(
                    onPressed: () {
                      fingeradd();
                    },
                    child: const Text(
                      "指纹采集",
                      style: TextStyle(fontSize: 20.0),
                    )))
          ],
        ),
      ),
    );
  }
}

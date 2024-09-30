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

class DoorLockPasswordDistList extends StatefulWidget {
  final String dsn;
  final String hid;
  final bool bl;//是否连接蓝牙
  final String authCode;
  final String dnaKey;
  final String rid;
  DoorLockPasswordDistList({required this.dsn,required this.rid, required this.hid, required this.bl, required this.authCode, required this.dnaKey});

  @override
  _DoorLockPasswordDistListState createState() => _DoorLockPasswordDistListState();
}

class _DoorLockPasswordDistListState extends State<DoorLockPasswordDistList> {
  List<dynamic> pswlist = [];
  String lx="";
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    getlocklx(widget.dsn);
    getpswlist(widget.dsn);
  }
  void del_psw(String yhbh,String psw){
    final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
    Map<String, dynamic> params = {};
    params["yhbh"] =yhbh;
    params["dsn"] = widget.dsn;
    HttpUtil.request(
      "${urlModel.url}/sdiRhyhb/del_yhb",
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
            content: const Text("操作成功"),
            actions: [
              TextButton(onPressed: () {
                if (mounted){
                  getpswlist(widget.dsn);
                }
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
    });
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
  void getpswlist(String dsn) async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":dsn,"rid":widget.rid});
    print("RID");
    print(widget.rid);
    String url = "${urlModel.url}/lockoperater/getPswList";
    Response response = await dio.post(url, data: formData);
    var result = response.data;
    print("111ren");
    print(result);
   if(result==null){
     setState(() {
       pswlist=[];
     });
   }else{
     setState(() {
       pswlist=result["data"];
     });
   }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('权限列表'),
      ),
      body:
      isLoading
          ? Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: pswlist.length,
            itemBuilder: (context, index) {
              final item = pswlist[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_circle,size: 50,color: Colors.indigo,),
                          SizedBox(width:30.0),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 130.0,
                                    height: 30,
                                    child: Text('权限编号: ${item["yhbh"]}', style: TextStyle(fontSize: 10),),
                                  ),
                                  SizedBox(
                                    width: 130.0,
                                    height: 30,
                                    child: Text("权限类型: ${item["lx"]=='03'? "密码": item["lx"]=='01' ? "指纹":"卡片"}", style: TextStyle(fontSize: 10),),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 130.0,
                                    height: 30,
                                    child: Text("权限内容:${item["password"]}", style: TextStyle(fontSize: 10),),
                                  ),
                                  SizedBox(
                                    width: 130.0,
                                    height: 30,
                                    child: Text("权限状态:${item["ztmc"]}", style: TextStyle(fontSize: 10),),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 130.0,
                                    height: 30,
                                    child: Text("用户类型:${item["yhlxmc"]}", style: TextStyle(fontSize: 10),),
                                  ),
                                  SizedBox(
                                    width: 130.0,
                                    height: 30,
                                    child: Text("权限用户:${item["yhname"]}", style: TextStyle(fontSize: 10),),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 260.0,
                                    height: 30,
                                    child: Text("时间期限:${item["kssj"]}至${item["jssj"]}", style: TextStyle(fontSize: 10),),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      BuildContext con=  context;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.info,color: Colors.orange,),
                                                Text("提示")
                                              ],
                                            ),
                                            content: const Text("是否删除此权限"),
                                            actions: [
                                              TextButton(onPressed: () async {
                                                //Navigator.of(context).pop();
                                                if(widget.bl){//如果连接蓝牙
                                                    if(1==3){
                                                   // if(item["yhbh"]==null || item["yhbh"].indexOf("B")<0){
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                    return AlertDialog(
                                                    title: const Row(
                                                    children: [
                                                    Icon(Icons.error,color: Colors.red,),
                                                    Text("警告")
                                                    ],
                                                    ),
                                                    content: const Text("此权限无法使用蓝牙删除"),
                                                    actions: [
                                                    TextButton(onPressed: () {
                                                    Navigator.of(context).pop();
                                                    },child: const Text("确定")),]);});
                                                    }else{
                                                      print( {"keyType":1,
                                                        "type":item["lx"],
                                                        "userid":item["yhbh"],
                                                        "mac":widget.dsn,
                                                        "authCode":widget.authCode,
                                                        "dnaKey":widget.dnaKey,
                                                      });
                                                      var resulte = await FlutterMethodChannel.invokeNativeMethod("BLUELIST_DELETEPW",
                                                          {"keyType":1,
                                                            "type":item["lx"],
                                                            "userid":item["yhbh"],
                                                            "mac":widget.dsn,
                                                            "authCode":widget.authCode,
                                                            "dnaKey":widget.dnaKey,
                                                          });
                                                      print("数据是：：");
                                                      print(resulte["message"]);
                                                      Navigator.of(context).pop();
                                                      if(resulte["message"]=="1"){
                                                        del_psw(item["yhbh"],item["password"]);
                                                      }else{
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: const Row(
                                                                children: [
                                                                  Icon(Icons.info,color: Colors.redAccent,),
                                                                  Text("提示")
                                                                ],
                                                              ),
                                                              content: const Text("删除失败"),
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

                                                }
                                                else{
                                                  setState(() {
                                                    isLoading=true;
                                                  });

                                                LockPsw.Delpsw(widget.dsn, widget.hid,lx, item["yhbh"], item["lx"], con, (){
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    isLoading=false;
                                                  });
                                                  getpswlist(widget.dsn);
                                                });
                                                }

                                              }, child: const Text("确定")),
                                              TextButton(onPressed: () {
                                                Navigator.of(context).pop();
                                              }, child: const Text("取消")),
                                            ],
                                          );
                                        },
                                      );

                                    },
                                    child: const Text("删除", style: TextStyle(fontSize: 10),),
                                  ),
                                  const SizedBox(width: 10.0,),
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context,

                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.info,color: Colors.orange,),
                                                Text("提示")
                                              ],
                                            ),
                                            content: const Text("是否冻结此权限"),
                                            actions: [
                                              TextButton(onPressed: () async {
                                                if(widget.bl){//如果连接蓝牙
                                                  if(item["yhbh"]==null || item["yhbh"].indexOf("B")<0){
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                              title: const Row(
                                                                children: [
                                                                  Icon(Icons.error,color: Colors.red,),
                                                                  Text("警告")
                                                                ],
                                                              ),
                                                              content: const Text("此权限无法使用蓝牙冻结"),
                                                              actions: [
                                                                TextButton(onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },child: const Text("确定")),]);});
                                                  }else{
                                                    //Navigator.of(context).pop();
                                                    freeze(item["lx"],item["yhbh"],0);
                                                  }

                                                }
                                                else{
                                                  LockPsw.freezepsw(widget.dsn, lx, item["yhbh"], item["lx"], context, (){
                                                    Navigator.of(context).pop();
                                                    getpswlist(widget.dsn);
                                                  });
                                                }


                                                }, child: const Text("确定")),
                                              TextButton(onPressed: () {
                                                Navigator.of(context).pop();
                                              }, child: const Text("取消")),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text("冻结", style: TextStyle(fontSize: 10),),
                                  ),
                                  const SizedBox(width: 10.0,),
                                  ElevatedButton(
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.info,color: Colors.orange,),
                                                Text("提示")
                                              ],
                                            ),
                                            content: const Text("是否解冻此权限"),
                                            actions: [
                                              TextButton(onPressed: () {
                                                if(widget.bl){//如果连接蓝牙
                                                  if(item["yhbh"]==null || item["yhbh"].indexOf("B")<0){
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                              title: const Row(
                                                                children: [
                                                                  Icon(Icons.error,color: Colors.red,),
                                                                  Text("警告")
                                                                ],
                                                              ),
                                                              content: const Text("此权限无法使用蓝牙解冻"),
                                                              actions: [
                                                                TextButton(onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },child: const Text("确定")),]);});
                                                  }else{
                                                    //Navigator.of(context).pop();
                                                    freeze(item["lx"],item["yhbh"],1);
                                                  }

                                                }else{
                                                  LockPsw.outfreezepsw(widget.dsn, lx, item["yhbh"], item["lx"], context, (){
                                                    Navigator.of(context).pop();
                                                    getpswlist(widget.dsn);
                                                  });
                                                }
                                              }, child: const Text("确定")),
                                              TextButton(onPressed: () {
                                                Navigator.of(context).pop();
                                              }, child: const Text("取消")),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text("解冻", style: TextStyle(fontSize: 10),),
                                  ),
                                ],
                              )
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

  Future<void> freeze(String lx,String yhbh,int i) async {

    var resulte = await FlutterMethodChannel.invokeNativeMethod("BLUELIST_FREEZE",
        {"keyType":1,
          "type":lx,
          "userid":yhbh,
          "far":i.toString(),
          "mac":widget.dsn,
          "authCode":widget.authCode,
          "dnaKey":widget.dnaKey,
        });
    Navigator.of(context).pop();
    if(resulte["message"]=="1"){
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
            content: const Text("操作成功"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
      // del_psw(item["yhbh"]);
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info,color: Colors.redAccent,),
                Text("提示")
              ],
            ),
            content: const Text("操作失败"),
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
}

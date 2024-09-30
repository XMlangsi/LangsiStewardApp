import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langsisiswn/page/childpage/childpage/room_lock_msg/door_lock_accredituser.dart';
import 'package:langsisiswn/page/childpage/childpage/room_lock_msg/door_lock_card.dart';
import '../../../common/lock_psw.dart';
import '../../../method/methopchannel/flutterMethodChannel.dart';
import 'package:langsisiswn/page/childpage/childpage/room_lock_msg/door_lock_fingerprint.dart';
import 'package:langsisiswn/page/childpage/childpage/room_lock_msg/door_lock_information.dart';
import 'package:langsisiswn/page/childpage/childpage/room_lock_msg/door_lock_password_add.dart';
import 'package:langsisiswn/page/childpage/childpage/room_lock_msg/door_lock_passwordlist.dart';
import 'package:provider/provider.dart';

import '../../../VO/Internet_msg.dart';
import '../../../common/LoginPrefs.dart';
import '../../../generated/l10n.dart';
import '../../../method/http/httpUtil.dart';
import 'package:permission_handler/permission_handler.dart';
class AssociatedApparatus extends StatefulWidget{
  final String hid;
  final String rid;

  AssociatedApparatus({required this.hid,required this.rid});
  @override
  _AssociatedApparatusState createState() => _AssociatedApparatusState();
}
class _AssociatedApparatusState extends State<AssociatedApparatus> {
  late String hidValue; // 声明hidValue变量
  List<dynamic> pswlist = [];//密码列表
  late String e_name=""; //门锁名称
  late String e_no="";//门锁编号
  late String lockid="";
  late String authCode="";
  late String dnaKey="";
  bool bule_link=false;//蓝牙是否连接
  void getpswlist(String dsn) async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":dsn,"rid":widget.rid});
    String url = "${urlModel.url}/lockoperater/getPswList";
    Response response = await dio.post(url, data: formData);
    var result = response.data;
    if(result==null){
      result["data"]=[];
    }
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
  void initState() {
    super.initState();
    setMethodHandle();
    // 在initState方法中初始化hidValue变量
    hidValue = widget.hid;
    _updateLang();
    getlockmsg();
    checkPermission();

  }
  late S lang;
  void testButtonTouched() {
    invokeNativeMethod();
  }
  void lockremerkopen() {

    //sleep(Duration(seconds: 3));
    lockremerk(0);//开启
  }
  void lockremerk(int num){//还原
    print("pswlist");
    print(pswlist);

    if(num<pswlist.length) {
      DateTime startDate = DateTime.parse(pswlist[num]["kssj"]);
      DateTime endDate = DateTime.parse(pswlist[num]["jssj"]);
      var days = endDate.difference(startDate).inDays;
      var stime="";
      var endtime="";
      if(days>3650) {
        stime='${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
        endtime='${DateTime.now().year+10}-${DateTime.now().month}-${DateTime.now().day-2}';
      }else{
        stime=pswlist[num]["kssj"];
        endtime=pswlist[num]["jssj"];
      }
      if(pswlist[num]["userdata"] == ""&& pswlist[num]["password"]=="") {
        lockremerk(num+1);
        return;
      }
      //LockPsw.Dropsw2(pswlist[num]["renterid"],e_no,pswlist[num]["password"],pswlist[num]["userdate"],pswlist[num]["lx"],stime,endtime,"22",context, () {});
      Map<String, dynamic> params = {};
      params["ac"] = "lockauth";
      params["partnerid"] = "hongqi";
      params["deviceid"] = e_no;
      params["password"] = pswlist[num]["password"];
      params["usertype"] = "01";
      params["begindate"] = stime;
      params["async"] = 1;
      params["enddate"] = endtime;
      params["channel"] = "2";
      params["userdata"] = pswlist[num]["userdata"];
      params["type"] =pswlist[num]["lx"];
      print(params);
      print("http://192.168.1.111/api/v1/lock/tx_add_user");
      HttpUtil.request(
        "http://192.168.1.111/api/v1/lock/tx_add_user",
        // "http://aiot.langsi.com.cn/api/lock/tx_add_user",
        method: "post",
        params: params,
      ).then((value) {
        print(value["code"]);
        if (value["code"] != 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red,),
                    Text("警告")
                  ],
                ),
                content: Text("失败：${value["message"]}"),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                    lockremerk(num);
                  }, child: const Text("重试")),
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                    lockremerk(num+1);
                  }, child: const Text("取消")),
                ],
              );
            },
          );
        } else {
          if(pswlist[num]["renterid"]!=""&&pswlist[num]["renterid"]!=null){
            print("renterid"+pswlist[num]["renterid"]);
            final urlModel =
            Provider.of<Internet_msg>(context, listen: false); //获取url
            Map<String, dynamic> params = {};
            params["dsn"] = e_no;
            params["rid"] =pswlist[num]["renterid"];
            HttpUtil.request(
              "${urlModel.url}/sdiRhyhb/up_yhb",
              method: "post",
              params: params,
            ).then((value) {
              lockremerk(num + 1);
            });
          }else{
            Future.delayed(Duration(milliseconds: 10000), () {
              // 延迟执行的代码
              lockremerk(num + 1);
            });


          }

        }
      })
      .catchError((e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red,),
                  Text("警告")
                ],
              ),
              content: Text("失败：请求服务失败"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  lockremerk(num);
                }, child: const Text("重试")),
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  lockremerk(num+1);
                }, child: const Text("取消")),
              ],
            );
          },
        );
    });
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.supervised_user_circle, color: Colors.blueAccent,),
                Text("成功")
              ],
            ),
            content: Text("还原完毕"),
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
  Future<void> setDoorLockInformation(String dsn) async {//查找该门锁基本信息
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":dsn});
    String url = "${urlModel.url}/sdiRhSbb/lockinfo";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
      Map<String, dynamic> lockinfo=result["data"][0];
      dnaKey=lockinfo["aeskey"];
      authCode=lockinfo["adminauthcode"];
  }
  //判断是否有权限
  void checkPermission() async {
    Permission permission = Permission.location;
    PermissionStatus status = await permission.status;
    print('检测权限$status');
    if (status.isGranted) {
      //权限通过
    } else if (status.isDenied) {
      //权限拒绝， 需要区分IOS和Android，二者不一样
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      //权限永久拒绝，且不在提示，需要进入设置界面
      //openAppSettings();
    } else if (status.isRestricted) {
      //活动限制（例如，设置了家长///控件，仅在iOS以上受支持。
     // openAppSettings();
    } else {
      //第一次申请
      requestPermission(permission);
    }
  }
//申请权限
  void requestPermission(Permission permission) async {
    var state = await Permission.locationAlways.status;
    PermissionStatus status = await permission.request();
    // print('权限状态$status');
    // if (!status.isGranted) {
    //   openAppSettings();
    // }
  }
  void _navigateAndDoSomething() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Doorlockfingerprint(
        rid: widget.rid,
        dsn: e_no,
        hid: hidValue,
        bl: bule_link,
        authCode: authCode,
        dnaKey: dnaKey,
      )),
    );

    // 在这里对 result 进行处理
    if (result != null) {
      // var result = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_OUT_LINK");
      // // 对父页面进行操作
      // setState(() {
      //   bule_link=false;
      //
      // });

      print("Received data: $result");
    }
  }

  void requestBluetoothScanPermission() async {

    var status = await Permission.bluetoothScan.status;
    if (!status.isGranted) {
       await Permission.bluetoothConnect.request();
       await Permission.bluetoothScan.request();
    }
  }

  Future<void> invokeNativeMethod() async {

    if(bule_link){
      print("out");
      var result = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_OUT_LINK");
      print(result.toString());
      // 对父页面进行操作
      setState(() {
        bule_link=false;

      });
    }else{
      print(await Permission.bluetoothScan.status);

      requestBluetoothScanPermission();
      var status = await Permission.bluetoothScan.status;
      if (status.isGranted) {
        var result = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_CONNECTION", {"mac":e_no});
        print(result.toString());
        if(result["message"]=="true"){
          setState(() {
            bule_link=true;
          });

        }else{
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
                content: const Text("未查找到对应设备"),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("确定")),
                ],
              );
            },
          );
          setState(() {
            bule_link=false;
          });
        }
      }
    }
    // var result = await FlutterMethodChannel.invokeNativeMethod("methodTest", {"param": "params from flutter"});
    // print("invokeNativeMethod result:${result.toString()}");

  }

  void setMethodHandle() {
    FlutterMethodChannel.methodHandlerListener((call) {
      print("methodHandlerListener call:${call.toString()}");
      if (call.method == "methodToFlutter") {
        print("methodToFlutter arg:${call.arguments}");
      }
      return Future.value("message from flutter");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    String langCode = LoginPrefs.getlang().toString(); // 假设 getlang() 返回正确的语言代码
    Locale locale = Locale(langCode);
    // 根据当前区域加载语言数据

    lang = await delegate.load(locale);
  }
  void accredituser() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DoorLockAccredituser(hid: widget.hid)),
    );
  }
  void getlockmsg() {
    Map<String, dynamic> params = {};
    params["hid"] = hidValue;
    params["lx"] = "ms";
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    HttpUtil.request(
      "${urlModel.url}/housed/get_room_lock",
      method: "post",
      params: params,
    ).then((value) {
      setState(() {
        if(value["code"]==0){
          if(value["data"].length!=0){
            e_name=value["data"][0]["equipName"];
            e_no=value["data"][0]["equipNo"];
            getpswlist(e_no);
            setDoorLockInformation(e_no);
          }else{
            e_name=lang.unlock;
            e_no="无";
          }
        }
      });

      return false;
    });
  }
  @override
  Widget build(BuildContext context) {
    /// 界面框架
    return Scaffold(
      appBar: AppBar(
        title: const Text("设备关联"),
      ),
      body: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/top1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.bluetooth_audio_outlined),
                      iconSize: 80.0,
                      color: bule_link?  Colors.indigo : Colors.grey,
                      onPressed: () {
                        invokeNativeMethod();
                      },
                    ),
                    Text(
                      e_name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width / 4,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    indexBox(context, lang.lock_password_list, "images/dom_list.png",pswList),
                    bule_link ?indexBox(context, lang.bluopendoor, "images/dom_opendoor.png",opendoor) : indexBox(context, lang.remote_door, "images/dom_opendoor.png",opendoor),
                    indexBox(context, lang.set_Time, "images/dom_chtime.png",nu),
                    indexBox(context, lang.lock_information, "images/dom_evelock.png",lockInfo),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width / 4,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    indexBox(context, lang.add_lock_password, "images/dom_psw.png",addpasw),
                    indexBox(context, lang.add_card, "images/dom_card.png",addcard),
                    indexBox(context, lang.add_fingerprint, "images/dom_fingerprint.png",addFingerprint),
                    indexBox(context, lang.temporary_password, "images/dom_ls.png",one_psw),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width / 4,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    widget.rid!="" ? Text("") :
                    indexBox(context, lang.accredit, "images/dom_acc.png",accredituser),
                  ],
                ),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.width / 4,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       indexBox(context, "还原", "images/dom_list.png",lockremerkopen),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
  void addFingerprint(){//进入指纹采集页
    if(e_no=="无") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.dangerous, color: Colors.red,),
                Text("警告")
              ],
            ),
            content: const Text("未绑定门锁"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
      return;
    }else if(bule_link==false){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.dangerous, color: Colors.red,),
                Text("警告")
              ],
            ),
            content: const Text("蓝牙未连接"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
      return;
    }else{
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Doorlockfingerprint(dsn: e_no  ?? "",hid:hidValue,bl:bule_link,authCode:authCode,dnaKey:dnaKey)),
      // );
      _navigateAndDoSomething();
      }
  }
  Future<void> opendoor() async {
    if(bule_link){//如果已经连上了蓝牙
      var result = await FlutterMethodChannel.invokeNativeMethod("BLUETOOTH_OPENDOOR", {"mac":e_no,"authCode":authCode,"dnaKey":dnaKey});
      print(result.toString());
    }else{

    }
  }
  void pswList(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DoorLockPasswordDistList(
        rid: widget.rid,
        dsn: e_no,
        hid: hidValue,
        bl: bule_link,
        authCode: authCode,
        dnaKey: dnaKey,
      )),
    );
  }
  Future<void> one_psw() async {
    String lx="213";
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"dsn":e_no});
    String url = "${urlModel.url}/housed/get-room-lock-msgs";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    lx=result["data"][0]["lx"];
    setState(() {});
    if(lx=="21"||lx=="20"){
      Map<String, dynamic> params = {};
      params["ac"] = "temppassword";
      params["partnerid"] = "hongqi";
      params["deviceid"] = e_no;
      params["channel"] = "2";
      params["type"] = "03";
      HttpUtil.request(
        "http://aiot.langsi.com.cn/api/lock/tx_otp",
        method: "post",
        params: params,
      ).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.sentiment_very_satisfied_outlined,color: Colors.green,),
                  Text("恭喜")
                ],
              ),
              content:  Text("临时密码为:${value['data']['password']}"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: const Text("确定")),
              ],
            );
          },
        );
      });
    }
  }
  void lockInfo(){
    if(e_no=="无"){
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
            content: const Text("未绑定门锁"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
      return;

    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoorLockInformation(dsn: e_no  ?? "")),
      );}
  }
  void addpasw(){
    if(e_no=="无"){
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
            content: const Text("未绑定门锁"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
      return;

    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoorLockPasswordAdd(
          rid: widget.rid,
          dsn: e_no,
          hid: hidValue,
          bl: bule_link,
          authCode: authCode,
          dnaKey: dnaKey,
        )),
      );}
  }
  void addcard(){
    if(e_no=="无"){
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
            content: const Text("未绑定门锁"),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: const Text("确定")),
            ],
          );
        },
      );
      return;

    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoorLockCard(
          rid: widget.rid,
          dsn: e_no,
          hid: hidValue,
          bl: bule_link,
          authCode: authCode,
          dnaKey: dnaKey,
        )),
      );}
  }
  void nu(){
    print("1111");
  }
  Widget indexBox(BuildContext context, String text, String img,void function()) {
    return
      Container(
          width: MediaQuery.of(context).size.width /4,
          child:
          LayoutBuilder(
              builder: (context, constraints) {
                return
                  CupertinoButton(
                    onPressed: () { function();},
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image(image: AssetImage(img)),
                          ),
                          Text(
                            text,
                            textAlign:TextAlign.center,style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );

              }
          ));


  }
}

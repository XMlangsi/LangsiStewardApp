import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../VO/Internet_msg.dart';
import '../method/http/httpUtil.dart';
import 'LoginPrefs.dart';

class LockPsw{

  static void outfreezepsw(String dsn, String lx, String yhbh, String plx, BuildContext context, Function() selpasw) {
    if (lx == "21" || lx == "20") {
      Map<String, dynamic> params = {};
      params["ac"] = "tx_unfrozen_user";
      params["partnerid"] = "hongqi";
      params["deviceid"] = dsn;
      params["lx"] = plx;
      params["op"] = "00";
      params["passwordid"] = yhbh;
      params["usertype"] = "02";
      params["channel"] = "21";

      HttpUtil.request(
        "http://aiot.langsi.com.cn/api/lock/tx_frozen_user",
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
              content: const Text("解除冻结成功！！！！"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  selpasw();
                }, child: const Text("确定")),
              ],
            );
          },
        );
        return true;
      });
    } else {
      // 处理 lx 不是 "21" 或 "20" 的情况
    }
  }

  static void freezepsw(String dsn, String lx, String yhbh, String plx, BuildContext context, Function() selpasw) {
    if (lx == "21" || lx == "20" || lx == "22") {
      Map<String, dynamic> params = {};
      params["ac"] = "frozen_user";
      params["partnerid"] = "hongqi";
      params["deviceid"] = dsn;
      params["lx"] = plx;
      params["op"] = "01";
      params["passwordid"] = yhbh;
      params["usertype"] = "02";
      params["channel"] = "21";

      HttpUtil.request(
        "http://aiot.langsi.com.cn/api/lock/tx_frozen_user",
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
              content: const Text("冻结成功！！！！"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  selpasw();
                }, child: const Text("确定")),
              ],
            );
          },
        );
        return true;
      });
    } else {
      // 处理 lx 不是 "21" 或 "20" 的情况
    }
  }

  static void Delpsw(String dsn, String hid, String lx, String yhbh, String plx, BuildContext context, Function() selpasw) {
    if (lx == "21" || lx == "20") {
      Map<String, dynamic> params = {};
      params["ac"] = "deletepassword";
      params["partnerid"] = "hongqi";
      params["deviceid"] = dsn;
      params["lx"] = plx;
      params["passwordid"] = yhbh;
      params["usertype"] = "02";
      params["channel"] = "2";

      HttpUtil.request(

        "http://192.168.1.111/api/v1/lock/tx_del_user",
       // "http://aiot.langsi.com.cn/api/lock/tx_del_user",
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
        params["pwdType"] = "普通用户(${yhbh})";
        params["equipNo"] = dsn;
        params["operationDate"] ="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
        params["pwd"] = "";
        params["xfly"] = "朗思APP";
        HttpUtil.request(
          "${urlModel.url}/operationlog/insert",
          method: "post",
          params: params,
        ).then((value) {});
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
              content: const Text("删除成功！！！！"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  selpasw();
                }, child: const Text("确定")),
              ],
            );
          },
        );
        return true;
      });
    } else {
      // 处理 lx 不是 "21" 或 "20" 的情况
    }
  }

  static void Dropsw(String hid,String dsn,String psw,String rid, String sdate, String edate, String lx,BuildContext context,Function() callback) {//下发密码
    if(lx=="21"||lx=="20" || lx=="22"){
    Map<String, dynamic> params = {};
    params["ac"] = "lockauth";
    params["partnerid"] = "hongqi";
    params["deviceid"] = dsn;
    params["password"] = psw;
    params["usertype"] = "02";
    params["begindate"] = sdate;
    params["enddate"] = edate;
    params["channel"] = "2";
    params["type"] = "03";
   // print("http://192.168.1.111/api/v1/lock/tx_add_user");
    HttpUtil.request(
      "http://192.168.1.111/api/v1/lock/tx_add_user",
     // "http://aiot.langsi.com.cn/api/lock/tx_add_user",
      method: "post",
      params: params,
    ).then((value) {
      print(value["code"]);
      if(value["code"]!=0){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.error_outline,color: Colors.red,),
                  Text("警告")
                ],
              ),
              content: Text("失败：${value["message"]}"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  callback();
                }, child: const Text("确定")),
              ],
            );
          },
        );
      }else{
        final urlModel =
        Provider.of<Internet_msg>(context, listen: false); //获取url
        Map<String, dynamic> params = {};
        params["users"] = LoginPrefs.getToken().toString();
        params["equipNo"] = dsn;
        params["hid"] = hid;
        params["equipType"] = "门锁";
        params["operationType"] = "下发";
        params["pwdType"] = "普通用户";
        params["equipNo"] = dsn;
        params["operationDate"] ="${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
        params["pwd"] = psw;
        params["xfly"] = "朗思APP";
        HttpUtil.request(
          "${urlModel.url}/operationlog/insert",
          method: "post",
          params: params,
        ).then((value) {});
        Update_psw_rid(dsn,context,rid);
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
              content: const Text("下发成功"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                  callback();
                }, child: const Text("确定")),
              ],
            );
          },
        );
      }

      return true;
    });
    }else{

    }
  }
  static void Update_psw_rid(String dsn,BuildContext context,String rid){
    final urlModel =
    Provider.of<Internet_msg>(context, listen: false); //获取url
    Map<String, dynamic> params = {};
    params["dsn"] = dsn.toString();
    params["yhbh"] = rid;
    HttpUtil.request(
      "${urlModel.url}/sdiRhyhb/up_yhb",
      method: "post",
      params: params,
    ).then((value) {});
  }
  // static String Dropsw2(String rid,String dsn,String usedate,String usertype,String psw, String sdate, String edate, String lx,BuildContext context,Function() callback) {//还原密码
  //   if(lx=="21"||lx=="20" || lx=="22"){
  //     Map<String, dynamic> params = {};
  //     params["ac"] = "lockauth";
  //     params["partnerid"] = "hongqi";
  //     params["deviceid"] = dsn;
  //     params["password"] = psw;
  //     params["usertype"] = usertype;
  //     params["begindate"] = sdate;
  //     params["enddate"] = edate;
  //     params["channel"] = "2";
  //     params["usedate"] =usedate;
  //     params["type"] = "03";
  //     print("http://192.168.1.111/api/v1/lock/tx_add_user");
  //     HttpUtil.request(
  //       "http://192.168.1.111/api/v1/lock/tx_add_user",
  //       // "http://aiot.langsi.com.cn/api/lock/tx_add_user",
  //       method: "post",
  //       params: params,
  //     ).then((value) {
  //       print(value["code"]);
  //       if(value["code"]!=0){
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Row(
  //                 children: [
  //                   Icon(Icons.error_outline,color: Colors.red,),
  //                   Text("警告")
  //                 ],
  //               ),
  //               content: Text("失败：${value["message"]}"),
  //               actions: [
  //                 TextButton(onPressed: () {
  //                   Navigator.of(context).pop();
  //                   return "重试";
  //                 }, child: const Text("重试")),
  //                 TextButton(onPressed: () {
  //                   Navigator.of(context).pop();
  //                   return "取消";
  //                 }, child: const Text("取消")),
  //               ],
  //             );
  //           },
  //         );
  //       }else{
  //         return "成功";
  //       }
  //
  //       return true;
  //     });
  //   }else{
  //
  //   }
  // }

}
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

class EasyCheckIn extends StatefulWidget {
  final String hid;

  EasyCheckIn({required this.hid});
  @override
  _EasyCheckInState createState() => _EasyCheckInState();
}

class _EasyCheckInState extends State<EasyCheckIn> {
  late String dsn;
  late String lx="20";
  late String name = "";
  late String idNumber = "";
  late String Tel = "";
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now().add(const Duration(days: 3650)); // 默认：当前时间加1天
  TextEditingController manController = TextEditingController();
  TextEditingController TelController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();

  bool isLoading =false;
  @override
  void initState() {
  }
  void toAssociatedApparatus() {
    Navigator.of(context).pop();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           AssociatedApparatus(hid: widget.hid,rid: ""),
    //     ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('简单入住'),
      ),
      body:
      isLoading
          ?
      const Center(
          child: CircularProgressIndicator())
          :
      ListView(children:[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    '租客姓名:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(width: 220,
                      child:
                      TextField(
                        controller: manController,
                        keyboardType: TextInputType.text,
                        maxLength: 116,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });

                        },
                        decoration: const InputDecoration(
                          hintText: '输入入住人姓名',
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
              Row(
                children: [
                  Text(
                    '电话号码:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(width: 220,
                      child:
                      TextField(
                        controller: TelController,
                        keyboardType: TextInputType.number,
                        maxLength: 18,
                        onChanged: (value) {
                          if (value.length <= 18) {
                            setState(() {
                              Tel = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: '输入入住人电话',
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
              Row(
                children: [
                  Text(
                    '身份证号:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(width: 220,
                      child:
                      TextField(
                        controller: idNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 18,
                        onChanged: (value) {
                          if (value.length <= 18) {
                            setState(() {
                              idNumber = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: '输入入住人身份证',
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
                  if(name==""||name==null||idNumber==""||idNumber==null){
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
                          content: const Text("请输入入住人姓名和身份证号"),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.of(context).pop();
                            }, child: const Text("确定")),
                          ],
                        );
                      },
                    );
                  }else{
                    Map<String, dynamic> params = {};
                    params["act"] = "jdrz_crzk";
                    params["hid"] = widget.hid;
                    params["re_phone"] = Tel;
                    params["re_name"] = name;
                    params["etime"] = '${endDate.year}-${endDate.month}-${endDate.day}'+' 23:59:59';
                    params["stiem"] = '${startDate.year}-${startDate.month}-${startDate.day}'+' 00:00:00';
                    params["idcard"] =idNumber;
                    params["mm"] ="";
                    params["dsn"] ="";
                    final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
                    String url = "${urlModel.url}/apt/langsi_local";
                    HttpUtil.request(
                      url,
                      method: "post",
                      params: params,
                    ).then((value) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.subject,color: Colors.green,),
                                    Text("恭喜")
                                  ],
                                ),
                                content: const Text("成功入住"),
                                actions: [
                                  TextButton(onPressed: () {
                                    toAssociatedApparatus();
                                    Navigator.of(context).pop();

                                  },child: const Text("确定")),]);});
                    });
                  }
                }
                ,
                child: const Text('简单入住'),
              ),
            ],
          ),
        ),
      ])

    );
  }
}

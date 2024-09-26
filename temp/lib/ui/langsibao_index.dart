//包
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/page/childpage/processinglist.dart';
import 'package:langsisiswn/page/childpage/property_management.dart';

//页面
import '../common/LoginPrefs.dart';
import '../generated/l10n.dart';
import '../page/childpage/house_list.dart';
import '../page/childpage/gateway_houselist.dart';
class LangsiBaoIndex  extends StatefulWidget{
  const LangsiBaoIndex({super.key});

  @override
  LangsiBaoIndexState createState()=>LangsiBaoIndexState();

}
class LangsiBaoIndexState extends State<LangsiBaoIndex> {
  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    String langCode = LoginPrefs.getlang().toString(); // 假设 getlang() 返回正确的语言代码
    print(langCode);
    Locale locale = Locale(langCode);
    // 根据当前区域加载语言数据
    lang = await delegate.load(locale);
  }
  @override
  Widget build(BuildContext context) {
    _updateLang();
    // TODO: implement build
    return Material(
        color: Colors.white,
        child:
        Column(
          children:<Widget> [
            Center(
              child:
              ListView(
                shrinkWrap: true,
                children: [
                  Container(//头图
                    width: MediaQuery.of(context).size.width,
                    child: const Image(image: AssetImage("images/top0.png")),
                  ),

                  Container(
                      height: MediaQuery.of(context).size.width /4,
                      decoration: BoxDecoration(
                        color:Colors.black12, // 背景色
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)), // 圆角
                      ),
                      child:
                      ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            indexBox(context, lang.checkin,"images/rue.png"),
                            indexBox(context, lang.contract_info,"images/con.png"),
                            indexBox(context, lang.Occupied_tenant,"images/bat.png"),
                            indexBox(context, lang.work_order,"images/sef.png"),
                          ]
                      )),
                  const SizedBox(height: 10),
                SizedBox(
                  width:MediaQuery.of(context).size.width,
                  height: 300.0,
                  child:  ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width /4,
                        child:
                        ListView(//横向列表
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            indexBox(context, lang.lockmsg,"images/lock_icon.png"),
                            indexBox(context, lang.gatewaylist,"images/gateway_icon.png"),
                            indexBox(context, lang.houseadministration,"images/houseicon.png"),
                            indexBox(context, lang.low_battery_lock,"images/low_batterylock_icon .png"),
                          ],

                        ),),
                      Container(
                        height: MediaQuery.of(context).size.width /4,
                        child:
                        ListView(//横向列表
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            indexBox(context, lang.null_room_administration,"images/NULLhouseicon.png"),
                            indexBox(context, lang.tenantlist,"images/guest_histories_icon .png"),
                            indexBox(context, lang.check_record,"images/houseicon.png"),
                            indexBox(context, lang.select_bill,"images/bill_icon.png"),
                          ],

                        ),),
                      Container(
                        height: MediaQuery.of(context).size.width /4,
                        child:
                        ListView(//横向列表
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            indexBox(context, lang.water_meter_management,"images/wat_icon.png"),
                            indexBox(context, lang.electricity_meter_management,"images/eve_ico.png"),
                            indexBox(context, lang.Processing_list,"images/houseicon.png"),
                            indexBox(context, "低电门锁","images/low_batterylock_icon .png"),
                          ],

                        ),),
                    ],
                  ),
                  ),


                ],
              )
            )

          ],
        ),

    );

  }

Widget indexBox(BuildContext context,String text,String img) {
    return
      LayoutBuilder(
        builder: (context, constraints) {
      return Container(
          // padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width /4,

          child:
          CupertinoButton(
            child: Center(
                child:
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      height: 30,
                      child:  Image(image: AssetImage(img),),
                    ),
                    Text(text,textAlign:TextAlign.center,style: const TextStyle(fontSize: 10),),
                  ],
                )
            ), onPressed: () {
            if(text==lang.lockmsg){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Houselist()),);
            }else if(text==lang.houseadministration){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PropertyManagement()),);
            }
            else if(text==lang.Processing_list){//待处理列表
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProcessingList()),);
            }
            else if(text=="绑定网关"){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GateWayHouselist()),);
            }
            else{}
          },
          )

      );
        });

}


}

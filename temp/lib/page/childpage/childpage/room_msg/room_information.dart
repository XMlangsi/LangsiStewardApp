import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/page/childpage/childpage/room_msg/room_modify_information/roomModifyInformation.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../../../../VO/Internet_msg.dart';
import '../../../../method/http/httpUtil.dart';
import '../associated_apparatus.dart';

class RoomInformation extends StatefulWidget {
  final String hid;
  RoomInformation({ required this.hid});
  @override
  _RoomInformationState createState() => _RoomInformationState();
}

class _RoomInformationState extends State<RoomInformation> {
  Map<String, dynamic> roomlinfo = {};
  List<dynamic> rent_list=[];//租客列表
  List<dynamic> pz_list=[];//房屋配置列表

  Future<void> getroommsg() async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"hid":widget.hid});
    String url = "${urlModel.url}/housed/getRoomInfo";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    print(result);
    setState(() { roomlinfo = result["data"][0];});
  }

  Future<void> getRoompz() async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"hid":widget.hid});
    String url = "${urlModel.url}/housed/getRoompz";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    print(result);
    if(result["data"]==null){
      setState(() { pz_list = [];});
    }else{
      setState(() { pz_list = result["data"];});
    }
  }


  Future<void> getRentMsg() async {//获取租客信息
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"hid":widget.hid});
    String url = "${urlModel.url}/housed/getRentMsg";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    setState(() { rent_list = result["data"];});
  }
  //房屋配置
  Widget Configuration(BuildContext context,String text,String img,String img2,String id) {
    bool show=false;
    if(pz_list.indexOf(id)!=-1){
      show=true;
    }
    return  Column(

      children: [
        InkWell(
          onTap: () async {
            String fwpz="";//房屋配置
            if(show){
              setState(() { pz_list.remove(id);});
              // print(pz_list.length);
              if(pz_list.length>1){
                fwpz=pz_list.join(",").substring(1,pz_list.join(",").length);
              }else{
                fwpz="";
              }
            }else{
              setState(() { pz_list.add(id);});
              fwpz=pz_list.join(",").substring(1,pz_list.join(",").length);
            }
            final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
            Dio dio = new Dio();
            FormData formData = FormData.fromMap({"hid":widget.hid,"fwpz":fwpz});
            String url = "${urlModel.url}/housed/updateRoomInfo";
            Response response = await dio
                .post(url, data: formData);
            //var result = response.data;
            print(fwpz);
          },
          child:Padding(
            padding: EdgeInsets.all(10.0),

            child:
            SizedBox(
              width: 20,
              height: 20,
              child:show? Image(image: AssetImage(img)) : Image(image: AssetImage(img2)),
            ),
          ) ,
        ),

        Text(text,style: TextStyle(fontSize: 8,color: Colors.grey),)
      ],

    );
  }
  //---------------------------------------------------------------------//
  //初始化
  @override
  void initState() {
    getroommsg();
    getRoompz();
    getRentMsg();
    super.initState();

  }
  //页面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('房间信息'),
      ),
      body:
            Column(
              children: [
                Container(//图片+房间号
                  alignment: Alignment.center,
                  height: 90.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/top2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40,),
                      Text(
                        "${roomlinfo["houseName"]}${roomlinfo["roomno"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width,
              child: Row(//功能列表
                children: [
                Container(
                  color: Color(0xFFB39DDB),
                  alignment: Alignment.center,
                  height: 50.0,
                  width: MediaQuery.of(context).size.width/3-2,
                  child:InkWell(
                    onTap: () {
                      print("seaf");
                    },
                  child:
                  const Text("房间详情",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                    ,)
                ),
                  SizedBox(width: 2,),
                  Container(
                      color: Color(0xFFB39DDB),
                      alignment: Alignment.center,
                      height: 50.0,
                      width: MediaQuery.of(context).size.width/3-2,
                      child:InkWell(
                        onTap: () {
                          print("seaf");
                        },
                        child:
                        const Text("开门记录",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                        ,)
                  ),
                  SizedBox(width: 2,),
                  Container(
                      color: Color(0xFFB39DDB),
                      alignment: Alignment.center,
                      height: 50.0,
                      width: MediaQuery.of(context).size.width/3-2,
                      child:InkWell(
                        onTap: () {
                          print("seaf");
                        },
                        child:
                        Text("房间图片",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                        ,)
                  ),
                ],
              ),
              ),

           Expanded(
                child: ListView(
                    children:  [//房间基本信息
                      const SizedBox(//间隔
                        height: 20,
                      ),
                      Row(//房间地址
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.home),
                          ),
                          const Text("房间地址："),
                          const SizedBox(width: 10),
                          SizedBox(width: 210, child: Text("${roomlinfo["address"]}"),),

                        ],
                      ),
                      const Divider(
                        color: Colors.grey, // 分隔线颜色
                        thickness: 1.0,     // 分隔线厚度
                      ),
                      Row(//房间租金
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.grading),
                          ),
                          const Text("房间租金："),
                          const SizedBox(width: 10),
                          SizedBox(width: 210, child: Text("${roomlinfo["rent"]}元/月"),),

                        ],
                      ),
                      const Divider(
                        color: Colors.grey, // 分隔线颜色
                        thickness: 1.0,     // 分隔线厚度
                      ),
                      Row(//房间面积
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.grading),
                          ),
                          const Text("房间面积："),
                          const SizedBox(width: 10),
                          SizedBox(width: 210, child: Text("${roomlinfo["roomarea"]}m²"),),

                        ],
                      ),
                      const Divider(
                        color: Colors.grey, // 分隔线颜色
                        thickness: 1.0,     // 分隔线厚度
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.grading),
                          ),
                          const Text("房间房型："),
                          const SizedBox(width: 10),
                          SizedBox(width: 210, child: Text("${roomlinfo["fjtypename"]}"),),

                        ],
                      ),
                      const Divider(
                        color: Colors.grey, // 分隔线颜色
                        thickness: 1.0,     // 分隔线厚度
                      ),
                      const SizedBox(height: 20.0),//上下间隔
                      Column(//房间配置
                        children: [
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Text("房间配置：",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                              ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Configuration(context,"电视机","images/inroom/jd1.png","images/inroom/jd-E1.png","1A"),
                              Configuration(context,"冰箱","images/inroom/jd2.png","images/inroom/jd-E2.png","1B"),
                              Configuration(context,"洗衣机","images/inroom/jd3.png","images/inroom/jd-E3.png","1C"),
                              Configuration(context,"空调","images/inroom/jd4.png","images/inroom/jd-E4.png","1D"),
                              Configuration(context,"热水器","images/inroom/jd5.png","images/inroom/jd-E5.png","1E"),
                              Configuration(context,"油烟机","images/inroom/jd6.png","images/inroom/jd-E6.png","1H"),
                              Configuration(context,"微波炉","images/inroom/jd9.png","images/inroom/jd-E9.png","1I"),
                              Configuration(context,"衣柜","images/inroom/jd11.png","images/inroom/jd-E11.png","1K"),
                              Configuration(context,"鞋柜","images/inroom/jd12.png","images/inroom/jd-E12.png","1L"),
                              Configuration(context,"书桌","images/inroom/jd13.png","images/inroom/jd-E13.png","1M"),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Configuration(context,"椅子","images/inroom/jd14.png","images/inroom/jd-E14.png","1N"),
                              Configuration(context,"沙发","images/inroom/jd15.png","images/inroom/jd-E15.png","1O"),
                              Configuration(context,"1.5米床","images/inroom/jd16.png","images/inroom/jd-E16.png","1P"),
                              Configuration(context,"1.8米床","images/inroom/jd16.png","images/inroom/jd-E16.png","1Q"),
                              Configuration(context,"1.5米床垫","images/inroom/jd16.png","images/inroom/jd-E16.png","1R"),
                              Configuration(context,"1.8米床垫","images/inroom/jd16.png","images/inroom/jd-E16.png","1S"),
                              Configuration(context,"WiFi","images/inroom/jd17.png","images/inroom/jd-E17.png","1T"),
                              Configuration(context,"智能锁","images/inroom/jd18.png","images/inroom/jd-E18.png","1U"),
                            ],
                          ),
                          const SizedBox(height: 10.0,),
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Text("周边配置：",style:TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                              ],
                          ),
                          const SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Configuration(context,"停车场","images/inroom/jd19.png","images/inroom/jd-E19.png","2A"),
                              Configuration(context,"健身房","images/inroom/jd20.png","images/inroom/jd-E20.png","2B"),
                              Configuration(context,"超市","images/inroom/jd21.png","images/inroom/jd-E21.png","2C"),
                              Configuration(context,"地铁","images/inroom/jd22.png","images/inroom/jd-E22.png","2D"),
                              Configuration(context,"公交车站","images/inroom/jd23.png","images/inroom/jd-E23.png","2E"),
                            ],
                          ),
                        ],
                        
                      ),
                      const Divider(
                        color: Colors.grey, // 分隔线颜色
                        thickness: 1.0,     // 分隔线厚度
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                      alignment: Alignment.center,
                      height: 90.0,
                      width: MediaQuery.of(context).size.width,
                      child:
                          Row(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child:Wrap(children: [
                                  InkWell(
                                    child:
                                    Row(
                                        children: List.generate(rent_list.length, (index){
                                          var rent=rent_list[index];
                                          return
                                            InkWell(
                                                child:
                                                Column(
                                                  children: [
                                                    Padding(padding: const EdgeInsets.only(left:10,top:5,right:10,bottom:10),
                                                      child:SizedBox(
                                                        height:60,
                                                        width: 40,
                                                        child:rent["rentsex"]=="女"?Image(image: AssetImage("images/peoplew.png")):Image(image: AssetImage("images/people.png")),),
                                                    ),
                                                    Text(rent["rentname"],style: TextStyle(fontSize: 8,color: Colors.grey),)
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AssociatedApparatus(hid: widget.hid,rid: rent["rentNo"]),
                                                    ),
                                                  );

                                                },
                                            );

                                        }
                                        )
                                    ),
                                  )]
                                )
                            ),
                            IconButton(onPressed: ()=>{
                            }, icon: const Icon(Icons.keyboard_control_outlined))
                          ],
                          )

                      ),
                      const Divider(
                        color: Colors.grey, // 分隔线颜色
                        thickness: 1.0,     // 分隔线厚度
                      ),
                      const SizedBox(height: 20.0),
                ElevatedButton(
                    style:
                    ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFB39DDB)),//
                        // 设置圆角
                        shape: MaterialStateProperty.all(const StadiumBorder(
                            side: BorderSide(style: BorderStyle.none)))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RoomModifyInformation(hid: widget.hid),
                        ),
                      ).then((val)=>val?getroommsg():null);
                    },
                    child:const Text("修改信息",style: TextStyle(color: Colors.white),),),

                    ]
                ),
              )

              ],
            )

    );
  }
}

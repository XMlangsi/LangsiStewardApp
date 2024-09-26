import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/common/lock_psw.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../../VO/Internet_msg.dart';

class RoomModifyInformation extends StatefulWidget {
  final String hid;

  RoomModifyInformation({required this.hid});
  @override
  _RoomModifyInformationState createState() => _RoomModifyInformationState();
}

class _RoomModifyInformationState extends State<RoomModifyInformation> {
  // 控制器用于获取文本输入的值
  TextEditingController roomnumController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController electricityController = TextEditingController();
  TextEditingController waterController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  // 房型选项
  final List<String> roomTypes = ['单间', '一室一厅', '两室一厅', '三室一厅'];
  String? selectedRoomType;

  @override
  void initState() {
    super.initState();
    // 模拟通过房间ID获取房间信息
    loadRoomData(widget.hid);
  }

  Future<void> loadRoomData(String hid) async {//加载房间信息
    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"hid":widget.hid});
    String url = "${urlModel.url}/housed/getRoomInfo";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    print(result);
    setState(() {
      roomnumController.text = result["data"][0]["roomno"].toString(); // 房间租金
      rentController.text = result["data"][0]["rent"].toString(); // 房间租金
      areaController.text =result["data"][0]["roomarea"].toString(); // 房间面积
      electricityController.text = result["data"][0]["electric"].toString(); // 电费
      waterController.text =  result["data"][0]["coldWater"].toString(); // 水费
      floorController.text = result["data"][0]["floor"].toString(); // 所在楼层
      selectedRoomType = '两室一厅'; // 模拟房型
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改房间信息'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 房间号
              TextField(
                controller: roomnumController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: '房间号',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0,),
              // 房间租金
              TextField(
                controller: rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '房间租金 (元)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // 房间面积
              TextField(
                controller: areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '房间面积 (平方米)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // 电费
              TextField(
                controller: electricityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '电费 (元)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // 水费
              TextField(
                controller: waterController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '水费 (元)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // 所在楼层
              TextField(
                controller: floorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '所在楼层',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // 房型选择框
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '房型',
                  border: OutlineInputBorder(),
                ),
                value: selectedRoomType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRoomType = newValue;
                  });
                },
                items: roomTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.0),

              // 保存按钮
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // 保存操作
                    String rent = rentController.text;
                    String area = areaController.text;
                    String electricity = electricityController.text;
                    String water = waterController.text;
                    String floor = floorController.text;
                    String roomnumber = roomnumController.text;
                    String roomType = selectedRoomType ?? '';
                    final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
                    Dio dio = new Dio();
                    FormData formData = FormData.fromMap({
                      "hid":widget.hid,
                      "roomno":roomnumber,
                      "floor":floor,
                      "coldWater":water,
                      "electric":electricity,
                      "rent":rent,
                      "roomarea":area,
                    });
                    String url = "${urlModel.url}/housed/updateRoomInfo";
                    Response response = await dio
                        .post(url, data: formData);
                    Navigator.pop(context,true);
                  },
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

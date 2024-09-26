import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/page/childpage/childpage/room_msg/easy_checkin.dart';
import 'package:langsisiswn/page/childpage/childpage/room_msg/room_information.dart';
import 'package:provider/provider.dart';
import '../../VO/Internet_msg.dart';
import '../../common/LoginPrefs.dart';
import '../../generated/l10n.dart';
import '../../method/http/httpUtil.dart';
import '../../common/lock_psw.dart';
import './childpage/associated_apparatus.dart';
import 'childpage/checkin/CheckIn.dart';

class PropertyManagement extends StatefulWidget {
  @override
  _PropertyManagementState createState() => _PropertyManagementState();
}

class _PropertyManagementState extends State<PropertyManagement> {
  void _showModalBottomSheet(BuildContext context,String hid,String zt) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Row(
                  children:
                  [Icon(Icons.home_work)
                    ,Text('房间详情')],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RoomInformation(hid: hid),
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children:
                  [Icon(Icons.lock_open_rounded),
                  Text('关联设备')],
                  ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AssociatedApparatus(hid: hid,rid: ""),
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children:
                  [Icon(Icons.paste_rounded),
                    Text('简单入住')],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EasyCheckIn(hid: hid),
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                children:
                [Icon(Icons.domain),
                Text('开门记录')],
                ),
                onTap: () {
                  print('开门记录');
                },
              ),
        zt == '1002' ?
          ListTile(
                title:Row(
                  children:
                  [Icon(Icons.account_box),
                    Text('办理入住')],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CheckIn(hid: hid),
                    ),
                  );
                },
              ):
            ListTile(
            title: const Row(
              children:
              [Icon(Icons.people_alt),
                Text('加入同住人')],
            ),
            onTap: () {
            print('加入同住人');
            },
            ),
              ListTile(
                title: Row(
                  children:
                  [Icon(Icons.cancel_sharp,color: Colors.red,),
                  Text('关闭',style: TextStyle(color: Colors.red))],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    );
  }

  String selectedHouse = "";
  List<Map<String, String>> house = [];
  final ScrollController _scrollController = ScrollController();
  List<String> _floors = [];
  List<dynamic> dataList = [];
  bool isLoading = false;

  // 添加变量来存储每个楼层的高度
  List<double> floorHeights = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {

      sel_Houser();
    });
  }

  // 计算每个楼层的高度
  void calculateFloorHeights() {
    floorHeights = dataList.map((floor) {
      int roomCount = floor["houseDInfoList"].length;
      print("we1111");
      print(roomCount / ((MediaQuery.of(context).size.width / 100).floor() - 1).ceil());
      int rows = (roomCount / ((MediaQuery.of(context).size.width / 100).floor() - 1)).ceil(); // 每行最多3个房间
      return rows * 88.0 + 42.0 + 16.0; // 计算每层高度（88.0为每个房间的高度，50.0为标题高度，16.0为padding高度）
    }).toList();
  }

  // 滚动到指定楼层
  void _scrollToFloor(int index) {
    double position = 0;
    for (int i = 0; i < index; i++) {
      position += floorHeights[i];
    }
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void sel_Room() {
    setState(() {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      isLoading = true; // 开始加载
    });
    final urlModel =
    Provider.of<Internet_msg>(context, listen: false); //获取url
    Map<String, dynamic> params = {};
    params["userId"] = LoginPrefs.getToken().toString();
    params["houseNO"] = selectedHouse;
    HttpUtil.request(
      "${urlModel.url}/housed/get-house-housed",
      method: "post",
      params: params,
    ).then((value) {
      setState(() {
        isLoading = false; // 停止加载
        if (value["data"][0]["houseDFloorRespVOList"].length == 0) {
          dataList = [];
        } else {
          var data = value["data"][0]["houseDFloorRespVOList"][0]
          ["houseDInfoList"];
          List<Map<String, String>> convertedDataList =
          List<Map<String, String>>.from(data.map((item) => {
            "title": item["roomNO"].toString(),
            "rz": item["czState"].toString(),
            "subtitle": item["hid"].toString()
          }));
          dataList = value["data"][0]["houseDFloorRespVOList"];
          calculateFloorHeights(); // 计算每个楼层的高度
        }
      });
    });
  }

  Future<void> sel_Houser() async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);
    Dio dio = Dio();
    FormData formData = FormData.fromMap({"userid": LoginPrefs.getToken().toString()});
    print(LoginPrefs.getToken().toString());
    String url = "${urlModel.url}/housed/getHouse";

    try {
      Response response = await dio.post(url, data: formData);
      var result = response.data;
      if (result != null && result["data"] != null) {
        setState(() {
          var data = result["data"];
          List<Map<String, String>> convertedDataList =
          List<Map<String, String>>.from(data.map((item) => {
            "name": item["houseName"].toString(),
            "code": item["houseNO"].toString(),
          }));
          if (convertedDataList.isNotEmpty) {
            selectedHouse = convertedDataList[0]["code"]!;
            house = convertedDataList;
            getFloor();
            sel_Room();
          }
        });
      }
    } catch (e) {
      print("获取房源数据时出错: $e");
    }
  }

  Future<void> getFloor() async {
    final urlModel = Provider.of<Internet_msg>(context, listen: false);
    Dio dio = Dio();
    FormData formData = FormData.fromMap({"houseNo": selectedHouse});
    String url = "${urlModel.url}/housed/get-house-floor";

    try {
      Response response = await dio.post(url, data: formData);
      var result = response.data;
      if (result != null && result["data"] != null) {
        print(result["data"]);
        setState(() {
          _floors = [];
          for (var i = 0; i < result["data"].length; i++) {
            var floor = result["data"][i];
            if (floor is int) {
              _floors.add(floor.toString());
            } else {
              print("意外的数据格式: $floor");
            }
          }
        });
      }
    } catch (e) {
      print("获取楼层数据时出错: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('房源管理'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("选择楼栋:"),
                SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: selectedHouse.isNotEmpty ? selectedHouse : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHouse = newValue!;
                        sel_Room();
                      });
                    },
                    items: house.map((house) {
                      return DropdownMenuItem(
                        value: house["code"],
                        child: Text(house["name"]!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 50.0,
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _scrollToFloor(index),
                        child: Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: Text(
                            "${dataList[index]["floor"]}F",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "${dataList[index]["floor"]}F",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: List.generate(dataList[index]["houseDInfoList"].length, (roomIndex) {
                                    var room = dataList[index]["houseDInfoList"][roomIndex];
                                    return InkWell(
                                      onTap: () {
                                        _showModalBottomSheet(context, room["hid"].toString(),room["czState"].toString());
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 80.0,
                                        color: room["czState"] == '1002' ? Colors.black26 : Color(0xFF9575CD),
                                        child: Center(
                                          child: Text(
                                            room["roomNO"].toString(),
                                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}


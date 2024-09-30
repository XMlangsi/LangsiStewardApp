import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VO/Internet_msg.dart';
import '../../common/LoginPrefs.dart';
import '../../generated/l10n.dart';
import '../../method/http/httpUtil.dart';
import '../../common/lock_psw.dart';
import './childpage/associated_apparatus.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  ListItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class Houselist extends StatefulWidget {
  @override
  _HouselistState createState() => _HouselistState();
}

class _HouselistState extends State<Houselist> {
  TextEditingController floor=TextEditingController();
  String floorNum = "1";

  String selectedHouse = "";
  String roomno = "";
  List<Map<String, String>> dataList = [];
  List<Map<String, String>> house = [];
  bool isLoading = false; // 添加此变量以跟踪加载状态

  @override
  void initState() {
    floor.text=floorNum;
    super.initState();
    _updateLang();
    sel_Houser();
  }
  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    String langCode = LoginPrefs.getlang().toString(); // 假设 getlang() 返回正确的语言代码
    Locale locale = Locale(langCode);
    // 根据当前区域加载语言数据

    lang = await delegate.load(locale);
  }
  void sel_Room() {
    setState(() {
      isLoading = true; // 开始加载
    });
    if (floorNum == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("警告"),
            content: const Text("请输入楼层"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("确定"),
              ),
            ],
          );
        },
      );
      setState(() {
        isLoading = false; // 停止加载
      });
      return;
    }
    final urlModel =
    Provider.of<Internet_msg>(context, listen: false); //获取url
    Map<String, dynamic> params = {};
    params["userId"] = LoginPrefs.getToken().toString();
    params["houseNO"] = selectedHouse;
    params["floor"] = floorNum;
    params["roomNO"] = roomno;
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
          dataList=[];
          for (var i = 0; i<data.length; i++) {
            Map<String, dynamic> params = {};
            params["hid"] = data[i]["hid"].toString();
            params["lx"] = "ms";
            final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
            HttpUtil.request(
              "${urlModel.url}/housed/get_room_lock",
              method: "post",
              params: params,
            ).then((value) {
              setState(() {
                if(value["data"].length>0){

                  String e_no=value["data"][0]["equipNo"].toString();
                  String e_name=value["data"][0]["equipName"].toString();
                  dataList.add({"title":e_name,"subtitle":data[i]["hid"].toString(),"dsn":e_no,"rz":data[i]["czState"].toString()});
                  // List<Map<String, String>> convertedDataList =
                  // List<Map<String, String>>.from(data.map((item) => {
                  //
                  //   "title": item["roomNO"].toString(),
                  //   "rz": item["czState"].toString(),
                  //   "subtitle": item["hid"].toString()
                  // }));
                  //dataList = convertedDataList;
                }else{

                }
              });

              return false;
            });
          }
        }
      });
    });
  }

  Future<void> sel_Houser() async {
    isLoading = true;
    final urlModel = Provider.of<Internet_msg>(context, listen: false); //获取url
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({"userid":LoginPrefs.getToken().toString()});
    String url = "${urlModel.url}/housed/getHouse";
    Response response = await dio
        .post(url, data: formData);
    var result = response.data;
    print(result);
    setState(() {
      isLoading = false;
      var data = result["data"];
      List<Map<String, String>> convertedDataList =
      List<Map<String, String>>.from(data.map((item) => {
        "name": item["houseName"].toString(),
        "code": item["houseNO"].toString(),
      }));
      print(convertedDataList);
      selectedHouse = convertedDataList[0]["code"]!;
      house = convertedDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('门锁管理'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    const Text("楼栋:"),
                    const SizedBox(width: 10.0),
                    Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButton<String>(
                        value: selectedHouse,
                        onChanged: (String? newPosition) {
                          setState(() {
                            selectedHouse = newPosition!;
                          });
                        },
                        isDense: false,
                        iconSize: 30.0,
                        items: house.map((var xindao) {
                          return DropdownMenuItem(
                            value: xindao["code"]!.toString(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: Text(
                                xindao["name"]!,
                                style: const TextStyle(fontSize: 13.0),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text("楼层:"),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TextFormField(
                            controller:floor,
                            decoration: const InputDecoration(),
                          validator: (v) {},
                          onChanged: (v) {
                            floorNum = v;
                          },
                          onSaved: (v) => floorNum = v!,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    const Text("房号:"),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TextFormField(
                          decoration: const InputDecoration(),
                          validator: (v) {},
                          onChanged: (v) {
                            roomno = v;
                          },
                          onSaved: (v) => roomno = v!,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Container(
                      width: 80.0,
                      height: 40.0,
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.blue,
                        child: Text(
                          lang.sel_msg,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          sel_Room();
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = dataList[index];
                return Container(
                  height: 60.0,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Image(
                          image: AssetImage(
                              "images/lhlt.png"),
                        ),
                      ),
                      SizedBox(
                        width: 230,
                        child:
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child:  Column(children: [
                                Text(item["title"]!,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                                Text(item["dsn"]!,style: const TextStyle(color:Colors.grey),),
                              ],),
                            )

                      )
                      ,


                      const SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AssociatedApparatus(hid: item["subtitle"] ?? "",rid: ""),
                            ),
                          );
                        },
                        child: const Text("进入"),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

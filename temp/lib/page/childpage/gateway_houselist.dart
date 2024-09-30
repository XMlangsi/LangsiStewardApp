import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './childpage/link_info.dart';

class House {
  final String name;
  final String code;

  House({required this.name, required this.code});
}

class GateWayHouselist extends StatefulWidget {
  @override
  _GateWayHouselistState createState() => _GateWayHouselistState();
}

class _GateWayHouselistState extends State<GateWayHouselist> {
  String selectedHouse = "1";
  String floor = ""; // Added floor variable
  List<House> houses = [
    House(name: "楼栋1", code: "1"),
    House(name: "楼栋2", code: "2"),
    // Add more buildings as needed
  ];
  var dataList=[{"name": "房屋001","code": "001","re":"T"},{"name": "房屋001","code": "001","re":"F"}];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绑定网关'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text("选择楼栋:"),
                SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: selectedHouse,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHouse = newValue!;
                      });
                    },
                    items: houses.map((house) {
                      return DropdownMenuItem(
                        value: house.code,
                        child: Text(house.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text("楼层:"),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(),
                    validator: (v) {},
                    onSaved: (v) => floor = v!,
                  ),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                      setState(() {
                        if(selectedHouse=="1"){
                          dataList=[
                            {"name": "房屋003","code": "003","re":"F"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"F"},
                            {"name": "房屋003","code": "003","re":"F"},
                            {"name": "房屋003","code": "003","re":"F"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"},
                            {"name": "房屋003","code": "003","re":"T"}
                          ];
                        }else{
                          dataList=[
                            {"name": "房屋002","code": "002","re":"F"},
                            {"name": "房屋002","code": "002","re":"T"},
                            {"name": "房屋002","code": "002","re":"F"},
                            {"name": "房屋002","code": "002","re":"T"}
                          ];
                        }

                      });
                  },
                  child: Text("搜索"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (context, index) {
      return HouseItem(
        name: dataList[index]["name"]!,
        code: dataList[index]["code"]!,
        re: dataList[index]["re"]!,
      );
      // Add more house items as needed
    })
              ),
            ),

        ],
      ),
    );
  }
}


class HouseItem extends StatelessWidget {
  final String name;
  final String code;
  final String re;

  HouseItem({required this.name, required this.code,required this.re});

  @override
  Widget build(BuildContext context) {
    return
      Container(
      height: 60.0,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black)),
        color: Colors.white,
      ),
      child:
            Row(
            children: <Widget>[
              SizedBox(
                height: 50.0,
                width: 50.0,
                child: Image.asset(re=="T" ? "images/gatewaylist.png" : "images/gatewaylist_no.png"),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                child: Text("$name - $code"),
              ),
                const SizedBox(width: 120,),
                SizedBox(
                  width: 80,
                  height: 30,
                  child:ElevatedButton(
                    onPressed: () {
                      print(re);
                    },
                    child: const Text("进入"),) ,
                )

            ],
          ),


    );
  }
}

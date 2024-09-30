import 'package:flutter/material.dart';

class DoorLockData {
  final String room;

  DoorLockData({
    required this.room,
  });
}

class LinkInfo extends StatefulWidget {
  final String hid;

  LinkInfo({required this.hid});

  @override
  _LinkInfoState createState() => _LinkInfoState();
}

class _LinkInfoState extends State<LinkInfo> {
  late String floor;
  List<DoorLockData> doorLockDataList = [
    DoorLockData(room: '101'),
    DoorLockData(room: '102'),
  ];
  List<DoorLockData> doorLockDataList2 = [
    DoorLockData(room: '134'),
    DoorLockData(room: '234'),
    DoorLockData(room: '334'),
    DoorLockData(room: '434'),
    DoorLockData(room: '534'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hid),
      ),
      body: Column(
        children: [
          const Image(image: AssetImage("images/gateway_icon.png")),
          const SizedBox(height: 20.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("网关编号：123456789"),
              Text("网关名字：测试网关101"),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showSelectDoorLockDialog(context);
                },
                child: const Text("关联门锁"),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: doorLockDataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Row(children: [
                        Icon(Icons.house_rounded),
                        Text('${doorLockDataList[index].room}'),
                        SizedBox(width: 10.0,),
                        TextButton(onPressed: ()=>{
                          setState((){
                            doorLockDataList.remove(doorLockDataList[index]);
                            })
                        }, child: Text("解绑"))
                      ],)
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectDoorLockDialog(BuildContext context) async {
    DoorLockData? selectedDoorLock;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择门锁'),
          content: SingleChildScrollView(
            child:
                Column(children: [
                  Row(
                    children: [
                      Text("楼层"),
                      SizedBox(width: 10.0),
                      Expanded( // 使用 Expanded 包裹 TextFormFiled，确保有宽度约束
                        child: TextFormField(
                          decoration: const InputDecoration(),
                          validator: (v) {
                            // 在这里添加验证逻辑
                          },
                          onSaved: (v) => floor = v!,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: doorLockDataList2.map((doorLock) {
                      return ListTile(
                        title: Text(doorLock.room),
                        onTap: () {
                          setState(() {
                            selectedDoorLock = doorLock;
                            doorLockDataList.add(selectedDoorLock!);
                            Navigator.pop(context);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],)

          ),
        );
      },
    );
  }
}

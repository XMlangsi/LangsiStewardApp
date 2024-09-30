import 'package:flutter/material.dart';
import "package:langsisiswn/VO/gateway_location_item.dart";
class GateWayLocation extends StatefulWidget{
  @override
  _GateWayLocationState createState() => _GateWayLocationState();
}

class _GateWayLocationState extends State<GateWayLocation> {
  @override
  Widget build(BuildContext context) {
    //GateWayLocationItem? gateWayLocationItem=ModalRoute.of(context)?.settings.arguments as GateWayLocationItem?;
    /// 界面框架
    return Scaffold(
        appBar: AppBar(
          title: const Text("网关关联"),

        ),
        body:
        Container(
          alignment: const Alignment(-1,0),
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          color: Colors.blueAccent,
          child:
          const Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child:Text("网关关联",style: TextStyle(color: Colors.white),) ,
              )
            ],
          ),
        )


    );
  }
}
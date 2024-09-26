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

class CheckIn extends StatefulWidget {
  final String hid;

  CheckIn({super.key, required this.hid});
  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  String dropdownValue = '纸质合同';
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 365));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('办理入住'),
        ),
        body:
        Padding(
          padding: EdgeInsets.all(0.0),
          child: ListView(
            children: [
              // Room information
              ListTile(
                title: Text('cwh8422的房源-123'),
              ),
              // Contract type
              buildRadioButtonField('签约方式', ['纸质合同','电子合同'], dropdownValue),
              Divider(),
              // Input fields
              buildInputField('姓名', '请输入'),
              buildInputField('联系方式', '请输入'),
              buildDropdownField('证件类型', ['身份证', '护照'], '身份证'),
              buildInputField('证件号', '请输入'),
              buildMoreInfoField('更多信息', '其他个人信息'),
              buildAddField('同住人', '添加同住人'),
              Divider(),
              // Contract dates
              buildDateField('开始时间', selectedStartDate),
              buildDateField('结束时间', selectedEndDate),
              // Rent duration
              Row(
                children: [
                  SizedBox(width: 90,height: 20,
                    child:ElevatedButton(onPressed: () {
                      setState(() {
                        selectedStartDate = DateTime.now();
                        selectedEndDate = DateTime.now().add(const Duration(days: 90));
                      });
                    }, child: const Text('90天',style: TextStyle(fontSize: 7.0),)),
                  ),
                  const SizedBox(width: 11),
                  SizedBox(width: 90,height: 20,
                    child:ElevatedButton(onPressed: () {
                      setState(() {
                        selectedStartDate = DateTime.now();
                        selectedEndDate = DateTime.now().add(const Duration(days: 180));
                      });
                    }, child: const Text('180天',style: TextStyle(fontSize: 7.0),)),
                  ),
                  const SizedBox(width: 11),
                  SizedBox(width: 90,height: 20,
                    child:ElevatedButton(onPressed: () {
                      setState(() {
                        selectedStartDate = DateTime.now();
                        selectedEndDate = DateTime.now().add(const Duration(days: 365));
                      });
                    }, child: const Text('一年',style: TextStyle(fontSize: 7.0),)),
                  ),
                  SizedBox(width: 11),
                  SizedBox(width: 90,height: 20,
                    child:ElevatedButton(onPressed: () {
                      setState(() {
                        selectedStartDate = DateTime.now();
                        selectedEndDate = DateTime.now().add(Duration(days: 365*2));
                      });
                    }, child: const Text('两年',style: TextStyle(fontSize: 7.0),)),
                  ),
                 // SizedBox(width: 8),
                 // ElevatedButton(onPressed: () {}, child: Text('电子合同')),

                ],
              ),
              Divider(),
              // Payment info
              buildInputField('租金', '元/月'),
              buildInputField('押金', '元'),
              buildAddField('其他费用', '添加其他费用'),
              Divider(),
              buildInputField('水费', '0.00 元/吨'),
              buildInputField('电费', '0.00 元/度'),
              buildInputField('水表底数', '请输入'),
              buildInputField('电表底数', '请输入'),
              // Submit button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('下一步：账单'),
              ),
            ],
          ),
        ),
    );

  }
  Widget buildInputField(String label, String placeholder) {
    return ListTile(
      title: Text(label),
      trailing: Container(
        width: 150,
        child: TextField(
          decoration: InputDecoration(
            hintText: placeholder,
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> options, String selectedOption) {
    return ListTile(
      title: Text(label),
      trailing: DropdownButton<String>(
        value: selectedOption,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDateField(String label, DateTime date) {
    return ListTile(
      title: Text(label),
      trailing: Text('${date.year}-${date.month}-${date.day}'),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != date) {
          setState(() {
            if (label == '开始时间') {
              selectedStartDate = picked;
            } else {
              selectedEndDate = picked;
            }
          });
        }
      },
    );
  }

  Widget buildRadioButtonField(String label, List<String> options, String selectedValue) {
    return
      Container(
        color:  Color(0xFFE0E0E0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,style: TextStyle(fontFamily: 'PingFang SC',fontSize: 18),),
            Row(
              children: options.map((option) {
                return Row(
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: dropdownValue,
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                    Text(option),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );

  }

  Widget buildMoreInfoField(String label, String buttonText) {
    return ListTile(
      title: Text(label),
      trailing: TextButton(
        onPressed: () {},
        child: Text(buttonText),
      ),
    );
  }

  Widget buildAddField(String label, String buttonText) {
    return ListTile(
      title: Text(label),
      trailing: TextButton(
        onPressed: () {},
        child: Text(buttonText),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:langsisiswn/common/lock_psw.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../../../../../VO/Internet_msg.dart';

class CheckInOtherExpenses extends StatefulWidget {


  CheckInOtherExpenses({super.key});
  @override
  _CheckInOtherExpensesState createState() => _CheckInOtherExpensesState();
}

class _CheckInOtherExpensesState extends State<CheckInOtherExpenses> {
  final List<Map<String, String>> fees = [];
  String? selectedFeeType;
  String? selectedSubType;

  final List<String> feeTypes = ['押金', '费用'];
  final Map<String, List<String>> subTypes = {
    '押金': [],
    '费用': [],
  };

  final TextEditingController amountController = TextEditingController();
  void _removeFee(int index) {
    setState(() {
      fees.removeAt(index);
    });
  }
  void _addFee() {
    if (selectedFeeType != null &&
        selectedSubType != null &&
        amountController.text.isNotEmpty) {
      setState(() {
        fees.add({
          'type': selectedFeeType!,
          'subType': selectedSubType!,
          'amount': amountController.text,
        });
        amountController.clear();
        selectedSubType = null;
        selectedFeeType = null;
      });
    }
  }
  Future<void> selfylist() async {
    Dio dio = Dio();
    final urlModel = Provider.of<Internet_msg>(context, listen: false);
    FormData formData = FormData.fromMap({
      "otherid": "IB_fylx",
    });
    String url = "${urlModel.url}/ebasicOther/getebasicOther";

    try {
      Response response = await dio.post(url, data: formData);
      var result = response.data;

      if (result is List) {
        for (var item in result) {
          // 确保 item 是 Map 类型并提取 othername
          if (item is Map<String, dynamic> && item.containsKey("othername")) {
            if (item["othername"].toString().contains("押金")) {
              subTypes["押金"]?.add(item["othername"].toString());
            } else {
              subTypes["费用"]?.add(item["othername"].toString());
            }
          }
        }
      }
    } catch (e) {
      print('请求失败: $e');
    }
  }

  @override
  void initState() {
    selfylist();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加收费'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: Text('选择收费类型'),
              value: selectedFeeType,
              items: feeTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFeeType = value;
                  selectedSubType = null;
                });
              },
            ),
            if (selectedFeeType != null)
              DropdownButton<String>(
                hint: Text('选择收费类别'),
                value: selectedSubType,
                items: subTypes[selectedFeeType]!.map((String subType) {
                  return DropdownMenuItem<String>(
                    value: subType,
                    child: Text(subType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubType = value;
                  });
                },
              ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: '金额'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFee,
              child: Text('添加收费'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fees.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${fees[index]['type']} - ${fees[index]['subType']}'),
                    subtitle: Text('金额: ${fees[index]['amount']} 元'),
                    trailing: IconButton(
                      icon: Icon(Icons.backspace_outlined, color: Colors.redAccent),
                      onPressed: () {
                        _removeFee(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Contractprefs{//创建合同的公用存储类
  static const List<Map<String, dynamic>> INMATE=[];//同住人列表
  static const List<Map<String, dynamic>> EXPENSE=[];//费用列表
  static const String PAREENT_Name="";//其他联系人姓名
  static const String PAREENT_relation="";//其他联系人关系
  static const String PAREENT_pho="";//其他联系人电话
  static const String PAREENT_idNum="";//其他联系人身份证

  static late SharedPreferences _prefs;//延迟初始化
  static Future<String> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    return 'ok';
  }
  static void savePAREENT_pro(String pareentpro){
    _prefs.setString(PAREENT_pho, pareentpro);
  }
  static String? getPAREENT_PHO() {
    return _prefs.getString(PAREENT_pho);
  }
  static void savePAREENT_relation(String pareentrelation){
    _prefs.setString(PAREENT_relation, pareentrelation);
  }
  static String? getPAREENT_relation() {
    return _prefs.getString(PAREENT_relation);
  }
  static void saveinmate(List<Map<String, dynamic>> inmate){
    String jsonString = jsonEncode(INMATE);
    _prefs.setString('INMATEList', jsonString);
  }
  static Object? getinmate() {
    String? jsonString = _prefs.getString('INMATEList');
    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.cast<Map<String, dynamic>>();
    }
    //return _prefs.getString(Lang_TA);
  }
  static void savePAREENT_Name(String pareentName){
    _prefs.setString(PAREENT_Name, pareentName);
  }
  static String? getPAREENT_Name() {
    return _prefs.getString(PAREENT_Name);
  }
}
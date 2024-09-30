import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPrefs{
  static const String USER_NAME="USER_NAME";//用户名
  static const String USER_FILDID="";//用户头像
  static const String USER_ID="";//用户ID
  static const String TOKEN="TOKEN";//token
  static const String Lang_TA="zh";//语言
  static late SharedPreferences _prefs;//延迟初始化
  static Future<String> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    return 'ok';
  }
  static void savelang(String lang){
    _prefs.setString(Lang_TA, lang);
  }
  static String? getlang() {
    return _prefs.getString(Lang_TA);
  }
  static void saveUSERID(String USERID){
    _prefs.setString(USER_ID, USERID);
  }
  static String? getUSERID() {
    return _prefs.getString(USER_ID);
  }
  static void saveUSERFILDID(String userFILDID){
    _prefs.setString(USER_FILDID, userFILDID);
  }
  static String? getUSERFILDID() {
    return _prefs.getString(USER_FILDID);
  }
  static void saveUserName(String userName) {
    _prefs.setString(USER_NAME, userName);
  }
  static String? getUserName() {
    return _prefs.getString(USER_NAME);
  }
  static void saveToken(String token){
    _prefs.setString(TOKEN, token);
  }
  static String? getToken() {
    return _prefs.getString(TOKEN);
  }
  static void removeUserName() {
    _prefs.remove(USER_NAME);
  }
  static void removeToken() {
    _prefs.remove(TOKEN);
  }
  static void clearLogin(){
    _prefs.clear();
  }
}
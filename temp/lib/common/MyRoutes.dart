//配置路由

import 'package:flutter/material.dart';
import '../page/mainpage.dart';
import 'LoginPrefs.dart';
import '../page/login.dart';
import '../main.dart';

/*
 *  这个方法是固定写法，功能就像是一个拦截器。
 */
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  Map<String, Widget> routes = {
    'home': MainNavigatorWidget(), //定义app路径
    'login': Login(), //定义login路径
  };

  String routerName = routeBeforeHook(settings);
  bool mathMap = false;
  Route<dynamic>? mathWidget;
  routes.forEach((key, v) {
    if (key == routerName) {
      mathMap = true;
      mathWidget = MaterialPageRoute(builder: (BuildContext context) => v);
    }
  });

  if (mathMap) {
    return mathWidget;
  }
  return MaterialPageRoute(
      builder: (BuildContext context) => Container(
        child: Text('404'),
      ));
}

String routeBeforeHook(RouteSettings settings) {
  if(checkToken()==false){
    return 'login';
  }else{
    return settings.name!;
  }
}
bool checkToken() {
  String token = LoginPrefs.getToken()??'';
  if ('' != token) return true;
  return false;
}
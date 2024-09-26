import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import '../ui/ShowDefineAlertWidget.dart';

///

/// 自定义弹窗

///

///

class AppTool {

  /// 底部弹出2个选项框

//   showBottomAlert(BuildContext context, confirmCallback, String title,
//
//  String option1, String option2) {
//
//   showCupertinoModalPopup(
//
//   context: context,
//
//  builder: (context) {
//
//   return BottomCustomAlterWidget(
//
//   confirmCallback, title, option1, option2);
//
//  });
//
//  }
//
//   /// 中间弹出提示框
//
//  showCenterTipsAlter(
//
//   BuildContext context, confirmCallback, String title, String desText) {
//
//   showDialog(
//
//   context: context,
//
//  builder: (BuildContext context) {
//
//   return CenterTipsAlterWidget(confirmCallback, title, desText);
//
//    });
//
//  }
//
//   /// 中间弹出输入框
//
// showCenterInputAlert(
//
//   BuildContext context, confirmCallback, String title, String placeholder) {
//
//   showDialog(
//
//   context: context,
//
//    builder: (BuildContext context) {
//
//   return ShowInputAlertWidget(confirmCallback, title, placeholder);
//
//  });
//
//    }
//
//   ///自定义弹框
//
//   showStyleAlert(BuildContext context, confirmCallback, String title,
//
//    String contentTitle) {
//
//   showDialog(
//
//   context: context,
//
//    builder: (BuildContext context) {
//
//   return StyleDialog(confirmCallback, title, contentTitle);
//
//  });
//
//   }

  ///只有一个确定按钮的弹窗

  showDefineAlert(

  BuildContext context, confirmCallback, String title, String hintText) {

  showDialog(

  context: context,

   builder: (BuildContext context) {

  return ShowDefineAlertWidget(confirmCallback, title, hintText);

 });

 }

}

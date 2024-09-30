import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:langsisiswn/VO/Internet_msg.dart';

import 'package:langsisiswn/VO/user_info.dart';
import 'package:langsisiswn/page/Language/LanguagePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/LoginPrefs.dart';
import '../generated/l10n.dart';
import '../main.dart';
import '../tool/apptool.dart';
import 'package:dio/dio.dart';

import 'package:flutter_update_dialog/flutter_update_dialog.dart';

import '../method/http/httpUtil.dart';
import 'mainpage.dart';

class Login extends StatelessWidget{
  @override
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // 不显示右上角的 debug
        title: '朗思管家',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // 注册路由表
        routes: {
          "/": (context) => const HomePage(title: "登录"), // 首页路由
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late S lang;
  bool _method1Executed = false;

  Future<void> _openLanguagePage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LanguagePage()),
    );
    if (result == true ) {
      setState(() {
        _updateLang();
      });


    }
  }
  _updateLang() async {
    print("执行一次");
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    String langCode = LoginPrefs.getlang().toString(); // 假设 getlang() 返回正确的语言代码
    Locale locale = Locale(langCode);
    // 根据当前区域加载语言数据

    lang = await delegate.load(locale);
  }
  Widget buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // 调用打开语言选择页面的方法
                _openLanguagePage(context);
              },
              child: Text(lang.switch_language,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                print("忘记密码");
              },
              child: Text(lang.forgot_password,
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
  login(String email,String password,context,String text1,String text2,String text3){
    FocusScopeNode currentFocus = FocusScope.of(context);
    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if(email== ""|| password==""){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(text1),
            content:  Text(text2),
            actions: [
              TextButton(onPressed: () { Navigator.of(context).pop();}, child:  Text(text3)),
            ],
          );
        },
      );

    }else{
      final urlModel = Provider.of<Internet_msg>(context, listen: false);//获取url
      Map<String, dynamic> params = {};
//放入自己输入的值
      params["loginId"] = email;
      params["pwd"] =  password;
      HttpUtil.request(
        "${urlModel.url}/admin/login",//连接
        method: "post",//请求
        params: params,//参数
      ).then((value) {
        if(value['code']==0){
          LoginPrefs.saveUSERID(value["data"]["empNo"].toString());
          LoginPrefs.saveUSERFILDID(value["data"]["fileId"].toString());
          LoginPrefs.saveUserName(value["data"]["empname"].toString());
          LoginPrefs.saveToken(value["data"]["empNo"].toString());
          AppTool().showDefineAlert(context, jump(context), lang.congratulation, lang.login_success);
        }else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:  Row(
                  children: [
                    const Icon(Icons.warning_outlined,color: Colors.red,),
                    Text(lang.warning)
                  ],
                ),
                content: Text(lang.login_out),
                actions: [
                  TextButton(onPressed: () { Navigator.of(context).pop();}, child: Text(lang.yes)),
                ],
              );
            },
          );
        }
      }).catchError((onError) {
        print(onError);
      });
    }

  }
  final GlobalKey _formKey = GlobalKey<FormState>();
  late String _email="", _password="";
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    _updateLang();
    return Scaffold(
      body:
          Center(
            child:
            Form(
              key: _formKey, // 设置globalKey，用于后面获取FormStat
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
                  const SizedBox(height: 40),
                  buildTitle(), // Login
                  const SizedBox(height: 60),
                  buildEmailTextField(), // 输入账号
                  const SizedBox(height: 30),
                  buildPasswordTextField(context), // 输入密码
                  buildForgetPasswordText(context), // 忘记密码
                  const SizedBox(height: 60),
                  buildLoginButton(context), // 登录按钮
                  // const SizedBox(height: 40),
                  // buildRegisterText(context), // 注册
                ],
              ),
            ),
            )

    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('没有账号?'),
            GestureDetector(
              child: const Text('点击注册', style: TextStyle(color: Colors.green)),
              onTap: () {
                print("点击注册");
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget buildOtherMethod(context) {
  //   return ButtonBar(
  //     alignment: MainAxisAlignment.center,
  //     children: _loginMethod
  //         .map((item) => Builder(builder: (context) {
  //       return IconButton(
  //           icon: Icon(item['icon'],
  //               color: Theme.of(context).iconTheme.color),
  //           onPressed: () {
  //             //TODO: 第三方登录方法
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                   content: Text('${item['title']}登录'),
  //                   action: SnackBarAction(
  //                     label: '取消',
  //                     onPressed: () {},
  //                   )),
  //             );
  //           });
  //     }))
  //         .toList(),
  //   );
  // }
  //
  // Widget buildOtherLoginText() {
  //   return const Center(
  //     child: Text(
  //       '其他账号登录',
  //       style: TextStyle(color: Colors.grey, fontSize: 14),
  //     ),
  //   );
  // }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style:
          ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.cyan),//
            // 设置圆角
              shape: WidgetStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text(lang.login,style: TextStyle(color: Colors.white),),
          onPressed: ()=>{
           login(_email,_password,context,lang.warning,lang.enter_your_password,lang.yes),
            //AppTool().showDefineAlert(context, jump(context), "恭喜", '登录成功'),
            //jump(context)
            }
        ),
      ),
    );
  }



  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscure, // 是否显示文字
        onChanged: (v){
          _password=v;
        },
        onSaved: (v) => _password = v!,
        validator: (v) {
          if (v!.isEmpty) {
            return lang.enter_your_password;
          }
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.password),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                // 修改 state 内部变量, 且需要界面内容更新, 需要使用 setState()
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = (_isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          ),
      validator: (v) {
      },
      onChanged: (v) {
        _email=v;
      },
      onSaved: (v) => _email = v!,
    );
  }

  Widget buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black,
            width: 40,
            height: 2,
          ),
        ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child:
        Image(image: AssetImage("images/logo1.png"))
    );
  }
}
over_jump(BuildContext context){
  print("object");
}
jump(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MainNavigatorWidget()),
  );
}


// Map<String, dynamic> params = {};
// //放入自己输入的值
// params["ac"] = "lockauth";
// params["partnerid"] = "hongqi";
// params["deviceid"] = "64a1e2c60668";
// params["password"] = "123654";
// params["usertype"] = "02";
// params["begindate"] = "2024-01-01 00:00:00";
// params["enddate"] = "2024-03-01 00:00:00";
// params["channel"] = "2";
// params["type"] = "03";
// print(params);
// HttpUtil.request(
// "http://aiot.langsi.com.cn/api/lock/tx_add_user",//连接
// method: "post",//请求
// params: params,//参数
// ).then((value) {
// print(value);
// }).catchError((onError) {
// print(onError);
// });
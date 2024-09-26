import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'VO/Internet_msg.dart';
import 'common/LoginPrefs.dart';
import 'generated/l10n.dart';
import 'page/login.dart';
import 'page/mainpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String value = await LoginPrefs.init();
  LoginPrefs.savelang('zh');
  Locale locale = const Locale('zh'); // 设置全局语言为中文
  if (value == "ok") {
    runApp(MyApp(locale));
  }
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp(this.locale, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '朗思管家',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) =>

       Internet_msg('http://192.168.2.38:9090'),
       //Internet_msg('http://192.168.1.111:7700'), // 初始化URL
        child: Login(),
      ),
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),//English
        Locale('zh'),//中文支持
        Locale('ko'),//韩语支持
        Locale('pr'),//葡萄牙语支持
        Locale('vi'),//越南语支持
        Locale('ja'), // 添加日语支持
      ],
      locale: locale,
      debugShowCheckedModeBanner: false,
    );
  }
}

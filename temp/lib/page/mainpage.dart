import 'package:flutter/material.dart';
import '../common/LoginPrefs.dart';
import '../generated/l10n.dart';
import '../ui/langsibao_index.dart';
import '../page/userpage.dart';
class MainNavigatorWidget extends StatefulWidget {
  @override
  _MainNavigatorWidgetState createState() => _MainNavigatorWidgetState();
}

class _MainNavigatorWidgetState extends State<MainNavigatorWidget>{
  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    String langCode = LoginPrefs.getlang().toString(); // 假设 getlang() 返回正确的语言代码
    print(langCode);
    Locale locale = Locale(langCode);
    // 根据当前区域加载语言数据
    lang = await delegate.load(locale);
  }

late final List<BottomNavigationBarItem> bottomNavItems = [
  BottomNavigationBarItem(
    backgroundColor: Colors.blue,
    icon: Icon(Icons.home),
    label: lang.index,
  ),

  BottomNavigationBarItem(
    backgroundColor: Colors.purple,
    icon: Icon(Icons.account_circle_sharp),
    label: lang.my,
  ),
];

late int currentIndex;

final pages = [LangsiBaoIndex(), UserPage()  ];

@override
void initState() {
  super.initState();
  currentIndex = 0;
}

@override
Widget build(BuildContext context) {
  _updateLang();
  return Scaffold(
    appBar: AppBar(
      title: Text("朗思管家"),

    ),
    bottomNavigationBar: BottomNavigationBar(
      items: bottomNavItems,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.shifting,
      onTap: (index) {
        _changePage(index);
      },
    ),
    body: pages[currentIndex],
  );
}

/*切换页面*/
void _changePage(int index) {
  /*如果点击的导航项不是当前项  切换 */
  if (index != currentIndex) {
    setState(() {
      currentIndex = index;
    });
  }
}
}


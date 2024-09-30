import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:langsisiswn/common/LoginPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _currentLanguage = 'en';

  void _setLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    setState(() {
      _currentLanguage = languageCode;
    });
    // 切换语言后，重新加载应用程序以应用新语言
    await _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedLanguage = prefs.getString('language');
    if (selectedLanguage != null) {
      setState(() {
        _currentLanguage = selectedLanguage;
      });
      // 加载选择的语言包
      String basePath = 'assets/lang';
      await rootBundle.load('$basePath/$_currentLanguage.json').then((data) {
        String jsonContent = String.fromCharCodes(data.buffer.asUint8List());
        final Map<String, dynamic> translations = json.decode(jsonContent);
        Intl.defaultLocale = _currentLanguage;
        translations.forEach((key, value) {
          translations[key] = value.toString();
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLanguageButton('中文', 'zh'),
            _buildLanguageButton('日本語', 'ja'),
            _buildLanguageButton('English', 'en'),
            _buildLanguageButton('Português', 'pr'),
            _buildLanguageButton('한국어', 'ko'),
            _buildLanguageButton('Việt nam', 'vi'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String languageName, String languageCode) {
    return ElevatedButton(
      onPressed: () {
        LoginPrefs.savelang(languageCode);
        Navigator.pop(context,true);
      },
      child: Text(languageName),
    );
  }
}
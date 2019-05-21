import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter_go/routers/routers.dart';
import 'package:flutter_go/routers/application.dart';
import 'package:flutter_go/utils/provider.dart';
import 'package:flutter_go/utils/shared_preferences.dart';
import 'package:flutter_go/utils/analytics.dart' as Analytics;
import 'package:flutter_go/model/search_history.dart';
import 'package:flutter_go/views/first_page/home.dart';
//import 'package:flutter_go/views/welcome_page/index.dart';

const int ThemeColor = 0xFFC91B3A;
SpUtil sp; //单例"同步" SharedPreferences 工具类..
var db;    //全局变量，用于操作数据库

class MyApp extends StatelessWidget {
  //本类的构造函数
  MyApp()  {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  showWelcomePage() {
    return AppPage();

    // 暂时关掉欢迎介绍
    //bool showWelcome = sp.getBool(SharedPreferencesKeys.showWelcome);
    //if (showWelcome == null || showWelcome == true) {
    //  return WelcomePage();
    //} else {
    //  return AppPage();
    //}
  }

  //build界面
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'title',
      theme: new ThemeData(
        primaryColor: Color(ThemeColor),
        backgroundColor: Color(0xFFEFEFEF),
        accentColor: Color(0xFF888888),
        textTheme: TextTheme(
          //设置Material的默认字体样式
          body1: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
        ),
        iconTheme: IconThemeData(
          color: Color(ThemeColor),
          size: 35.0,
        ),
      ),
      home: new Scaffold(
        body: showWelcomePage()
      ),
      onGenerateRoute: Application.router.generator,
      navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }
}

void main() async {
  //导入数据库
  final provider = new Provider();
  await provider.init(true);
  db = Provider.db;

  // 得到单例对象的 搜索 管理对象 (搜索历史的初始化)
  sp = await SpUtil.getInstance();
  new SearchHistoryList(sp);

  runApp(new MyApp());
}


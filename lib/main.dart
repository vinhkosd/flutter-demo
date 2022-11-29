import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/login/first_login.dart';
import 'package:flutter_demo/screens/login/login.dart';
import 'package:flutter_demo/screens/page/absent_list.dart';
import 'package:flutter_demo/screens/page/account_list.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/screens/page/edit_profile.dart';
import 'package:flutter_demo/screens/page/phongban_list.dart';
import 'package:flutter_demo/screens/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/theme/colors.dart';
import 'common/theme/index.dart';
import 'helpers/utils.dart';
import 'models/app_model.dart';

void main() => runApp(MyApp());

//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppModel? _app;

  @override
  void initState() {
    _app = AppModel();
    _app?.init();
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
  }

  // This widget is the root of your application.
  ThemeData getTheme(context) {
    var appModel = Provider.of<AppModel>(context);
    var isDarkTheme = appModel.darkTheme;
    if (isDarkTheme) {
      return buildDarkTheme('vi');
    }
    return buildLightTheme('vi');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: _app!,
      child: Consumer<AppModel>(builder: (context, value, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuController(),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: getTheme(context),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
            routes: {
              'home': (context) => const DashboardScreen(),
              'login': (context) => LoginScreen(),
              'firstlogin': (context) => FirstLoginScreen(),
              'accountlist': (context) => AccountList(),
              'phongbanlist': (context) => PhongBanList(),
              'setting': (context) => SettingsPage(),
              'edit_profile': (context) => EditProfile(),
              'absent_list': (context) => AbsentList(),
            },
          ),
        );
      }),
    );
  }
}

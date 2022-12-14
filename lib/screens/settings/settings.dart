import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../event_bus.dart';
import '../../helpers/utils.dart';
import '../../models/app_model.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    eventBus.on<ToggleDrawerEvent>().listen((event) {
      if (!(scaffoldKey.currentState?.isDrawerOpen ?? false))
        scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(),
      body: DefaultContainer(
          headerText: 'Cài đặt',
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 2.0),
                    elevation: 0,
                    child: SwitchListTile(
                      secondary: Icon(
                        Provider.of<AppModel>(context).darkTheme
                            ? CupertinoIcons.sun_min
                            : CupertinoIcons.moon,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 24,
                      ),
                      value: Provider.of<AppModel>(context).darkTheme,
                      activeColor: const Color(0xFF0066B4),
                      onChanged: (bool value) {
                        if (value) {
                          Provider.of<AppModel>(context, listen: false)
                              .updateTheme(true);
                        } else {
                          Provider.of<AppModel>(context, listen: false)
                              .updateTheme(false);
                        }
                      },
                      title: Text(
                        'Dark theme',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                // Container(
                //     height: MediaQuery.of(context).size.height * 0.08,
                //     width: MediaQuery.of(context).size.width * 0.9,
                //     child: OutlinedButton(
                //       style: OutlinedButton.styleFrom(
                //           backgroundColor: Color.fromARGB(255, 26, 115, 232),
                //           primary: Color.fromARGB(255, 255, 255, 255)),
                //       onPressed: () {},
                //       child: const Text('Cập nhật',
                //           style: TextStyle(color: Colors.white, fontSize: 20)),
                //     )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          )),
    );
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
          title: Text('Tài khoản hoặc mật khẩu không chính xác!')),
    );
  }
}

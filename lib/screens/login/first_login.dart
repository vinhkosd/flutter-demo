import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/screens/page/dashboard.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

class FirstLoginScreen extends StatefulWidget {
  @override
  _FirstLoginScreenState createState() => _FirstLoginScreenState();
}

class _FirstLoginScreenState extends State<FirstLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  initState() {
    super.initState();
  }

  bool processing = false;

  Future<void> firstLogin(_name, _email, _password) async {
    setState(() {
      processing = true;
    });

    if (await Utils.firstLogin(_name, _email, _password)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MenuController(),
                      ),
                    ],
                    child: DashboardScreen(),
                  )));
    } else {
      Utils.prefs.clear(); //clear cache
      Navigator.of(context).restorablePush(_dialogBuilder);
    }

    setState(() {
      processing = false;
    });
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (this.processing) {
      return loadingOnlyCircle(context, "Đang đăng nhập");
    }

    return Scaffold(
      body: FutureBuilder<bool>(
          future: Utils.initConfig(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Utils.initScreen();
            }
            return SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Container(
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Tạo tài khoản giám đốc',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Utils.renderDivider(),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập vào thông tin tên giám đốc';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tên giám đốc',
                          hintText: 'Họ tên giám đốc'),
                      controller: fullNameController,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập vào Email';
                        }

                        if (!validEmail(value.toString())) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0))),
                          labelText: 'Email',
                          hintText: 'Enter valid email id as abc@gmail.com'),
                      controller: emailController,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập vào mật khẩu';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0))),
                          labelText: 'Password',
                          hintText: 'Password'),
                      controller: passwordController,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Utils.renderDivider(),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_formKey.currentState!.validate()) {
                          firstLogin(
                              fullNameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim());
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Color.fromARGB(255, 26, 115, 232),
                        ),
                        child: Center(
                          child: Text(
                            'Tạo tài khoản',
                            style: Theme.of(context).textTheme.button!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ));
          }),
    );
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
          title: Text('Không thể tạo tài khoản giám đốc, vui lòng thử lại!')),
    );
  }
}

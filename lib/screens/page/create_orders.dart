import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/models/customer.dart';
import 'package:flutter_demo/models/project.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';

class CreateOrders extends StatefulWidget {
  const CreateOrders();

  @override
  _CreateOrdersState createState() => _CreateOrdersState();
}

class _CreateOrdersState extends State<CreateOrders> {
  Customer selectedCustomer;
  Project selectedProject;
  List<Project> projects = [];
  bool processing = false;

  void initState() {
    super.initState();
  }

  final LocalStorage storage = new LocalStorage('test');
  Future<String> _testSubmit() async {
    setState(() {
      processing = true;
    });

    // Map<String, dynamic> body = await Utils.postWithCtrl('test', listCtrl);

    setState(() {
      processing = true;
    });
  }

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context, TextEditingController ctrl) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, ctrl);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, ctrl);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(
      BuildContext context, TextEditingController ctrl) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDate != null
          ? TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute)
          : initialTime,
    );

    if (pickedDate != null && pickedTime != null)
    
      setState(() {
        selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
        ctrl.text = DateFormat("HH:mm dd/MM/yyyy").format(selectedDate);
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context, TextEditingController ctrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (picked) {
              if (picked != null &&
                  DateFormat("HH:mm dd/MM/yyyy").format(picked) != ctrl.text)
                setState(() {
                  selectedDate = picked;
                  ctrl.text = DateFormat("HH:mm dd/MM/yyyy").format(picked);
                });
            },
            initialDateTime: selectedDate,
            minimumYear: DateTime.now().year - 5,
            maximumYear: DateTime.now().year + 5,
          ),
        );
      });
  }

  TextEditingController _agenda = TextEditingController();
  TextEditingController _dateOfMaturity = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (this.processing) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Text(
                  '',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Center(
                child: LinearProgressIndicator(
                  semanticsLabel: 'Linear progress indicator',
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Color.fromARGB(255, 26, 115, 232),
        //   title: Text("Thêm đơn hàng"),
        // ),
        key: context.read<MenuController>().scaffoldKey,
        drawer: SideMenu(),
        body: DefaultContainer(
          backIcon: true,
          rightIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child:IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: _testSubmit,
                    )
                  ),
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:Icon(
                      Icons.shopping_cart_outlined,
                      size: 18,
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DropdownSearch<Customer>(
                        itemAsString: (Customer u) => u.toString(),
                        popupItemBuilder: (context, selectedItem, isSelected) {
                          Widget item(Customer item) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  // height: 38,
                                  padding: EdgeInsets.all(10.0),
                                  // margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  child: Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.account_circle,
                                                size: 18,
                                              ),
                                              Text(
                                                "${item.name} - KH${formatId(item.id.toString())}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_right,
                                                size: 18,
                                              ),
                                              Text(
                                                "Điện thoại: ${item.phone_number}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_right,
                                                size: 18,
                                              ),
                                              Text(
                                                "Di động: ${item.mobile_phone_number}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_right,
                                                size: 18,
                                              ),
                                              Text(
                                                "MST: ${item.tax_code}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_searching,
                                                size: 18,
                                              ),
                                              Text(
                                                "${item.getAddress()}",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )));
                          return item(selectedItem);
                        },
                        onChanged: (Customer data) async {
                          selectedCustomer = data;
                          print(selectedCustomer.id);
                          // projects/getByCustomerId/${selectedCustomer.id}
                          var response = await Utils.getUrl(
                              "projects/getByCustomerId/${selectedCustomer.id}");
                          setState(() {
                            projects =
                                Project.fromJsonList(jsonDecode(response));
                          });
                        },
                        mode: Mode.DIALOG,
                        isFilteredOnline: true,
                        onFind: (String filter) async {
                          if (filter.length > 2) {
                            var response =
                                await Utils.getUrl("customers/search/$filter");
                            var models =
                                Customer.fromJsonList(jsonDecode(response));
                            return models;
                          }
                          return [];
                        },
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Chọn khách hàng",
                          hintText: "Chọn khách hàng",
                        ),
                        selectedItem: null,
                        showSearchBox: true),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DropdownSearch<Project>(
                        itemAsString: (Project u) => u.toString(),
                        onChanged: (Project data) async {
                          selectedProject = data;
                          print(selectedProject.toArray());
                          // projects/getByCustomerId/${selectedCustomer.id}
                        },
                        mode: Mode.DIALOG,
                        dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Chọn dự án",
                          hintText: "Chọn dự án",
                        ),
                        items: projects,
                        selectedItem: null,
                        showSearchBox: true),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Sổ nhật ký',
                          hintText: 'Nhập sổ nhật ký'),
                      // controller: _password,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      onTap: () => _selectDate(context, _agenda),
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.date_range,
                            size: 18,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Ngày hóa đơn',
                          hintText: 'Ngày hóa đơn'),
                      controller: _agenda,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      onTap: () => _selectDate(context, _dateOfMaturity),
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.date_range,
                            size: 18,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Ngày đến hạn',
                          hintText: 'Ngày đến hạn'),
                      controller: _dateOfMaturity,
                    ),
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.all(15.0),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 26, 115, 232),
                        primary: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      _testSubmit();
                    },
                    child: const Text('Chọn sản phẩm',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )),
              Container(
                  padding: const EdgeInsets.all(15.0),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 26, 115, 232),
                        primary: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      _testSubmit();
                    },
                    child: const Text('Lưu',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )),
            ],
          ),
        )));
  }
}
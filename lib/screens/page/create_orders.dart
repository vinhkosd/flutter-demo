import 'dart:convert';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/models/customer.dart';
import 'package:flutter_demo/models/product.dart';
import 'package:flutter_demo/models/project.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/screens/page/carts.dart';
import 'package:flutter_demo/screens/page/product-chooser.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class CreateOrders extends StatefulWidget {
  const CreateOrders();

  @override
  _CreateOrdersState createState() => _CreateOrdersState();
}

class _CreateOrdersState extends State<CreateOrders> {
  bool showBottomMenu = false;
  Customer selectedCustomer;
  Project selectedProject;
  Product selectedProduct;
  List<Project> projects = [];
  bool processing = false;
  List<Product> products = [];
  List<Product> carts = [];

  bool showCarts = false;

  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Utils.initConfig();
    Map<String, dynamic> user = Utils.getUser();

    Map<String, dynamic> formData = {};
    formData["branchId"] = user["branch_id"].toString();
    formData["companyId"] = user["company_id"].toString();

    String response = await Utils.getUrl(
        'product-stock/getByBranchId?branchId=${user["branch_id"].toString()}&companyId=${user["company_id"].toString()}');
    products = Product.fromJsonList(jsonDecode(response));
    setState(() {
      processing = false;
    });
  }

  final LocalStorage storage = new LocalStorage('test');
  Future<String> _testSubmit() async {
    setState(() {
      processing = true;
    });

    // Map<String, dynamic> body = await Utils.postWithCtrl('test', listCtrl);

    setState(() {
      processing = false;
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
    double height = MediaQuery.of(context).size.height;
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
                child: Badge(
                  // padding: EdgeInsets.all(0),
                  badgeColor: Colors.red,

                  position: BadgePosition.bottomEnd(end: -5),
                  borderRadius: BorderRadius.circular(45.0),
                  shape: BadgeShape.square,
                  badgeContent: Text(this.carts.length.toString()),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      setState(() {
                        showCarts = true;
                      });
                    },
                  ),
                )),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownSearch<Customer>(
                                itemAsString: (Customer u) => u.toString(),
                                popupItemBuilder:
                                    (context, selectedItem, isSelected) {
                                  Widget item(Customer item) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        // height: 38,
                                        padding: EdgeInsets.all(10.0),
                                        // margin: EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
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
                                      ));
                                  return item(selectedItem);
                                },
                                onChanged: (Customer data) async {
                                  selectedCustomer = data;

                                  var response = await Utils.getUrl(
                                      "projects/getByCustomerId/${selectedCustomer.id}");
                                  setState(() {
                                    projects = Project.fromJsonList(
                                        jsonDecode(response));
                                  });
                                },
                                mode: Mode.DIALOG,
                                isFilteredOnline: true,
                                onFind: (String filter) async {
                                  if (filter.length > 2) {
                                    var response = await Utils.getUrl(
                                        "customers/search/$filter");
                                    var models = Customer.fromJsonList(
                                        jsonDecode(response));
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
                              onTap: () =>
                                  _selectDate(context, _dateOfMaturity),
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownSearch<Product>(
                                itemAsString: (Product u) => u.toString(),
                                onChanged: (Product data) async {
                                  setState(() {
                                    selectedProduct = data;
                                    showBottomMenu = true;
                                  });
                                },
                                popupItemBuilder:
                                    (context, selectedItem, isSelected) {
                                  Widget item(Product item) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        // height: 38,
                                        padding: EdgeInsets.all(10.0),
                                        // margin: EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.apps,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    "Tên: ${item.name}",
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
                                                    Icons.attach_money,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    "Đơn giá: ${formatMoney(item.price.toString())} VNĐ",
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
                                                    Icons.balance,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    "Đơn vị: ${item.unit_name.toString()}",
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
                                                    Icons.warehouse,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    "Kho: ${item.warehouse_name.toString()}",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                  return item(selectedItem);
                                },
                                filterFn: (Product product, String filter) {
                                  return product.filterByName(filter);
                                },
                                mode: Mode.DIALOG,
                                dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Chọn sản phẩm",
                                  hintText: "Chọn sản phẩm",
                                ),
                                items: products,
                                selectedItem: null,
                                showSearchBox: true),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.all(15.0),
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 26, 115, 232),
                                primary: Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () {
                              _testSubmit();
                            },
                            child: const Text('Lưu',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          )),
                    ],
                  ),
                ),
                if (showBottomMenu || showCarts)
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 80),
                    opacity: (showBottomMenu || showCarts) ? 1.0 : 0.0,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showBottomMenu = false;
                              showCarts = false;
                            });
                          },
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          )),
                    ),
                  ),
                AnimatedPositioned(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 150),
                    left: 0,
                    bottom: (showBottomMenu) ? -(height * 0.2) : -(height),
                    child: ProductChooser(
                      onChoose: (Product productChoosed) {
                        print(productChoosed.toJson());
                        if (carts
                                .where((element) =>
                                    element.id == productChoosed.id)
                                .toList()
                                .length <=
                            0) {
                          carts.add(productChoosed);
                        } else {
                          carts
                              .where(
                                  (element) => element.id == productChoosed.id)
                              .forEach((element) {
                            element = productChoosed;
                          });
                        }

                        setState(() {
                          showBottomMenu = false;
                        });
                      },
                      product: selectedProduct,
                    )),
                AnimatedPositioned(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 150),
                    left: 0,
                    bottom: (showCarts) ? -(height * 0.2) : -(height),
                    child: Carts(
                      carts: this.carts,
                      onSelectProduct: (Product prod) {
                        setState(() {
                          selectedProduct = prod;
                          showCarts = false;
                          showBottomMenu = true;
                        });
                      },
                    ))
              ],
            )));
  }
}

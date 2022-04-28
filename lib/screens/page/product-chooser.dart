import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/models/product.dart';
import 'package:flutter_demo/models/unit.dart';

class ProductChooser extends StatelessWidget {
  final Product product;
  final Function(Product productChoosed) onChoose;
  const ProductChooser({Key key, this.product, this.onChoose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController productName = new TextEditingController();
    TextEditingController vatInput = new TextEditingController();
    TextEditingController priceInput = new TextEditingController();
    TextEditingController countInput = new TextEditingController();
    productName.text = this.product != null ? this.product.name : "";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (this.product == null) {
      return Container();
    }

    vatInput.text = this.product.vat != null ? this.product.vat.toString() : "0";
    priceInput.text = this.product.price != null ? this.product.price.toString() : "0";
    countInput.text = this.product.count != null ? this.product.count.toString() : "0";


    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: productName,
                    readOnly: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tên sản phẩm',
                        hintText: 'Tên sản phẩm'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownSearch<Unit>(
                      itemAsString: (Unit u) => u.toString(),
                      onChanged: (Unit data) async {
                        // selectedProject = data;
                        priceInput.text = data.newPrice.toString();
                        this.product.unit_id = data.unit_id;
                        this.product.unit_name = data.unit_name;
                      },
                      mode: Mode.MENU,
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Chọn đơn vị",
                        hintText: "Chọn đơn vị",
                      ),
                      items: this.product.unit_list,
                      selectedItem: this
                          .product
                          .unit_list
                          .where((element) =>
                              element.unit_id == this.product.unit_id)
                          .first,
                      showSearchBox: true),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.attach_money,
                          size: 18,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Số lượng',
                        hintText: 'Số lượng'),
                    controller: countInput,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.percent,
                          size: 18,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'VAT (%)',
                        hintText: 'VAT (%)'),
                    controller: vatInput,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.attach_money,
                          size: 18,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Đơn giá',
                        hintText: 'Đơn giá'),
                    controller: priceInput,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: Responsive.isDesktop(context)
                                ? MediaQuery.of(context).size.width * 0.15
                                : MediaQuery.of(context).size.width * 0.4,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 26, 115, 232),
                                  primary: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () {
                                this.product.vat = int.parse(vatInput.text);
                                this.product.price = int.parse(priceInput.text);
                                this.product.count = int.parse(countInput.text);
                                this.onChoose(this.product);
                              },
                              child: const Text('Chọn sản phẩm',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ))),
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: Responsive.isDesktop(context)
                                ? MediaQuery.of(context).size.width * 0.15
                                : MediaQuery.of(context).size.width * 0.4,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 26, 115, 232),
                                  primary: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () {},
                              child: const Text('Hủy bỏ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            )))
                  ],
                ),
              ]))),
    );
  }
}

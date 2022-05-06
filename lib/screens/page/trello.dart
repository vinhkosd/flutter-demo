import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/models/card.dart';
import 'package:flutter_demo/models/list_card.dart';
import 'package:flutter_demo/models/order_type.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

class Trello extends StatefulWidget {
  @override
  _TrelloState createState() => _TrelloState();
}

class _TrelloState extends State<Trello> {
  static List<ListCard> cards = [];
  ScrollController _scrollController;

  static Map<String, dynamic> jsonData = {};
  initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData();
  }

  List<OrderType> orderTypes = <OrderType>[];
  var pagination;

  var ITEM_PER_PAGE = 100;

  int currentStatus = -1;

  OrderType selectedOrderType;

  bool processing = true;

  Future<void> loadData() async {
    await Utils.initConfig();
    Map<String, dynamic> orderConfig = Utils.config["ORDER"];

    List<dynamic> statusList = Utils.config["ORDER"]["STATUS_LIST"];
    orderTypes.add(new OrderType(value: -1, name: 'Tất cả'));
    statusList.forEach((element) {
      orderTypes.add(new OrderType(
          value: int.parse(element["id"].toString(), radix: 10),
          name: element["name"]));
    });

    Map<String, dynamic> formData = {};
    formData["limit"] = ITEM_PER_PAGE.toString();
    formData["status"] = currentStatus.toString();
    if (pagination != null) {
      formData["page"] = pagination["current_page"].toString();
    }

    Map<String, dynamic> tableData =
        await Utils.getWithForm('orders', formData);
    String _jsonData = jsonEncode(tableData);

    selectedOrderType = orderTypes[0];
    jsonData = tableData;

    createRandomCard();
    createRandomChildren();
    setState(() {
      processing = false;
      pagination = tableData["pagination"];
    });
  }

  Future<String> loadDetail(int index, int innerIndex) async {
    setState(() {
      processing = true;
    });
    await Utils.initConfig();

    String response =
        await Utils.getUrl('orders/infor/${cards[index].cards[innerIndex].id}');
    // cards[index].cards[innerIndex].checkLists.add();
    Map<String, dynamic> jsonData = jsonDecode(response);
    if (cards[index].cards[innerIndex].checkLists["Dịch vụ"] == null) {
      cards[index].cards[innerIndex].checkLists["Dịch vụ"] = [];
      jsonData["items"].forEach((elm) {
        cards[index].cards[innerIndex].checkLists["Dịch vụ"].add(
            new CheckBoxInfo(checked: false, title: elm["product_name"] ?? ""));
      });
    }

    setState(() {
      processing = false;
    });
    return response;
  }

  static void createRandomChildren() {
    Random _rnd = Random(DateTime.now().microsecond);
    for (int j = 0; j < cards.length; j++) {
      for (int i = 0; i <= 3 + _rnd.nextInt(20); i++) {
        jsonData["items"].forEach((elm) {
          cards[j].cards.add(new TrelloCard(
              id: elm["id"],
              title: "DH${formatId(elm["id"].toString())}",
              comments: [],
              description: elm["product_name"] ?? "",
              checkLists: {}));
        });
      }
    }
  }

  static void createRandomCard() {
    // Random _rnd = Random();
    // for (int i = 0; i <= 1 + _rnd.nextInt(5); i++) {
    int i = 1;
    cards.add(new ListCard(id: i, title: "List $i", cards: []));
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (this.processing) {
      return loadingProcess(context, "Đang tải dữ liệu");
    }

    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: _buildBody(),
    );
  }

  TextEditingController _cardTextController = TextEditingController();
  TextEditingController _taskTextController = TextEditingController();

  showDetail(TrelloCard card) {
    String categoryValue;

    TextEditingController desc = new TextEditingController();
    TextEditingController cmt = new TextEditingController();
    desc.text = card.description;
    bool isEdit = false;

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      (Responsive.isDesktop(context) ? 0.2 : 0.1)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.title,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16.0,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (isEdit) {
                              card.description = desc.text;
                            }
                            isEdit = !isEdit;
                            setState(() {});
                          },
                          child: Text("Edit"),
                        ),
                      ],
                    ),
                    isEdit
                        ? TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            controller: desc,
                          )
                        : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(card.description),
                              ],
                            )),
                          ),
                    ...card.checkLists.entries.map((checkLists) => new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Icon(Icons.checklist_rtl),
                                      ),
                                      Text(checkLists.key,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  ...checkLists.value
                                      .map(
                                        (element) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              value: element.checked,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  element.checked = value;
                                                  card.checkLists[
                                                          checkLists.key]
                                                      .where((elm) =>
                                                          element == elm)
                                                      .forEach((element) {
                                                    element.checked = value;
                                                  });
                                                });
                                              },
                                            ),
                                            Text(
                                              element.title,
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList()
                                ],
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nội dung',
                          hintText: 'Nội dung...'),
                      maxLines: 3,
                      controller: cmt,
                    ),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: categoryValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              categoryValue = newValue;
                            });
                          },
                          items: <String>['Loại 1', 'Loại 2', 'Loại 3', 'Loại 4']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            print(card.comments);
                            Map<String, dynamic> user = Utils.getUser();
                            card.comments.add(new UserComment(
                                user: "${user["full_name"]}: ",
                                comment: cmt.text,
                                category: categoryValue));

                            cmt.text = "";
                            setState(() {});
                          },
                          child: Text("Bình luận"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    ...groupBy(card.comments, (UserComment obj) => obj.category).entries.map((elm) => Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.message_rounded),
                            ),
                            Text(
                              elm.key,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            
                          ],
                        ),
                        ...elm.value.map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Color.fromARGB(135, 104, 104, 104)),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                              child: Icon(Icons.person_rounded),
                                            ),
                                            Text(
                                              e.user,
                                              style: TextStyle(
                                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(
                                                e.comment,
                                                style: TextStyle(fontSize: 16.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )).toList()
                      ],
                    )).toList(),
                    
                    SizedBox(
                      height: 16.0,
                    ),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          card.description = desc.text;
                        },
                        child: Text("Chỉnh sửa"),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  _showAddCard() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add a list",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "List name"),
                    controller: _cardTextController,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addCard(_cardTextController.text.trim());
                    },
                    child: Text("Add Card"),
                  ),
                )
              ],
            ),
          );
        });
  }

  _addCard(String text) {
    cards.add(new ListCard(id: cards.length + 1, title: text, cards: []));
    _cardTextController.text = "";
    setState(() {});
  }

  _showAddCardTask(int index) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Add Card task",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (value) {
                      Navigator.of(context).pop();
                      _addCardTask(index, value.trim());
                    },
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      hintText: "Task Title",
                      prefixIcon: Icon(Icons.search),
                    ),
                    controller: _taskTextController,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addCardTask(index, _taskTextController.text.trim());
                    },
                    child: Text("Add Task"),
                  ),
                )
              ],
            ),
          );
        });
  }

  _addCardTask(int index, String text) {
    cards[index].cards.add(new TrelloCard(
        id: cards[index].cards.length,
        title: text,
        description: text,
        labels: [],
        checkLists: {},
        comments: []));
    _taskTextController.text = "";
    setState(() {});
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = cards[index].cards[oldIndex];
    cards[index].cards[oldIndex] = cards[index].cards[newIndex];
    cards[index].cards[newIndex] = oldValue;
    setState(() {});
  }

  _buildBody() {
    return DefaultContainer(
      child: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: cards.length + 1,
          itemBuilder: (context, index) {
            if (index == cards.length)
              return _buildAddCardWidget(context);
            else
              return _buildCard(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildAddCardWidget(context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(13.0),
          child: InkWell(
            onTap: () {
              _showAddCard();
            },
            child: Container(
              width: 300.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5.0,
                      offset: Offset(0, 0),
                      color: Color.fromRGBO(127, 140, 141, 0.5),
                      spreadRadius: 2.0)
                ],
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 16,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Text("Add a list"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCardTaskWidget(context, index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          _showAddCardTask(index);
        },
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
            ),
            SizedBox(
              width: 16.0,
            ),
            Text("Add card"),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    // return Container(
    //         width: 300.0,
    //   child: ,
    // );
    double titleHeight = 128.0;
    double buttonHeight = 32.0;
    double eachRowHeight = 64.0;
    int maxCard =
        ((MediaQuery.of(context).size.height - titleHeight - buttonHeight) /
                eachRowHeight)
            .floor();
    int showMaxCard = cards[index].cards.length > maxCard
        ? maxCard
        : cards[index].cards.length;

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(4.0),
              color: Color.fromARGB(254, 235, 236, 240),
            ),
            margin: const EdgeInsets.all(16.0),
            height:
                (showMaxCard * (eachRowHeight) + titleHeight + buttonHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    cards[index].title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                            height: (showMaxCard * (eachRowHeight)),
                            // child: DragAndDropList<String>(
                            //   cards[index].cards,
                            //   itemBuilder: (BuildContext context, item) {
                            //     return _buildCardTask(
                            //         index, cards[index].cards.indexOf(item));
                            //   },
                            //   onDragFinish: (oldIndex, newIndex) {
                            //     print(oldIndex);
                            //     _handleReOrder(oldIndex, newIndex, index);
                            //   },
                            //   canBeDraggedTo: (one, two) => true,
                            //   dragElevation: 8.0,
                            // ),
                            child: ReorderableListView(
                              children: <Widget>[
                                for (int indexInner = 0;
                                    indexInner < cards[index].cards.length;
                                    indexInner += 1)
                                  _buildCardTask(index, indexInner),
                              ],
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }

                                  var item =
                                      cards[index].cards.removeAt(oldIndex);
                                  cards[index].cards.insert(newIndex, item);
                                });
                              },
                            )),
                      ),
                    ),
                    _buildAddCardTaskWidget(context, index)
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DragTarget<dynamic>(
              onWillAccept: (data) {
                if (data['from'] == index) {
                  // that will not allow to drag both children in one list
                  return false;
                }
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                // if (data['from'] == index) {// that will not allow to drag both children in one list
                //   return;
                // }
                cards[data["from"]].cards.remove(data["cards"]);
                cards[index].cards.add(data["cards"]);
                print(data);
                print({"to": index});
                setState(() {});
              },
              builder: (context, accept, reject) {
                // print("--- > $accept");
                // print(reject);
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCardTask(int index, int innerIndex) {
    return Container(
      key: Key('$index$innerIndex'),
      width: 300.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 15,
                    offset: Offset(0, 1.75),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 1,
                    blurStyle: BlurStyle.inner)
              ],
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
            ),
            width: 284.0,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(cards[index].cards[innerIndex].title,
                    style: TextStyle(fontSize: 16.0)),
                IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        cards[index].cards.removeAt(innerIndex);
                      });
                    })
              ],
            ),
          ),
        ),
        childWhenDragging: Container(),
        child: GestureDetector(
          onTap: () async {
            print("onTap");
            await loadDetail(index, innerIndex);
            print(cards[index].cards[innerIndex].checkLists);
            showDetail(cards[index].cards[innerIndex]);
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 15,
                    offset: Offset(0, 1.75),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 1,
                    blurStyle: BlurStyle.inner)
              ],
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(cards[index].cards[innerIndex].title,
                      style: TextStyle(fontSize: 16.0)),
                ),
                IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        cards[index].cards.removeAt(innerIndex);
                      });
                    })
              ],
            ),
          ),
        ),
        data: {"from": index, "cards": cards[index].cards[innerIndex]},
      ),
    );
  }
}

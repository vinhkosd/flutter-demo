import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/responsive.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:provider/provider.dart';

class Trello extends StatefulWidget {
  @override
  _TrelloState createState() => _TrelloState();
}

class _TrelloState extends State<Trello> {
  initState() {
    super.initState();
  }

  static List<String> cards = createRandomCard();
  static List<List<String>> cardChildren = createRandomChildren(cards.length);

  static List<List<String>> createRandomChildren(int cardLength) {
    List<List<String>> _cardChildren = [];
    Random _rnd = Random(DateTime.now().microsecond);
    for (int j = 0; j < cardLength; j++) {
      List<String> lst = [];

      for (int i = 0; i <= 3 + _rnd.nextInt(20); i++) {
        lst.add("${cards[j]} - Card $i");
      }
      _cardChildren.add(lst);
    }

    return _cardChildren;
  }

  static List<String> createRandomCard() {
    List<String> lst = [];
    Random _rnd = Random();
    for (int i = 0; i <= 1 + _rnd.nextInt(5); i++) {
      lst.add("List $i");
    }
    return lst;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      // appBar: AppBar(
      //   title: Text("Suppliers"),
      // ),
      body: _buildBody(),
    );
  }

  TextEditingController _cardTextController = TextEditingController();
  TextEditingController _taskTextController = TextEditingController();

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
                    "Add Card",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Card Title"),
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
    cards.add(text);
    cardChildren.add([]);
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
    cardChildren[index].add(text);
    _taskTextController.text = "";
    setState(() {});
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = cardChildren[index][oldIndex];
    cardChildren[index][oldIndex] = cardChildren[index][newIndex];
    cardChildren[index][newIndex] = oldValue;
    setState(() {});
  }

  _buildBody() {
    return DefaultContainer(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length + 1,
        itemBuilder: (context, index) {
          if (index == cards.length)
            return _buildAddCardWidget(context);
          else
            return _buildCard(context, index);
        },
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
    int showMaxCard = cardChildren[index].length > maxCard
        ? maxCard
        : cardChildren[index].length;

    // print(64.0)
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
            height: (showMaxCard * (eachRowHeight) + titleHeight + buttonHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    cards[index],
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
                    Container(
                      height: (showMaxCard * (eachRowHeight)),
                      child: DragAndDropList<String>(
                        cardChildren[index],
                        itemBuilder: (BuildContext context, item) {
                          return _buildCardTask(
                              index, cardChildren[index].indexOf(item));
                        },
                        onDragFinish: (oldIndex, newIndex) {
                          _handleReOrder(oldIndex, newIndex, index);
                        },
                        canBeDraggedTo: (one, two) => true,
                        dragElevation: 8.0,
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
                // if (data['from'] == index) {// that will not allow to drag both children in one list
                //   return false;
                // }
                // print(data);
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                // if (data['from'] == index) {// that will not allow to drag both children in one list
                //   return;
                // }
                cardChildren[data['from']].remove(data['string']);
                cardChildren[index].add(data['string']);
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
      width: 300.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            width: 284.0,
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Text(cardChildren[index][innerIndex]),
          ),
        ),
        childWhenDragging: Container(),
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
              Text(cardChildren[index][innerIndex],
                  style: TextStyle(fontSize: 16.0)),
              IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      cardChildren[index].removeAt(innerIndex);
                    });
                  })
            ],
          ),
        ),
        data: {"from": index, "string": cardChildren[index][innerIndex]},
      ),
    );
  }
}

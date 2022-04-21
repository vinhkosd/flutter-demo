import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_demo/screens/page/edit_create.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.url}) : super(key: key);
  String url = "";
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> users = [
    {"name": "John", "age": 18},
  ];
  List<String> cards = ["ToDo", "Completed"];
  List<List<String>> childres = [
    ["ToDo 1", "ToDo 2", "ToDo 3"],
    ["Done 1", "Done 2"],
  ];
  String state = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trello Cards"),
      ),
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
                  child: RaisedButton(
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
    childres.add([]);
    _cardTextController.text = "";
    setState(() {});
  }

  _addCardTask(int index, String text) {
    childres[index].add(text);
    _cardTextController.text = "";
    setState(() {});
  }

  _handleReOrder(int oldIndex, int newIndex, int index) {
    var oldValue = childres[index][oldIndex];
    childres[index][oldIndex] = childres[index][newIndex];
    childres[index][newIndex] = oldValue;
    setState(() {});
  }

  _buildBody() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index == cards.length)
          return _buildAddCardWidget(context);
        else
          return _buildCard(context, index);
      },
    );
  }

  Widget _buildAddCardWidget(context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            _showAddCard();
          },
          child: Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    color: Color.fromRGBO(127, 140, 141, 0.5),
                    spreadRadius: 2)
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text("Add Card"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _modal() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(child: UploadPage());
        });
  }

  Widget _buildCard(BuildContext context, int index) {
    Future<List<List<String>>> uploadImage(List<List<String>> title) async {
      final response = await http.post(
        Uri.parse('http://171.244.203.21:8888/api/v1/course/editOrCreate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, List<List<String>>>{
          'title': title,
        }),
      );

      if (response.statusCode == 200) {
        var a = (jsonDecode(response.body));
      } else {
        childres = jsonDecode(response.body);
        throw Exception('Failed to update album.');
      }
    }

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
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                      onTap: () {
                        _modal();
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            cards[index],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: DragAndDropList<String>(
                      childres[index],
                      itemBuilder: (BuildContext context, item) {
                        return _buildCardTask(
                            index, childres[index].indexOf(item));
                      },
                      onDragFinish: (oldIndex, newIndex) {
                        _handleReOrder(oldIndex, newIndex, index);
                      },
                      canBeDraggedTo: (one, two) => true,
                      dragElevation: 8.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DragTarget<dynamic>(
              onWillAccept: (data) {
                return true;
              },
              onLeave: (data) {},
              onAccept: (data) {
                if (data['from'] == index) {
                  return;
                }
                childres[data['from']].remove(data['string']);
                childres[index].add(data['string']);
                setState(() {});
              },
              builder: (context, accept, reject) {
                print("--- > $accept");
                print(reject);
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCardTask(int index, int innerIndex) {
    // print(innerIndex);
    return Container(
      width: 300.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Draggable<dynamic>(
        feedback: Material(
          elevation: 5.0,
          child: Container(
            width: 284.0,
            padding: const EdgeInsets.all(16.0),
            color: Colors.greenAccent,
            child: Text(childres[index][innerIndex]),
          ),
        ),
        childWhenDragging: Container(),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.greenAccent,
          child: InkWell(
            onTap: () {
              final LocalStorage storage = new LocalStorage('test');
              var name = childres[index][innerIndex];
              storage.setItem('todos', name);
              _modal();
            },
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16.0,
                ),
                Text(childres[index][innerIndex]),
                Icon(
                  Icons.edit,
                ),
              ],
            ),
          ),
          // child: Text(childres[index][innerIndex]),
        ),
        data: {"from": index, "string": childres[index][innerIndex]},
      ),
    );
  }
}

class Album {
  final int id;
  final String title;

  const Album(json, {this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      json,
    );
  }
}

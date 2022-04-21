import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.url}) : super(key: key);
  String url = "";
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final LocalStorage storage = new LocalStorage('test');

  Future<String> uploadImage(filename) async {
    var name = storage.getItem('todos') ?? "";
    var url = 'http://171.244.203.21:8888/api/v1/course/uploadFile';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = name;
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    var res = await request.send();
    var responesed = await http.Response.fromStream(res);
    Map<String, dynamic> body = jsonDecode(responesed.body);
    await storage.clear();
    return body["name"];
  }

  Future<String> addCard(text) async {
    print(text);
    var url = Uri.parse('http://171.244.203.21:8888/api/v1/course/addtest');
    var response = await http.put(url, body: {'name': text});
    return response.body;
  }

  String state = "";

  @override
  Widget build(BuildContext context) {
    TextEditingController _cardTextController = TextEditingController();
    var name = storage.getItem('todos') ?? "";
    // print(storage.getItem('todos'));
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Flutter File Upload Example'),
      // ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: "Card Title"),
              controller: _cardTextController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(children: [
              Image.network("http://171.244.203.21:8888/storage/avatars/" +
                  name +
                  "/" +
                  state),
              FloatingActionButton(
                onPressed: () async {
                  var file = await ImagePicker.platform.getImage(
                    source: ImageSource.gallery,
                    maxWidth: null,
                    maxHeight: null,
                    imageQuality: null,
                    preferredCameraDevice: CameraDevice.rear,
                  );
                  var res = await uploadImage(file.path);
                  print("http://171.244.203.21:8888/storage/avatars/" +
                      name +
                      "/" +
                      res);
                  setState(() {
                    state = res;
                  });
                },
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 8,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter your text explain"),
              // controller: _cardTextController,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     Navigator.of(context).pop();
      //     // _addCard(_cardTextController.text.trim());
      //     var res = await addCard(_cardTextController.text);
      //     print(res);
      //     // setState(() {
      //     //   state = res;
      //     //   // print(res);
      //     // });
      //   },
      // ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/MenuController.dart';
import 'package:flutter_demo/helpers/loading.dart';
import 'package:flutter_demo/helpers/utils.dart';
import 'package:flutter_demo/screens/navbar/side_menu.dart';
import 'package:flutter_demo/widget/default_container.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool processing = true;
  String _selectedNode;
  List<Node> _nodes;
  TreeViewController _treeViewController;

  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;
  bool _allowParentSelect = false;
  bool _supportParentDoubleTap = false;
  List<Node> buildNode(Map<String, dynamic> body) {
    List<Node> listNodes = <Node>[];
    if (body['items'] != null) {
      body['items'].forEach((elm) {
        if (elm['children'] != null) {
          listNodes.add(Node(
              label: elm["name"],
              key: elm["keyword"],
              children: buildChildNode(elm['children'])));
        }
      });
    }

    return listNodes;
  }

  List<Node> buildChildNode(List<dynamic> body) {
    List<Node> nodes = <Node>[];
    if (body != null && body is List && body.length > 0) {
      body.forEach((elm) {
        if (elm['children'] != null) {
          if (elm["name"] != null) {
            nodes.add(Node(
                label: elm["name"],
                key: elm["keyword"],
                children: buildChildNode(elm['children'])));
          }
        }
      });
    }
    return nodes;
  }

  @override
  void initState() {
    _nodes = [];
    _treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );

    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String _jsonData = await Utils.getUrl('product-groups/parents');

    setState(() {
      _nodes = (buildNode(jsonDecode(_jsonData)));
      _treeViewController = _treeViewController.copyWith(
        children: _nodes,
      );
    });
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    if (this.processing) {
      return loadingProcess(context, "Đang tải dữ liệu");
    }

    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
          type: _expanderType,
          modifier: _expanderModifier,
          position: _expanderPosition,
          // color: Colors.grey.shade800,
          size: 20,
          color: Colors.blue),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );
    return Scaffold(
       key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: DefaultContainer(
        child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: TreeView(
                    controller: _treeViewController,
                    allowParentSelect: _allowParentSelect,
                    supportParentDoubleTap: _supportParentDoubleTap,
                    onExpansionChanged: (key, expanded) =>
                        _expandNode(key, expanded),
                    onNodeTap: (key) {
                      setState(() {
                        _selectedNode = key;
                        _treeViewController =
                            _treeViewController.copyWith(selectedKey: key);
                      });
                    },
                    theme: _treeViewTheme,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(_treeViewController.getNode(_selectedNode) == null
                      ? ''
                      : _treeViewController.getNode(_selectedNode).label),
                ),
              )
            ],
          ),
        ),
      ),
    )
    );
  }

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
              icon: expanded ? Icons.folder_open : Icons.folder,
            ));
      } else {
        updated = _treeViewController.updateNode(
            key, node.copyWith(expanded: expanded));
      }
      setState(() {
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}

class ModContainer extends StatelessWidget {
  final ExpanderModifier modifier;

  const ModContainer(this.modifier, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _backAltColor = Colors.grey.shade700;
    switch (modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = 1;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: _backAltColor,
              ),
        color: _backColor,
      ),
      width: 15,
      height: 15,
    );
  }
}

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

const List<Map<String, dynamic>> US_STATES = [
  {
    "label": "A",
    "children": [
      {"label": "Alabama", "key": "AL"},
      {"label": "Alaska", "key": "AK"},
      {"label": "American Samoa", "key": "AS"},
      {"label": "Arizona", "key": "AZ"},
      {"label": "Arkansas", "key": "AR"}
    ]
  },
  {
    "label": "C",
    "children": [
      {"label": "California", "key": "CA"},
      {"label": "Colorado", "key": "CO"},
      {"label": "Connecticut", "key": "CT"},
    ]
  },
  {
    "label": "D",
    "children": [
      {"label": "Delaware", "key": "DE"},
      {"label": "District Of Columbia", "key": "DC"},
    ]
  },
  {
    "label": "F",
    "children": [
      {"label": "Federated States Of Micronesia", "key": "FM"},
      {"label": "Florida", "key": "FL"},
    ]
  },
  {
    "label": "G",
    "children": [
      {"label": "Georgia", "key": "GA"},
      {"label": "Guam", "key": "GU"},
    ]
  },
  {
    "label": "H",
    "children": [
      {"label": "Hawaii", "key": "HI"},
    ]
  },
  {
    "label": "I",
    "children": [
      {"label": "Idaho", "key": "ID"},
      {"label": "Illinois", "key": "IL"},
      {"label": "Indiana", "key": "IN"},
      {"label": "Iowa", "key": "IA"},
    ]
  },
  {
    "label": "K",
    "children": [
      {"label": "Kansas", "key": "KS"},
      {"label": "Kentucky", "key": "KY"},
    ]
  },
  {
    "label": "L",
    "children": [
      {"label": "Louisiana", "key": "LA"},
    ]
  },
  {
    "label": "M",
    "children": [
      {"label": "Maine", "key": "ME"},
      {"label": "Marshall Islands", "key": "MH"},
      {"label": "Maryland", "key": "MD"},
      {"label": "Massachusetts", "key": "MA"},
      {"label": "Michigan", "key": "MI"},
      {"label": "Minnesota", "key": "MN"},
      {"label": "Mississippi", "key": "MS"},
      {"label": "Missouri", "key": "MO"},
      {"label": "Montana", "key": "MT"},
    ]
  },
  {
    "label": "N",
    "children": [
      {"label": "Nebraska", "key": "NE"},
      {"label": "Nevada", "key": "NV"},
      {"label": "New Hampshire", "key": "NH"},
      {"label": "New Jersey", "key": "NJ"},
      {"label": "New Mexico", "key": "NM"},
      {"label": "New York", "key": "NY"},
      {"label": "North Carolina", "key": "NC"},
      {"label": "North Dakota", "key": "ND"},
      {"label": "Northern Mariana Islands", "key": "MP"},
    ]
  },
  {
    "label": "O",
    "children": [
      {"label": "Ohio", "key": "OH"},
      {"label": "Oklahoma", "key": "OK"},
      {"label": "Oregon", "key": "OR"},
    ]
  },
  {
    "label": "P",
    "children": [
      {"label": "Palau", "key": "PW"},
      {"label": "Pennsylvania", "key": "PA"},
      {"label": "Puerto Rico", "key": "PR"},
    ]
  },
  {
    "label": "R",
    "children": [
      {"label": "Rhode Island", "key": "RI"},
    ]
  },
  {
    "label": "S",
    "children": [
      {"label": "South Carolina", "key": "SC"},
      {"label": "South Dakota", "key": "SD"},
    ]
  },
  {
    "label": "T",
    "children": [
      {"label": "Tennessee", "key": "TN"},
      {"label": "Texas", "key": "TX"},
    ]
  },
  {
    "label": "U",
    "children": [
      {"label": "Utah", "key": "UT"},
    ]
  },
  {
    "label": "V",
    "children": [
      {"label": "Vermont", "key": "VT"},
      {"label": "Virgin Islands", "key": "VI"},
      {"label": "Virginia", "key": "VA"},
    ]
  },
  {
    "label": "W",
    "children": [
      {"label": "Washington", "key": "WA"},
      {"label": "West Virginia", "key": "WV"},
      {"label": "Wisconsin", "key": "WI"},
      {"label": "Wyoming", "key": "WY"}
    ]
  },
];

String US_STATES_JSON = jsonEncode(US_STATES);

class Products extends StatefulWidget {
  Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  static String jsonData = "{}";
  bool processing = true;
  String _selectedNode;
  List<Node> _nodes;
  TreeViewController _treeViewController;
  // bool docsOpen = true;
  bool deepExpanded = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = {
    ExpanderType.none: Container(),
    ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: Icon(Icons.arrow_downward),
    ExpanderType.chevron: Icon(Icons.expand_more),
    ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<ExpanderModifier, Widget> expansionModifierOptions = const {
    ExpanderModifier.none: ModContainer(ExpanderModifier.none),
    ExpanderModifier.circleFilled: ModContainer(ExpanderModifier.circleFilled),
    ExpanderModifier.circleOutlined:
        ModContainer(ExpanderModifier.circleOutlined),
    ExpanderModifier.squareFilled: ModContainer(ExpanderModifier.squareFilled),
    ExpanderModifier.squareOutlined:
        ModContainer(ExpanderModifier.squareOutlined),
  };
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
          print(elm);
          listNodes.add(Node(
              label: elm["name"],
              key: elm["keyword"],
              children: buildChildNode(elm['children'])));
        }
        // List<DataCell> cells = [];
        // rowList.forEach((columnName, columnTitle) {
        //   cells.add(DataCell(Text((elm[columnName] ?? '').toString())));
        // });
        // cells.add(DataCell(TableActionButton(
        //     action: "user",
        //     id: elm['id'],
        //     textButton: 'Edit',
        //     data: elm,
        //     columns: rowList)));

        // rows.add(new DataRow(cells: cells));
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
            // print('elm');
            // print(elm);
            nodes.add(Node(
                label: elm["name"],
                key: elm["keyword"],
                children: buildChildNode(elm['children'])));
            // buildChildNode(elm['children']);
          }
        }
        // List<DataCell> cells = [];
        // rowList.forEach((columnName, columnTitle) {
        //   cells.add(DataCell(Text((elm[columnName] ?? '').toString())));
        // });
        // cells.add(DataCell(TableActionButton(
        //     action: "user",
        //     id: elm['id'],
        //     textButton: 'Edit',
        //     data: elm,
        //     columns: rowList)));

        // rows.add(new DataRow(cells: cells));
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
    // Map<String, dynamic>

    setState(() {
      jsonData = jsonEncode(jsonDecode(_jsonData)["items"]);
      _nodes = (buildNode(jsonDecode(_jsonData)));
      _treeViewController = _treeViewController.copyWith(
        children: _nodes,
      );
    });
    processing = false;
  }

  ListTile _makeExpanderPosition() {
    return ListTile(
      title: Text('Expander Position'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionPositionOptions,
        groupValue: _expanderPosition,
        onValueChanged: (ExpanderPosition newValue) {
          setState(() {
            _expanderPosition = newValue;
          });
        },
      ),
    );
  }

  SwitchListTile _makeAllowParentSelect() {
    return SwitchListTile.adaptive(
      title: Text('Allow Parent Select'),
      dense: true,
      value: _allowParentSelect,
      onChanged: (v) {
        setState(() {
          _allowParentSelect = v;
        });
      },
    );
  }

  SwitchListTile _makeSupportParentDoubleTap() {
    return SwitchListTile.adaptive(
      title: Text('Support Parent Double Tap'),
      dense: true,
      value: _supportParentDoubleTap,
      onChanged: (v) {
        setState(() {
          _supportParentDoubleTap = v;
        });
      },
    );
  }

  ListTile _makeExpanderType() {
    return ListTile(
      title: Text('Expander Style'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionTypeOptions,
        groupValue: _expanderType,
        onValueChanged: (ExpanderType newValue) {
          setState(() {
            _expanderType = newValue;
          });
        },
      ),
    );
  }

  ListTile _makeExpanderModifier() {
    return ListTile(
      title: Text('Expander Modifier'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionModifierOptions,
        groupValue: _expanderModifier,
        onValueChanged: (ExpanderModifier newValue) {
          setState(() {
            _expanderModifier = newValue;
          });
        },
      ),
    );
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
              Container(
                height: 160,
                child: Column(
                  children: <Widget>[
                    // _makeExpanderPosition(),
                    // _makeExpanderType(),
                    // _makeExpanderModifier(),
//                    _makeAllowParentSelect(),
//                    _makeSupportParentDoubleTap(),
                  ],
                ),
              ),
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
                      debugPrint('Selected: $key');
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
                  debugPrint('Close Keyboard');
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
    debugPrint(msg);
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
        // if (key == 'docs') docsOpen = expanded;
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

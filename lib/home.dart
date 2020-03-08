import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mt_flutter/menu_config.dart';
import 'package:mt_flutter/wigets/mt_expansion_menu.dart';
import 'dart:html' as html;

List<Color> list = [
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.black87
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

TabController _tabController;
List<MenuItem> _listMenuItem;

const int turnsToRotateRight = 3;
const int turnsToRotateLeft = 1;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _listMenuItem = buildMenu();

    _tabController = TabController(
      length: _getMenuItemNum(_listMenuItem),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    // final Key<LinearProgressIndicator> _scaffoldKey =
    //     new GlobalKey<LinearProgressIndicator>();

    final GlobalKey<MTFLMenuState> _mTFLMenuKey =
        new GlobalKey<MTFLMenuState>();

    return Stack(children: <Widget>[
      Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Builder(builder: (BuildContext context) {
              return Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _mTFLMenuKey.currentState.toggle();
                    },
                  ),
                ],
              );
            }),
            title: Builder(builder: (BuildContext context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('ML后台工具'),
                ],
              );
            }),
            // Image.asset(', fit: BoxFit.cover)
          ),
          body: Row(children: <Widget>[
            MTFLMenu(_mTFLMenuKey, _listMenuItem, _tabController),
            Expanded(
              child: RotatedBox(
                quarterTurns: turnsToRotateLeft,
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: _buildView(_listMenuItem)),
              ),
            )
          ])),
      // LinearProgressIndicator(),
    ]);
  }

  List<Widget> _buildView(List<MenuItem> menuItem) {
    List<Widget> _list = new List<Widget>();
    int index = -1;
    menuItem.forEach((value) {
      value.children.forEach((v) {
        index++;
        _list.add(RotatedBox(
            quarterTurns: turnsToRotateRight,
            child: (v.view != null)
                ? v.view
                : Container(
                    color: list[index % list.length],
                    child: new Center(
                      child: new Text(
                        "$index",
                        style:
                            new TextStyle(fontSize: 80.0, color: Colors.white),
                      ),
                    ),
                  )));
      });
    });
    return _list;
  }

  int _getMenuItemNum(List<MenuItem> menuItem) {
    int itemNum = 0;
    menuItem.asMap().forEach((key, value) {
      value.children.asMap().forEach((k, v) {
        itemNum++;
      });
    });
    return itemNum;
  }
}

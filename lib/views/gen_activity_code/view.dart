import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mt_flutter/wigets/flutter_syntax_view.dart';

class CodeData {
  CodeData(this.sFileName, this.sCodeContent);
  String sFileName;
  String sCodeContent;
}

class GenActivityPage extends StatefulWidget {
  @override
  _GenActivityPageState createState() => _GenActivityPageState();
}

class _GenActivityPageState extends State<GenActivityPage>
    with TickerProviderStateMixin {
  List<CodeData> _listCodeData = List<CodeData>();

  @override
  Widget build(BuildContext context) {
    _listCodeData.add(CodeData("a.h", '''
    #include <iostream>

    using namespace std;

    int main()
    {
        cout<<"Hello World";

        return 0;
    }


    '''));
    _listCodeData.add(CodeData("a.h", '''
    #include <iostream>

    using namespace std;

    int main()
    {
        cout<<"Hello World";

        return 0;
    }


    '''));
    _listCodeData.add(CodeData("a.h", '''
    #include <iostream>

    using namespace std;

    int main()
    {
        cout<<"Hello World";

        return 0;
    }


    '''));
    _listCodeData.add(CodeData("a.h", '''
    #include <iostream>

    using namespace std;
    class aa{
      int a;
    }
    int main()
    {
        cout<<"Hello World";
        uint32_t i = 0;
        int j = 0;  
        aa a;
        a.a = 0;
        return 0;
    }
        using namespace std11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    class aa{
      int a;
    }
    int main()
    {
        cout<<"Hello World";
        uint32_t i = 0;
        int j = 0;  
        aa a;
        a.a = 0;
        return 0;
    }
        using namespace std;
    class aa{
      int a;
    }
    int main()
    {
        cout<<"Hello World";
        uint32_t i = 0;
        int j = 0;  
        aa a;
        a.a = 0;
        return 0;
    }
        using namespace std;
    class aa{
      int a;
    }
    int main()
    {
        cout<<"Hello World";
        uint32_t i = 0;
        int j = 0;  
        aa a;
        a.a = 0;
        return 0;
    }
        using namespace std;
    class aa{
      int a;
    }
    int main()
    {
        cout<<"Hello World";
        uint32_t i = 0;
        int j = 0;  
        aa a;
        a.a = 0;
        return 0;
    }


    '''));
    TabController _tabController =
        TabController(length: _listCodeData.length, vsync: this);

    Widget tabbar = TabBar(
        isScrollable: false,
        controller: _tabController,
        tabs: _listCodeData.map<Widget>((element) {
          return Tab(
            icon: Row(
              children: <Widget>[
                Icon(Icons.insert_drive_file),
                SizedBox(
                  width: 8,
                ),
                Text(element.sFileName),
              ],
            ),
            iconMargin: const EdgeInsets.only(bottom: 10.0),
          );
        }).toList());

    var tabview = TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _listCodeData.map<Widget>((element) {
          return SyntaxView(
            code: element.sCodeContent,
            syntax: Syntax.CPP,
            syntaxTheme: SyntaxTheme.dracula(),
            withLinesCount: true,
            withZoom: false,
          );
        }).toList());
    // final backButtonFocusNode =
    //     InheritedFocusNodes.of(context).backButtonFocusNode;
    //table 布局
    var speedDial = SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      // visible: _dialVisible,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.content_copy),
          backgroundColor: Colors.blue,
          label: '复制到剪切板',
          labelBackgroundColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
        ),
        SpeedDialChild(
          child: Icon(Icons.file_download),
          backgroundColor: Colors.green,
          label: '导出当前文件',
          labelBackgroundColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
        ),
      ],
    );

    return Row(
      children: <Widget>[
        Expanded(
          // width: 900,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: tabbar,
            ),
            body: tabview,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: speedDial,
            // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          ),
        ),
        Container(
          width: 300,
          child: Scaffold(
              // appBar: tabbar,
              // body: tabview,

              // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
              ),
        )
      ],
    );
  }
}

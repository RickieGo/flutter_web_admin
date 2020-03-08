import 'package:flutter/material.dart';
import 'package:mt_flutter/wigets/mt_expansion_panel.dart' as custom;
import 'package:flutter/foundation.dart';
import 'package:transformer_page_view/index_controller.dart';
// import 'package:provider/provider.dart';

class MenuModel with ChangeNotifier {
  /// Internal, private state of the cart.
  bool bMenuCollapsed;

  /// An unmodifiable view of the items in the cart.

  /// The current total price of all items (assuming all items cost $42).

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void openMenu() {
    bMenuCollapsed = !bMenuCollapsed;
    // Thsi call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

class MTFLMenu extends StatefulWidget {
  MTFLMenu(this.key, this.itemData, this.controller);

  @override
  MTFLMenuState createState() => MTFLMenuState();

  final GlobalKey key;
  final List<MenuItem> itemData;
  final TabController controller;
}

class SubMenuItem {
  SubMenuItem({
    this.tittle,
    this.view,
  });
  String tittle;
  Widget view;
}

class MenuItem {
  MenuItem({
    this.iconData,
    this.tittle,
    this.children,
  });
  IconData iconData;
  String tittle;
  int selectIndex;
  List<SubMenuItem> children = const <SubMenuItem>[];
}

class MTFLMenuState extends State<MTFLMenu>
    with SingleTickerProviderStateMixin {
  double maxWidth = 250;
  double minWidgth = 0;
  bool collapsed = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildPanel() {
    // final model = Provider.of<MenuModel>(context);
    int indexKey = -1;
    return custom.ExpansionPanelList.radio(
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            // _data[index].isExpanded = !isExpanded;
          });
        },
        children:
            widget.itemData.asMap().entries.map<custom.ExpansionPanel>((entry) {
          MenuItem item = entry.value;
          return custom.ExpansionPanelRadio(
            value: entry.key,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Row(children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(
                    item.iconData,
                  ),
                ),
                Spacer(),
                Text(item.tittle),
                Spacer(),
              ]);
            },
            body: Column(
              children: item.children.asMap().entries.map<Widget>((e) {
                indexKey++;
                return MenuItemTile(
                  title: e.value.tittle,
                  uniindex: indexKey,
                  index: e.key,
                  selectIndex: selectedIndex,
                  onTap: (int index) {
                    _handleTileOnTap(index);
                  },
                );
              }).toList(),
            ),
          );
        }).toList());
  }

  void _handleTileOnTap(int index) {
    // if ((selectedIndex - index).abs() == 1) {
    //   await widget.controller.move(index, animation: true);
    // } else {
    //   int initialIndex = 0;
    //   initialIndex = index > selectedIndex ? index - 1 : index + 1;
    //   await widget.controller.move(initialIndex, animation: false);
    //   await widget.controller.move(index, animation: true);
    // }
    // debugPrint(index.toString());

    setState(() {
      selectedIndex = index;
      widget.controller.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var leftmenu = Container(
      // color: theme.popupMenuTheme.color,
      width: maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DrawerHeader(
            margin: const EdgeInsets.only(),
            child: Center(
                child: Container(
              child: Image(image: AssetImage('assets/logo/logo.png')),
            )),
          ),
          _buildPanel()
        ],
      ),
    );

    // return AnimatedBuilder(
    // animation: _animation,
    // builder: (BuildContext context, Widget child) {

    return AnimatedCrossFade(
      firstChild: Container(
        width: 0,
        height: 0,
      ),
      secondChild: leftmenu,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          collapsed ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 200),
    );
  }

  void toggle() {
    setState(() {
      collapsed = !collapsed;
    });
  }
}

class MenuItemTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  final int uniindex;
  final int selectIndex;
  final int index;
  const MenuItemTile({
    Key key,
    @required this.title,
    this.icon,
    this.animationController,
    this.isSelected = false,
    @required this.onTap,
    this.uniindex,
    this.selectIndex,
    this.index,
  }) : super(key: key);

  @override
  _MenuItemTileState createState() => _MenuItemTileState();
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is _SaltedKey<S, V> &&
        other.salt == salt &&
        other.value == value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

class _MenuItemTileState extends State<MenuItemTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    // items.add(MaterialGap(
    //     size: 1,
    //     key: _SaltedKey<BuildContext, int>(context, widget.index * 2 + 1)));

    items.add(MaterialSlice(
        key: _SaltedKey<BuildContext, int>(context, widget.uniindex * 2),
        child: InkWell(
            onTap: () {
              this.widget.onTap(widget.uniindex);
            },
            child: Column(children: <Widget>[
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: (widget.uniindex != widget.selectIndex)
                      ? Theme.of(context).selectedRowColor
                      : Theme.of(context).splashColor,
                ),
                child: Stack(children: <Widget>[
                  Center(child: Text(this.widget.title)),
                  (widget.uniindex == widget.selectIndex)
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).indicatorColor,
                            ),
                          ),
                        )
                      : Container()
                ]),
              ),
            ]))));

    return MergeableMaterial(
      hasDividers: true,
      children: items,
    );
  }
}

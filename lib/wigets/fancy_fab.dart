import 'package:flutter/material.dart';

class FabData {
  FabData(this.onPress, this.iconData, this.stoolTips);
  Function onPress;
  IconData iconData;
  String stoolTips;
}

class FancyFab extends StatefulWidget {
  // final Function() onPressed;
  final String tooltip;
  final List<FabData> optional;

  FancyFab({this.optional, this.tooltip});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;
  bool collapsed = false;
  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    Widget toggle = FloatingActionButton(
      onPressed: () {
        animate();
        collapsed = !collapsed;

        setState(() {});
      },
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );

    var options = Column(
      children: widget.optional
          .map((e) => FloatingActionButton(
              onPressed: e.onPress,
              tooltip: e.stoolTips,
              child: Icon(e.iconData)))
          .toList()
            ..add(toggle),
    );

    return AnimatedCrossFade(
      firstChild: options,
      secondChild: Column(children: [toggle]),
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          collapsed ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 200),
    );
  }
}

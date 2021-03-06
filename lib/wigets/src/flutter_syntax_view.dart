import 'dart:math';
import 'package:flutter/material.dart';

import 'syntaxes/base.dart';
import 'syntaxes/index.dart';

class SyntaxView extends StatefulWidget {
  SyntaxView(
      {@required this.code,
      @required this.syntax,
      this.syntaxTheme,
      this.withZoom,
      this.withLinesCount});

  final String code;
  final Syntax syntax;
  final bool withZoom;
  final bool withLinesCount;
  final SyntaxTheme syntaxTheme;

  @override
  State<StatefulWidget> createState() => SyntaxViewState();
}

class SyntaxViewState extends State<SyntaxView> {
  /// Zoom Controls
  double textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    assert(widget.code != null,
        "Code Content must not be null.\n===| if you are loading a String from assets, make sure you declare it in pubspec.yaml |===");
    assert(widget.syntax != null,
        "Syntax must not be null. select a Syntax by calling Syntax.(Language)");

    final int numLines = (widget.withLinesCount ?? true)
        ? '\n'.allMatches(widget.code).length + 1
        : 0;

    List<RichText> _listLineNum = List<RichText>();
    for (int i = 1; i <= numLines; i++)
      _listLineNum.add(RichText(
          textScaleFactor: textScaleFactor,
          text: TextSpan(
              style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15.0,
                  color: (widget.syntaxTheme ?? SyntaxTheme.dracula())
                      .linesCountColor),
              text: "$i")));

    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      Container(
          padding: (widget.withLinesCount ?? true)
              ? EdgeInsets.only(left: 5, top: 10, right: 10, bottom: 10)
              : EdgeInsets.all(10),
          color: (widget.syntaxTheme ?? SyntaxTheme.dracula()).backgroundColor,
          constraints: BoxConstraints.expand(),
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:

                          /// Lines Count in the left with Code view
                          (widget.withLinesCount ?? true)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(children: _listLineNum),
                                    VerticalDivider(
                                      width: 5,
                                      color: Colors.black87,
                                    ),
                                    RichText(
                                      textScaleFactor: textScaleFactor,
                                      text: TextSpan(
                                        style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 15.0),
                                        children: <TextSpan>[
                                          getSyntax(widget.syntax,
                                                  widget.syntaxTheme)
                                              .format(widget.code)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              :

                              /// Only Code view
                              RichText(
                                  textScaleFactor: textScaleFactor,
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 15.0),
                                    children: <TextSpan>[
                                      getSyntax(
                                              widget.syntax, widget.syntaxTheme)
                                          .format(widget.code)
                                    ],
                                  ),
                                ))))),

      /// Zoom Controls
      widget.withZoom == false
          ? Container()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.zoom_out,
                        color: (widget.syntaxTheme ?? SyntaxTheme.dracula())
                            .zoomIconColor),
                    onPressed: () => setState(() {
                          if (mounted)
                            textScaleFactor = max(0.8, textScaleFactor - 0.1);
                        })),
                IconButton(
                    icon: Icon(Icons.zoom_in,
                        color: (widget.syntaxTheme ?? SyntaxTheme.dracula())
                            .zoomIconColor),
                    onPressed: () => setState(() {
                          if (mounted) {
                            if (textScaleFactor <= 4.0)
                              textScaleFactor += 0.1;
                            else
                              print(
                                  "Maximun zoomable scale (4.0) has been reached. more zooming can cause a crash.");
                          }
                        })),
              ],
            )
    ]);
  }
}

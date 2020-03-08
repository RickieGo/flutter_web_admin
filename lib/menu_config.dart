import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mt_flutter/highlight.dart';
import 'package:mt_flutter/wigets/mt_expansion_menu.dart';
import 'package:mt_flutter/views/gen_activity_code/view.dart';

import 'package:easy_web_view/easy_web_view.dart';

var code = '''
```cpp
    #include <iostream>

    using namespace std;

    int main()
    {
        cout<<"Hello World";

        return 0;
    }
```

''';

var css = '''
<html>

<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.8.0/styles/default.min.css">
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.8.0/highlight.min.js"></script>
<title> 七彩剑殇</title>



<style type="text/css">
html, body {
  background-color: rgb(250, 250, 250);
  font-family: Roboto,"Helvetica Neue",sans-serif;
  font-size: 16px;
  margin: 0;
}

.container {
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
}

.main {
  align-items: stretch;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  height: 100%;
  margin: 32px;
}

.version {
  color: rgba(0, 0, 0, 0.54);
  margin-right: 16px;
}

.card {
  /* Styled like Material Cards. */
  color: rgba(0, 0, 0, 0.87);
  background-color: white;
  border-radius: 2px;
  box-sizing: border-box;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, .2),
              0 1px 1px 0 rgba(0, 0, 0, .14),
              0 2px 1px -1px rgba(0, 0, 0, .12);
  margin: 8px;

  /* Positioned next to each other. */
  display: flex;
  flex: 1 1 50%;
  flex-direction: column;
  max-height: 100%;
  max-width: 50%;
  min-height: 400px;
}

.toolbar {
  /* Styled like Material Toolbar. */
  align-items: center;
  background-color: #22d3c5; /* Taken from webdev.dartlang.org. */
  box-sizing: border-box;
  color: rgba(0, 0, 0, 0.87);
  display: flex;
  font-size: 20px;
  line-height: 1.4;
  margin: 0;
  min-height: 64px;
  padding: 0 16px;
  position: relative;
  width: 100%;
}

.toolbar h2 {
  font-size: inherit;
  font-weight: inherit;
  margin: inherit;
}

.toolbar a:link,
.toolbar a:visited {
  color: rgba(0, 0, 0, 0.87);
}

.toolbar svg {
  fill: currentColor;
}

.card .toolbar {
  border-radius: 3px 3px 0 0;
}

.textarea-container {
  display: flex;
  height: 100%;
  padding: 8px;
}

textarea {
  border-color: rgba(0, 0, 0, 0.12);
  border-width: 0 0 1px;
  box-sizing: border-box;
  color: rgba(0, 0, 0, 0.87);
  font-family: "Roboto Mono",monospace;
  font-size: 100%;
  line-height: 26px;
  overflow: auto;
  padding: 2px 2px 1px;
  width: 100%;
}

textarea:focus {
  border-color: #22d3c5; /* Taken from webdev.dartlang.org. */
  border-width: 0 0 2px;
  outline: 0;
  padding-bottom: 0;
}

#html {
  overflow: auto;
  padding: 8px;
}

footer {
  box-sizing: border-box;
  display: flex;
  font-size: 20px;
  height: 64px;
  padding: 0 16px;
}

footer a:link,
footer a:visited {
  color: rgba(0, 0, 0, 0.87);
}

.radio {
  cursor: pointer;
  display: inline-block;
  margin-right: 16px;
}

i.glyph {
  display: inline-block;
  font-family: 'Material Icons Extended';
  font-size: 16px;
  font-style: normal;
  font-weight: normal;
  line-height: 1;
}

.radio[checked] i.glyph {
  color: #22d3c5;
}

i.glyph.big {
  font-size: 32px;
  height: 32px;
  width: 32px;
}
</style>

</head>
    <body>
''';

var end = '''
</body>
</html>
''';

List<MenuItem> buildMenu() {
  code = md.markdownToHtml(code);
  // highlightBlock(code);

  debugPrint(code);

  String sHtmlString = ''' 
  <!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜鸟教程(runoob.com)</title>
</head>
<body>
    <h1>我的第一个标题</h1>
    <p>我的第一个段落。</p>
</body>
</html>
''';
  return [
    MenuItem(iconData: Icons.code, tittle: "代码生成工具", children: [
      SubMenuItem(
        tittle: "生成活动代码",
        view: GenActivityPage(),
      ),
      SubMenuItem(
        tittle: "生成活动协议",
      ),
      SubMenuItem(
        tittle: "生成模块协议",
      ),
      SubMenuItem(
        tittle: "生成Service协议",
      ),
      SubMenuItem(
        tittle: "生成表格代码",
      ),
    ]),
    // MenuItem(iconData: Icons.publish, tittle: "内网服务器发布", children: [
    //   SubMenuItem(
    //     tittle: "发布GameServer7000",
    //   ),
    //   SubMenuItem(
    //     tittle: "发布GameServer8000",
    //   ),
    // ]),
    // MenuItem(iconData: Icons.assignment, tittle: "日志查看", children: [
    //   SubMenuItem(
    //     tittle: "GameServer协议日志",
    //   ),
    //   SubMenuItem(
    //     tittle: "GameServer滚动日志",
    //   ),
    //   SubMenuItem(
    //     tittle: "GameServer错误日志",
    //   ),
    // ]),
    MenuItem(iconData: Icons.android, tittle: "自动化工具", children: [
      SubMenuItem(
        tittle: "客户端模拟工具",
      )
    ]),
    MenuItem(iconData: Icons.track_changes, tittle: "检测工具", children: [
      SubMenuItem(
        tittle: "检测活动数据",
      )
    ]),

    MenuItem(iconData: Icons.android, tittle: "测试", children: [
      SubMenuItem(
          tittle: "测试markdown",
          view: EasyWebView(
            // src: Uri.dataFromString(css + code + end,
            //         mimeType: 'text/html',
            //         encoding: Encoding.getByName('utf-8'))
            //     .toString(),
            src: Uri.file(
              "./test_high_light.html",
            ).toString(),
// width: 100,
// height: 100,
          ))
    ]),
  ];
}

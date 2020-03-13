import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mt_flutter/highlight.dart';
import 'package:mt_flutter/wigets/mt_expansion_menu.dart';
import 'package:mt_flutter/views/gen_activity_code/view.dart';

import 'package:easy_web_view/easy_web_view.dart';




var end = '''
</body>
</html>
''';

List<MenuItem> buildMenu() {

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
              "./cpp_high_light.html",
            ).toString(),
// width: 100,
// height: 100,
          ))
    ]),
  ];
}

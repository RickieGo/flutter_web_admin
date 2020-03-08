// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';

enum DisplayType {
  desktop,
  mobile,
}

const _desktopBreakpoint = 700.0;
const _smallDesktopMaxWidth = 1000.0;

/// Returns the [DisplayType] for the current screen. This app only supports
/// mobile and desktop layouts, and as such we only have one breakpoint.
DisplayType displayTypeOf(BuildContext context) {
  if (MediaQuery.of(context).size.shortestSide > _desktopBreakpoint) {
    return DisplayType.desktop;
  } else {
    return DisplayType.mobile;
  }
}

/// Returns a boolean if we are in a display of [DisplayType.desktop]. Used to
/// build adaptive and responsive layouts.
bool isDisplayDesktop(BuildContext context) {
  return displayTypeOf(context) == DisplayType.desktop;
}

/// Returns a boolean if we are in a display of [DisplayType.desktop] but less
/// than 1000 width. Used to build adaptive and responsive layouts.
bool isDisplaySmallDesktop(BuildContext context) {
  return isDisplayDesktop(context) &&
      MediaQuery.of(context).size.width < _smallDesktopMaxWidth;
}

double _textScaleFactor(BuildContext context) {
  return 1;
}

// When text is larger, this factor becomes larger, but at half the rate.
//
// | Text scaling | Text scale factor | reducedTextScale(context) |
// |--------------|-------------------|---------------------------|
// | Small        |               0.8 |                       1.0 |
// | Normal       |               1.0 |                       1.0 |
// | Large        |               2.0 |                       1.5 |
// | Huge         |               3.0 |                       2.0 |

double reducedTextScale(BuildContext context) {
  double textScaleFactor = _textScaleFactor(context);
  return textScaleFactor >= 1 ? (1 + textScaleFactor) / 2 : 1;
}

// When text is larger, this factor becomes larger at the same rate.
// But when text is smaller, this factor stays at 1.
//
// | Text scaling | Text scale factor |  cappedTextScale(context) |
// |--------------|-------------------|---------------------------|
// | Small        |               0.8 |                       1.0 |
// | Normal       |               1.0 |                       1.0 |
// | Large        |               2.0 |                       2.0 |
// | Huge         |               3.0 |                       3.0 |

double cappedTextScale(BuildContext context) {
  double textScaleFactor = _textScaleFactor(context);
  return max(textScaleFactor, 1);
}

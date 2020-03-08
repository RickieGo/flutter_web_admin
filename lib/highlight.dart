// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// lib/src/interop.dart
@JS()
library highlight_interop;

import 'dart:html';
import 'package:js/js.dart';

@JS()
external HighlightInterface get hljs;

@JS()
class HighlightInterface {
  external void highlightBlock(Element block);
  external void configure(HlConfigOptions options);
  external HighlightAutoInterface highlightAuto(String snippet);
}

@JS()
@anonymous
class HlConfigOptions {
  external factory HlConfigOptions({bool useBr});
  external void set useBr(bool useBrVal);
}

@JS()
class HighlightAutoInterface {
  external get value;
}

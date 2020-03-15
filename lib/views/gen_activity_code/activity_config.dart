import 'package:flutter/foundation.dart';
import 'package:mt_flutter/views/gen_activity_code/activity_config_parser.dart';

class ActField {
  ActField _parent;
  String _sFieldJsonName;
  String _sJsonValueName;
  Map<String, dynamic> _mJsonData;
  String _sTypeName;
  String _sFieldName;
  String _sRawFieldName;

  String _sLineHead;
  // String _sParentFieldName;
  String _sDot;

  bool _bMapKey;

  List<ActField> _subActField = List<ActField>();
  ActField _keyActField;
  String _subFieldStructName;

  void setSubFieldStructName(String name) {
    _subFieldStructName = name;
  }

  ActField();

  void onParse() {}

  void onParseEnd() {}

  void parse(ActField parent, String _sFieldJsonName,
      Map<String, dynamic> mJsonData, String sJsonValueName) {
    _parent = parent;
    _sFieldJsonName = _sFieldJsonName;
    _mJsonData = mJsonData;
    _sJsonValueName = sJsonValueName;
    _sRawFieldName = getParamCamelName(_sFieldJsonName);

    if (_parent == null) {
      _sDot = '->';
    } else {
      _sDot = '.';
    }

    if (_mJsonData['isMapKey'] == 'true') {
      _bMapKey = true;
    }

    onParse();

    //最上层的
    if (parent == null) {
      _mJsonData.forEach((key, value) {
        var actField = ActConfigParser.createSubField(value);
        if (actField == null) return;
        actField.parse(this, key, value, _sJsonValueName);
        _subActField.add(actField);
      });
    }

    if (_mJsonData.containsKey('subFieldOption')) {
      _mJsonData['subFieldOption'].forEach((key, value) {
        var actField = ActConfigParser.createSubField(value);
        if (actField == null) return;
        actField.parse(this, key, value, _sJsonValueName);
        _subActField.add(actField);
      });
    }

    if (_mJsonData.containsKey('groupFieldOption')) {
      _mJsonData['groupFieldOption'].forEach((key, value) {
        var actField = ActConfigParser.createSubField(value);
        if (actField == null) return;
        actField.parse(this, key, value, _sJsonValueName);
        _subActField.add(actField);
      });
    }

    onParseEnd();
  }

  // _sLineHead = _sLineHead + '\t';

  void appendLine(String sValue) {
    ActConfigParser.cppOut.writeln(_sLineHead + sValue);
  }

  void appendSubLine(String sValue) {
    ActConfigParser.cppOut.writeln(_sLineHead + '\t' + sValue);
  }

  void printTypeDefine() {
    //检查时都需要定义新的类型
    for (var item in _subActField) {
      if (item._subFieldStructName != null && item._subFieldStructName.isEmpty)
        continue;
      // print(item._subFieldStructName);
      if (ActConfigParser.internalType.contains(item._subFieldStructName))
        continue;
      if (item._subActField.length < 1) continue;
      item.printTypeDefine();
    }

    //检查同名是否已经定义过了
    if (ActConfigParser.typeInfoDefine.contains(_subFieldStructName)) return;
    ActConfigParser.typeInfoDefine.add(_subFieldStructName);

    ActConfigParser.headOut.writeln('struct $_subFieldStructName');
    ActConfigParser.headOut.writeln('{');
    ActConfigParser.headOut.writeln('    $_subFieldStructName()');

    var index = 0;
    for (var item in _subActField) {
      if (item._bMapKey == true) continue;
      if (item is ActNumberField) {
        if (index != 0) {
          ActConfigParser.headOut.writeln('        ,${item._sFieldName}(0)');
        } else {
          ActConfigParser.headOut.writeln('        :${item._sFieldName}(0)');
        }
      }
    }
    ActConfigParser.headOut.writeln('    {}');
    for (var item in _subActField) {
      if (item._bMapKey == true) continue;

      ActConfigParser.headOut
          .writeln('    ${item._sTypeName} ${item._sFieldName};');
    }
    ActConfigParser.headOut.writeln('}');
  }

  bool isContainSubField(Type T) {
    if (_subActField == null) return false;
    for (var item in _subActField) {
      if (item.isContainSubField(T) == true) {
        return true;
      }
    }
    return false;
  }

  void printSubLoadCode(PrintLoadType loadType) {
    if (loadType == PrintLoadType.PrintLoadType_Normal) {
      for (var item in _subActField) {
        item.printLoadNormal();
      }
    }

    if (loadType == PrintLoadType.PrintLoadType_Map) {
      for (var item in _subActField) {
        item.printLoadMap();
      }
    }

    if (loadType == PrintLoadType.PrintLoadType_Array) {
      for (var item in _subActField) {
        item.printLoadArray();
      }
    }
  }

  String get sCurVarExp =>
      '${_parent._sFieldName}${this._sDot}${this._sFieldName}';
  String get sCurJsonValueExp =>
      '${_parent._sJsonValueName}["${this._sFieldJsonName}"]';

  void printLoadMap() {
    return printLoadNormal();
  }

  void printLoadArray() {
    return printLoadNormal();
  }

  void printLoadNormal() {}

  void printTextAreaSubField() {}

  String getParamCamelName(String paramName) {
    var lowerParam = paramName.toLowerCase();
    var vParam = lowerParam.split("_");

    List<String> vRet = List<String>();
    for (var value in vParam) {
      if (value.isEmpty) continue;
      vRet.add(value[0].toUpperCase() + value.substring(1));
    }
    return vRet.join("");
  }
}

class ActMapField extends ActField {
  ActMapField();

  @override
  void onParse() {
    _sFieldName = 'm$_sRawFieldName';
  }

  @override
  void onParseEnd() {
    if (_subActField.length == 2) {
      for (var item in _subActField) {
        if (item._bMapKey == true) {
          continue;
        }
        _subFieldStructName = item._sTypeName;
      }
    } else {
      _subFieldStructName = 'Act${ActConfigParser.sActName}$_sRawFieldName';
    }
    _sTypeName = "map<uint32_t,$_subFieldStructName>";
  }

  @override
  void printLoadNormal() {
    appendLine(
        'const Json::Value::Members member$_sRawFieldName = $_sJsonValueName["$_sFieldJsonName"].getMemberNames();');
    appendLine('for (uint32_t i = 0; i < member$_sRawFieldName.size(); ++i)');
    appendLine('{');

    appendSubLine('const string& s$_sRawFieldName = member$_sRawFieldName[i];');
    appendSubLine(
        '${_keyActField._sTypeName} ${_keyActField._sFieldName} = UtilString::strto<uint32_t>(s$_sRawFieldName);');

    if (ActConfigParser.internalType.contains(_subFieldStructName)) {
      appendSubLine('');
      appendSubLine(
          'const Json::Value& json$_sRawFieldName = $sCurJsonValueExp[s$_sRawFieldName];');
      printSubLoadCode(PrintLoadType.PrintLoadType_Map);
    } else {
      appendSubLine(
          '$_subFieldStructName st$_subFieldStructName = $sCurVarExp[${_keyActField._sFieldName}]');
      appendSubLine(
          'const Json::Value& json$_sRawFieldName = $sCurJsonValueExp[s$_sRawFieldName];');
      printSubLoadCode(PrintLoadType.PrintLoadType_Normal);
    }
    appendLine('}');
  }
}

class ActArrayField extends ActField {
  ActArrayField() : super();

  @override
  void onParse() {
    _sFieldName = 'v$_sRawFieldName';
  }

  @override
  void onParseEnd() {
    if (_subActField.length == 1) {
      for (var item in _subActField) {
        _subFieldStructName = item._sTypeName;
      }
    } else {
      _subFieldStructName = 'Act${ActConfigParser.sActName}$_sRawFieldName';
    }
    _sTypeName = "vector<$_subFieldStructName>";
  }

  @override
  void printLoadNormal() {
    appendLine(
        'const Json::Value& json$_sFieldName = $_sJsonValueName["$_sFieldJsonName"];');
    appendLine('for (uint32_t i = 0; i < json$_sFieldName.size(); ++i)');
    appendLine('{');
    if (ActConfigParser.internalType.contains(_subFieldStructName)) {
      printSubLoadCode(PrintLoadType.PrintLoadType_Array);
      appendSubLine('$sCurVarExp.push_back(st${this._subFieldStructName})');
    } else {
      appendSubLine(
          '${this._subFieldStructName} st${this._subFieldStructName};');
      appendSubLine('const Json::Value& jsonData = json$_sFieldName[i];');
      printSubLoadCode(PrintLoadType.PrintLoadType_Normal);
      appendSubLine('$sCurVarExp.push_back(st${this._subFieldStructName})');
    }

    appendLine('}');
  }
}

class ActNumberField extends ActField {
  ActNumberField();

  @override
  void onParse() {
    _sTypeName = "uint32_t";
    _sFieldName = 'i$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine('$_sFieldName = $sCurJsonValueExp.asUInt();');
  }

  @override
  void printLoadArray() {
    appendLine('$_sTypeName $_sFieldName = $sCurJsonValueExp.asUInt();');
  }

  @override
  void printLoadNormal() {
    appendLine('$sCurVarExp = $sCurJsonValueExp.asUInt();');
  }
}

//日期时间组件
class ActDateTimeField extends ActNumberField {
  ActDateTimeField();

  @override
  void onParse() {
    _sTypeName = "uint32_t";
    _sFieldName = 'i$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine(
        '$_sFieldName = UtilTime::parseDayTime($sCurJsonValueExp).asString());');
  }

  @override
  void printLoadArray() {
    appendLine(
        '$_sTypeName $_sFieldName = UtilTime::parseDayTime($sCurJsonValueExp).asString());');
  }

  @override
  void printLoadNormal() {
    appendLine(
        '$sCurVarExp = UtilTime::parseDayTime($sCurJsonValueExp).asString());');
  }
}

//每日时间
class ActTimeField extends ActNumberField {
  ActTimeField();

  @override
  void onParse() {
    _sTypeName = "uint32_t";
    _sFieldName = 'i$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine(
        '$_sFieldName = UtilTime::parseTime($sCurJsonValueExp).asString());');
  }

  @override
  void printLoadArray() {
    appendLine(
        '$_sTypeName $_sFieldName = UtilTime::parseTime($sCurJsonValueExp).asString());');
  }

  @override
  void printLoadNormal() {
    appendLine(
        '$sCurVarExp = UtilTime::parseTime($sCurJsonValueExp).asString());');
  }
}

class ActStringField extends ActField {
  ActStringField();

  @override
  void onParse() {
    _sTypeName = "string";
    _sFieldName = 's$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine('$_sFieldName = $sCurJsonValueExp.asString();');
  }

  @override
  void printLoadArray() {
    appendLine('$_sTypeName $_sFieldName = $sCurJsonValueExp.asString();');
  }

  @override
  void printLoadNormal() {
    appendLine('$sCurVarExp = $sCurJsonValueExp.asString();');
  }
}

//拆分成数字数组
class ActIdListField extends ActField {
  ActIdListField();

  @override
  void onParse() {
    _sTypeName = "vector<uint32_t>";
    _sFieldName = 'v$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine('ActivityDataType::parseIdVec($sCurJsonValueExp,$_sFieldName);');
  }

  @override
  void printLoadArray() {
    appendLine('$_sTypeName $_sFieldName;');
    appendLine('ActivityDataType::parseIdVec($sCurJsonValueExp,$_sFieldName);');
  }

  @override
  void printLoadNormal() {
    appendLine('ActivityDataType::parseIdVec($sCurJsonValueExp,$sCurVarExp);');
  }
}

//拆分成字符数组
class ActStrListField extends ActField {
  ActStrListField();

  @override
  void onParse() {
    _sTypeName = "vector<string>";
    _sFieldName = 'v$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine(
        'ActivityDataType::parseStrVec($sCurJsonValueExp,$_sFieldName);');
  }

  @override
  void printLoadArray() {
    appendLine('$_sTypeName $_sFieldName;');
    appendLine(
        'ActivityDataType::parseStrVec($sCurJsonValueExp,$_sFieldName);');
  }

  @override
  void printLoadNormal() {
    appendLine('ActivityDataType::parseStrVec($sCurJsonValueExp,$sCurVarExp);');
  }
}

//拆分成道具数组
class ActItemListField extends ActField {
  ActItemListField();

  @override
  void onParse() {
    _sTypeName = "IDNumVec";
    _sFieldName = 'v$_sRawFieldName';
  }

  @override
  void printLoadMap() {
    appendLine(
        'ActivityDataType::parseIDNumVec($sCurJsonValueExp,$_sFieldName);');
  }

  @override
  void printLoadArray() {
    appendLine('$_sTypeName $_sFieldName;');
    appendLine(
        'ActivityDataType::parseIDNumVec($sCurJsonValueExp,$_sFieldName);');
  }

  @override
  void printLoadNormal() {
    appendLine(
        'ActivityDataType::parseIDNumVec($sCurJsonValueExp,$sCurVarExp);');
  }
}

class ActTextAreaField extends ActField {
  ActTextAreaField();

  @override
  void onParse() {
    _sFieldName = 'st$_sRawFieldName';
    _sTypeName = _sRawFieldName;
  }

  @override
  void onParseEnd() {
    if (_subActField.length == 1) {
      for (var item in _subActField) {
        _subFieldStructName = item._sTypeName;
      }
    } else {
      _subFieldStructName = 'Act${ActConfigParser.sActName}$_sRawFieldName';
    }
    _subFieldStructName = _sRawFieldName;
  }

  void printTextAreaSubField() {
    appendSubLine(
        '$_subFieldStructName& st$_subFieldStructName = $sCurVarExp;');
    printSubLoadCode(PrintLoadType.PrintLoadType_Normal);
  }

  @override
  void printLoadNormal() {
    appendLine('if($_sJsonValueName.isMember("${this._sFieldJsonName}"))');
    appendLine('{');

    appendSubLine('const Json::Value& json$_sRawFieldName = $sCurJsonValueExp');
    printTextAreaSubField();

    appendLine('}');
  }
}

//任务配置
class ActTaskField extends ActTextAreaField {
  ActTaskField();

  @override
  void onParse() {
    _sFieldName = "stTaskConfig";
    _sTypeName = "ActCfgTask";
  }

  @override
  void printTextAreaSubField() {
    appendSubLine(
        'ActivityDataType::parserTaskConfig(json$_sRawFieldName, $sCurVarExp);');
  }
}

//任务分组配置
class ActTaskGroupField extends ActTextAreaField {
  ActTaskGroupField();

  @override
  void onParse() {
    _sFieldName = "mTaskGroup";
    _sTypeName = "map<uint32_t,ActCfgGroupInfo>";
  }

  @override
  void printTextAreaSubField() {
    appendSubLine(
        'ActivityDataType::parserTaskGroupConfig(json$_sRawFieldName, $sCurVarExp);');
  }
}

//任务抽奖配置
class ActDrawField extends ActTextAreaField {
  ActDrawField();

  @override
  void onParse() {
    _sFieldName = 'st$_sRawFieldName';
    _sTypeName = 'ActCfgDrawReward';
  }

  @override
  void printTextAreaSubField() {
    appendSubLine(
        'ActivityDataType::parserDrawRewardConfig(json$_sRawFieldName, $sCurVarExp);');
  }
}

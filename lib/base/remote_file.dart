import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class RemoteFile{

  String _filePath;
  Dio _dio;
  String _sData;

  RemoteFile(
    String file,
    String pathName)
  {
    var context =  Context();
    _filePath = context.join(pathName, file);
    _dio = Dio();
  }
  
  
  Future read()
  async {
      var response = await _dio.get(_filePath);
      _sData = response.data;
      return _sData;
  }

  Future write()
  async {
      var response = await Dio().put(
      _filePath,
      data:_sData,
      options: Options(contentType:ContentType.parse( "text/plain" ).toString()));
      return response.data;
  }

  String toString(){
    return _sData;
  }

  void setData(String sData)
  {
    _sData = sData;  
  }


  //ActivityInject都是 //@@***@@ 这种形式
  bool replaceActivityInjectWithKeyWord(String sKey, String sInjectCode,String sReplace,String sReturn)
  {
    //检查关键字是否已经在文件中存在，避免重复插入
    RegExp regExp =  RegExp(sKey);
    if(regExp.hasMatch(_sData))
    {
       sReturn = '文件$_filePath中已经存在$sKey...';
       return false;
    }

    return  replaceActivityInject(sInjectCode, sReplace, sReturn);
  }

  bool replaceActivityInject(String sInjectCode,String sReplace,String sReturn)
  {
    String sInject = '//@@$sInjectCode@@';
    RegExp regExp =  RegExp('(//s*)$sInject.*');

    var result = regExp.firstMatch(_sData);
    if (result == null) {
      sReturn = '文件$_filePath未找到$sInjectCode插入点，请检查...';
      return false;
    }
    
    var findResult = result.group(0);
    //找出行首的空格或tab，加入到待插入字符
    String linePrefix = result.group(1);
    if(linePrefix.isNotEmpty){
      sReplace = sReplace.replaceAll(RegExp(r'^',multiLine: true), linePrefix);
    }

    _sData.replaceFirst(regExp, '$sReplace\n$findResult.');
    return true;
  }
}




class SdpHelper {
  //获取枚举类型中最大的协议id
  static int getEnumMaxIndex(String sdpContent, String sEnumName, String subKey) {
    int iRet = 0;
    var regExp = RegExp('.*enum\\s+$sEnumName\\s*{[^}]*}', multiLine: true);
    var itTab = regExp.firstMatch(sdpContent);
    if (itTab == null) {
      return iRet;
    }
    var sEnum = itTab.group(0);
    var it = RegExp('$subKey.*=\\s*([0-9]+)').allMatches(sEnum);

    it.forEach((data) {
      var num = int.parse(data.group(1));
      if (iRet < num) {
        iRet = num;
      }
    });
    return iRet;
  }

  //协议枚举id是否已经存在
  static bool isEnumIndexExsits(String sdpContent, String sEnumName, int index) {
    var regExp = RegExp('.*enum\\s+$sEnumName\\s*{[^}]*}', multiLine: true);
    var itTab = regExp.firstMatch(sdpContent);
    if (itTab == null) {
      return false;
    }
    var sEnum = itTab.group(0);
    var it = RegExp('.*=\\s*[0-9]+').allMatches(sEnum);

    bool ret = false;
    it.forEach((data) {
      var num = int.parse(data.group(1));
      if (index == num) {
        ret = true;
      }
    });
    return ret;
  }

  //获取结构体最大字段id
  static int getStrucMaxIndex(String sdpContent, String sStructName, {String subKey = "" }) {
    int iRet = 0;
    var regExp = RegExp('.*struct\\s+$sStructName\\s*{[^}]*}', multiLine: true);
    var itTab = regExp.firstMatch(sdpContent);
    if (itTab == null) {
      return iRet;
    }
    var sStruct = itTab.group(0);
    var it = RegExp('\\s*([0-9]+)\\s+').allMatches(sStruct);
    it.forEach((data) {
      var num = int.parse(data.group(1));
      if (iRet < num) {
        iRet = num;
      }
    });
    return iRet;
  }
}

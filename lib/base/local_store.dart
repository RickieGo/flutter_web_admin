import 'package:key_value_store_web/key_value_store_web.dart';
import 'dart:html';

class LocalStore {
  LocalStore._();

  static LocalStore _instance;

  static Future<LocalStore> get instance async {
    return await getInstance();
  }

  static Future<LocalStore> getInstance() async {
    if (_instance == null) {
      _instance = new LocalStore._();
      await _instance._init();
    }
    return _instance;
  }

  static WebKeyValueStore _webKeyValueStore;

  Future _init() async {
    //_spf = await SharedPreferences.getInstance();
    _webKeyValueStore = new WebKeyValueStore(window.localStorage);
  }

  static bool _beforeCheck() {
    if (_webKeyValueStore == null) {
      return true;
    }
    return false;
  }

  // 判断是否存在数据
  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.getKeys();
  }

  getString(String key) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.getString(key);
  }

  Future<bool> putString(String key, String value) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.setString(key, value);
  }

  bool getBool(String key) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.getBool(key);
  }

  Future<bool> putBool(String key, bool value) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.setBool(key, value);
  }

  int getInt(String key) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.getInt(key);
  }

  Future<bool> putInt(String key, int value) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.setInt(key, value);
  }

  double getDouble(String key) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.getDouble(key);
  }

  Future<bool> putDouble(String key, double value) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.setDouble(key, value);
  }

  List<String> getStringList(String key) {
    return _webKeyValueStore.getStringList(key);
  }

  Future<bool> putStringList(String key, List<String> value) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.setStringList(key, value);
  }

  Future<bool> remove(String key) {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.remove(key);
  }

  Future<bool> clear() {
    if (_beforeCheck()) return null;
    return _webKeyValueStore.clear();
  }
}

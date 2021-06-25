import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences._();

  static final instance = MySharedPreferences._();

  SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveBool(String key, {bool value = false}) async =>
      await _sharedPreferences!.setBool(key, value);

  bool loadBoolValue(String key) => _sharedPreferences!.getBool(key) ?? false;
}

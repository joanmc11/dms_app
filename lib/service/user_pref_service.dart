import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Uid
  String get uid => _prefs?.getString('uid') ?? '';

  set uid(String uid) {
    _prefs?.setString('uid', uid);
  }

  // UserName
  String get name => _prefs?.getString('name') ?? '';

  set name(String name) {
    _prefs?.setString('name', name);
  }

  // Logged in
  bool get loggedIn => _prefs?.getBool('logged') ?? false;

  set loggedIn(bool value) {
    _prefs?.setBool('logged', value);
  }





}

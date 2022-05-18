import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  SharedPreferences? instance;

  Future init() async {
    instance = await SharedPreferences.getInstance();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// {@category Components}
/// [PreferencesService] provides [SharedPreferences] instance
class PreferencesService {
  SharedPreferences? instance;

  Future init() async {
    instance = await SharedPreferences.getInstance();
  }
}

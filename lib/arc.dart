import 'package:arc/navigation_service.dart';
import 'package:arc/preferences_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Arc {
  // section: singleton
  static final Arc _instance = Arc._internal();

  factory Arc() {
    if (!isInit) {
      init();
    }
    return _instance;
  }

  Arc._internal();

  // section: init
  static bool isInit = false;
  static late SharedPreferences? preferences;

  static init() {
    isInit = true;
    print("Arc init");
    GetIt.I.registerSingleton<NavigationService>(NavigationServiceImpl());
    GetIt.I.registerSingleton<PreferencesService>(PreferencesService());
    GetIt.I<PreferencesService>().init().then((value) {
      preferences = GetIt.I<PreferencesService>().instance;
    });
  }

  get navigatorKey => GetIt.I<NavigationService>().navigatorKey;

  get currentContext =>
      GetIt.I<NavigationService>().navigatorKey.currentContext;

  // section: navigator
  static void pop({Object? result}) {
    GetIt.I<NavigationService>().pop(result: result);
  }

  static Future push(routeWidget) {
    return GetIt.I<NavigationService>().push(routeWidget);
  }

  static Future pushNamed(String routeName, {Object? arguments}) {
    return GetIt.I<NavigationService>()
        .pushNamed(routeName, arguments: arguments);
  }

  static Future pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    return GetIt.I<NavigationService>()
        .pushNamedAndRemoveUntil(routeName, arguments: arguments);
  }
}

extension CheckValues<T> on T {
  bool get hasValue => !(this == null ||
      ((this is String && (this as String).isEmpty) ||
          (this is List && (this as List).isEmpty) ||
          (this is Map && (this as Map).isEmpty)));

  bool get isNullOrEmpty => (this == null ||
      ((this is String && (this as String).isEmpty) ||
          (this is List && (this as List).isEmpty) ||
          (this is Map && (this as Map).isEmpty)));
}

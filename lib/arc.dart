import 'package:arc/navigation_service.dart';
import 'package:arc/preferences_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@category How to use}
/// [Arc] is global(singleton) instance.
/// So, you can initialize [Arc] by run this code as early as you can.
/// ``` dart
/// Arc();
/// ```
class Arc {
  // section: singleton
  static final Arc _instance = Arc._internal();

  /// It works as static instance. So, even you call constructor many times, initialize only once.
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

  /// Arc has [init()] method, but no need to call.
  static init() {
    isInit = true;
    print("Arc init");
    GetIt.I.registerSingleton<NavigationService>(NavigationServiceImpl());
    GetIt.I.registerSingleton<PreferencesService>(PreferencesService());
    GetIt.I<PreferencesService>().init().then((value) {
      preferences = GetIt.I<PreferencesService>().instance;
    });
  }

  /// If you use navigation with Arc, (ex. [Arc.push])
  /// just set [navigatorKey]
  /// ``` dart
  /// MaterialApp(
  ///   key: _materialAppKey,
  ///   navigatorKey: Arc().navigatorKey,
  ///   ...
  /// ),
  /// ```
  /// This has also initialize effect.
  get navigatorKey => GetIt.I<NavigationService>().navigatorKey;

  /// This is a magic for your architecture layer design freedom.
  /// For example, Anytime you can call dialog or snackbar which need BuildContext.
  /// ``` dart
  /// Scaffold.of(Arc().currentContext).showSnackBar(SnackBar(content: Text("hello")));
  /// ```
  get currentContext =>
      GetIt.I<NavigationService>().navigatorKey.currentContext;

  // section: navigator
  /// Pop foreground screen on navigator stack
  /// You can [pop] screen without context parameter.
  /// ``` dart
  /// Arc.pop();
  /// ```
  static void pop({Object? result}) {
    GetIt.I<NavigationService>().pop(result: result);
  }

  /// Push new screen on top of navigator stack
  /// You can [push] screen without context parameter.
  /// ``` dart
  /// Arc.push(SomeScreenWidget());
  /// ```
  static Future push(routeWidget) {
    return GetIt.I<NavigationService>().push(routeWidget);
  }

  /// Push new screen on top of navigator stack with name
  /// You can use [pushNamed] screen without context parameter.
  /// ``` dart
  /// Arc.pushNamed("/login");
  /// ```
  static Future pushNamed(String routeName, {Object? arguments}) {
    return GetIt.I<NavigationService>()
        .pushNamed(routeName, arguments: arguments);
  }

  /// Pop some screen widgets until named widget is on top.
  /// ``` dart
  /// Arc.pushNamedAndRemoveUntil("/");
  /// ```
  static Future pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    return GetIt.I<NavigationService>()
        .pushNamedAndRemoveUntil(routeName, arguments: arguments);
  }
}

extension CheckValues<T> on T {
  /// String, List, Map : not null / not empty check
  /// ``` dart
  /// strVariable.hasValue ? print("good") : print("bad")
  /// ```
  bool get hasValue => !(this == null ||
      ((this is String && (this as String).isEmpty) ||
          (this is List && (this as List).isEmpty) ||
          (this is Map && (this as Map).isEmpty)));

  /// String, List, Map : null / empty check
  /// ``` dart
  /// strVariable.isNullOrEmpty? print("bad") : print("good")
  /// ```
  bool get isNullOrEmpty => (this == null ||
      ((this is String && (this as String).isEmpty) ||
          (this is List && (this as List).isEmpty) ||
          (this is Map && (this as Map).isEmpty)));
}

import 'package:flutter/material.dart';

abstract class NavigationService {
  GlobalKey<NavigatorState> get navigatorKey;

  void pop({Object? result});

  Future<dynamic> push(dynamic routeWidget);

  Future<dynamic> pushNamed(String routeName, {Object? arguments});

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments});
}

class NavigationServiceImpl implements NavigationService {
  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  get navigatorKey => navKey;

  @override
  void pop({Object? result}) {
    return navKey.currentState!.pop(result);
  }

  @override
  Future push(dynamic routeWidget) {
    return navKey.currentState!
        .push(MaterialPageRoute(builder: (context) => routeWidget));
  }

  @override
  Future pushNamed(String routeName, {Object? arguments}) {
    return navKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  @override
  Future pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    return navKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }
}

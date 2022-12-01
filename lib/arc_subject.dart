import 'package:arc/arc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// {@category Components}
/// [ArcSubject] is wrapper of RxDart [BehaviorSubject],
class ArcSubject<T> {
  ArcSubject({T? seed}) {
    if (seed != null) {
      subject = BehaviorSubject<T>.seeded(seed);
    } else {
      subject = BehaviorSubject<T>();
    }
  }

  late BehaviorSubject<T> subject;

  Stream<T> get stream => subject.stream;

  set val(event) => subject.add(event);

  get val => subject.valueOrNull;

  StreamBuilder<T>
      ui({required Widget Function(BuildContext, AsyncSnapshot<T?>) builder}) =>
          StreamBuilder(
            stream: stream,
            builder: builder,
          );

  close() {
    subject.close();
  }

  /// Possible types
  /// primitive : double, int, bool, String, List<String>
  /// others : which overrides [toString] method to return serialized String.
  Future<bool>? save(String key) {
    if (Arc.preferences == null) print("arc need init");
    if (val != null) {
      if (T is double || T is double?) {
        return Arc.preferences?.setDouble(key, val);
      } else if (T is String || T is String?) {
        return Arc.preferences?.setString(key, val);
      } else if (T is bool || T is bool?) {
        return Arc.preferences?.setBool(key, val);
      } else if (T is int || T is int?) {
        return Arc.preferences?.setInt(key, val);
      } else if (T is List<String> || T is List<String>?) {
        return Arc.preferences?.setStringList(key, val);
      } else {
        return Arc.preferences?.setString(key, val.toString());
      }
    }
  }

  /// Possible types
  /// primitive : double, int, bool, String, List<String>
  void load(String key) {
    if (Arc.preferences == null) print("arc need init");

    var result;
    if (T is double || T is double?) {
      result = Arc.preferences?.getDouble(key);
    } else if (T is String || T is String?) {
      result = Arc.preferences?.getString(key);
    } else if (T is bool || T is bool?) {
      result = Arc.preferences?.getBool(key);
    } else if (T is int || T is int?) {
      result = Arc.preferences?.getInt(key);
    } else if (T is List<String> || T is List<String>?) {
      result = Arc.preferences?.getStringList(key);
    } else {
      result = null;
    }
    if (result != null) val = result;
  }

  Stream<R> combine2<A, B, R>(Stream<B> withB, R Function(T? a, B b) function) {
    return Rx.combineLatest2(stream, withB, function);
  }

  Stream<R> combine3<A, B, C, R>(
      Stream<B> withB, Stream<C> withC, R Function(T? a, B b, C c) function) {
    return Rx.combineLatest3(stream, withB, withC, function);
  }

  @override
  String toString() {
    return stream.toList().toString();
  }
}

extension ArcSubjectT<T> on T {
  ArcSubject<T> get sbj => ArcSubject<T>(seed: this);
}

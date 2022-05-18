import 'dart:async';

import 'package:arc/arc.dart';
import 'package:arc/arc_subject.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var a = "hello".sbj;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      a.val("world");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Arc().navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('sample app'),
        ),
        body: Center(
          child: a.ui(builder: (context, aSnap) => Text(notNullString(aSnap))),
        ),
      ),
    );
  }

  String notNullString(AsyncSnapshot<String?> aSnap) =>
      aSnap.hasData ? aSnap.data ?? "" : "";

  void test() {
    // section: 초기화, 앱 시작시 1번만 하면 됨
    Arc();

    // section: navigator key (MaterialApp 인자)
    Arc().navigatorKey;

    // section: get current context
    Arc().currentContext;

    // section: navigation 예시
    // Arc.push(HomeScreen());
    Arc.pop();
    Arc.pushNamed("/login");
    Arc.pop(result: "result");
    Arc.pushNamedAndRemoveUntil("/");

    // section: ArcSubject 생성예시
    var a = "hello".sbj; // 즉시 'hello'를 시드로 하는 ArcSubject생성
    a.stream.listen((event) => print(event)); // 바로 스트림 리스닝 가능
    a.val("No"); // subject에 바로 'No'를 add함
    print(a.val); // 최신값을 즉시 꺼내 사용가능

    // section: 직접생성
    var b = ArcSubject<int>(); // 초기값 없이 생성가능
    var c = ArcSubject<int>(seed: 3); // 인자로 시드 넘김 가능

    // section: 스토리지로 데이터 저장 / 불러오기
    a.save("keyA");
    a.load("keyA");
    Arc.preferences?.setString("keyB", "hi"); // 직접호출
    Arc.preferences?.getString("keyB");

    // section: 기본자료형 외에 아무 객체든 저장 가능 (toString() 오버라이드 필요)
    var d = DateTime.now().sbj;
    d.save("keyD");

    // section: 스트림빌더 사용예시1
    a.ui(builder: (context, aSnap) => Text(aSnap.data!));

    // section: 컴바인 예시
    var combined =
        a.combine2(b.stream, (a, dynamic b) => (a == "hello" && b == 5));

    // section: null, empty check extension 적용
    5.hasValue;
    "".isNullOrEmpty;
    [].isNullOrEmpty;
    null.hasValue;
    a.val.isNullOrEmpty ? a.val("nope") : print(a.val);
  }
}

# arc

Architecture component for Flutter development

## pubspec.yaml

``` yaml
dependencies:
  arc:
    git: https://github.com/akthfdyd/arc.git
```

## example

``` dart
// section: Initialize, just call once in your app lifecycle.
Arc();

// section: Navigator key (optional parameter of MaterialApp)
Arc().navigatorKey;

// section: Get current context
Arc().currentContext;

// section: Navigation example
Arc.push(HomeScreen());
Arc.pop();
Arc.pushNamed("/login");
Arc.pop(result: "result");
Arc.pushNamedAndRemoveUntil("/");

// section: ArcSubject 
var a = "hello".sbj; // Create new ArcSubject made from seed 'hello'
a.val("No"); // Add "No" string value into subject 'a'
a.stream.listen((event) => print(event)); // Event stream listener
print(a.val); // Use recent added value anywhere

// section: Direct create ArcSubject
var b = ArcSubject<int>(); // Without seed
var c = ArcSubject<int>(seed: 3); // Inject seed by parameter

// section: Primitive data save/load (Storage)
a.save("keyA");
a.load("keyA");
Arc.preferences?.setString("keyB", "hi"); // wrapper
Arc.preferences?.getString("keyB");

// section: Objects(not primitive type) save/load to serialized string (Overriding toString() needed)
var d = DateTime.now().sbj;
d.save("keyD");

// section: UI builder example (return StreamBuilder)
a.ui(builder: (context, aSnap) => Text(aSnap.data!));

// section: Combine two subjects
var combined =
    a.combine2(b.stream, (a, dynamic b) => (a == "hello" && b == 5));

// section: null, empty check extension 
5.hasValue;
"".isNullOrEmpty;
[].isNullOrEmpty;
null.hasValue;
a.val.isNullOrEmpty ? a.val("nope") : print(a.val);
```

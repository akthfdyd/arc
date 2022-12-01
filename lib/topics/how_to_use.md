# Initialize
### Initialize (if you need Arc before creating MaterialApp)

``` dart
Arc();
```

### Initialize with navigatorKey

``` dart
MaterialApp(
  navigatorKey: Arc().navigatorKey,
  ...
),
```

Most case you can do second way.

# Navigation (manage screen stack)
### currentContext

``` dart
// Code scope where do not exists build context
Scaffold.of(Arc().currentContext).showSnackBar(SnackBar(content: Text("hello")));
```

### push

``` dart
Arc.push(SecondScreen());
```

### pushNamed

``` dart
Arc.pushNamed("/login");
```

### pop

``` dart
Arc.pop();
```

if you have result,

``` dart
Arc.pop(result: "result value");
```

### pushNamedAndRemoveUntil

``` dart
Arc.pushNamedAndRemoveUntil("/");
```

You can make routing module or something, It'll increase your architecture freedom.

# ArcSubject (reactive programming, state managament, and so on)

### Create subject

Any type of object, you can change to subject

``` dart
var a = "hello".sbj;
var b = 5.sbj;
var c = responseModel.sbj;
```

### Add new value

``` dart
a.val("world");
b.val(10);
c.val(ResponseModel());
```

### Use recent value

``` dart
print(a.val);
return Text("${b.val}");
onSuccess(c.val);
```

### Event stream listener

``` dart
@override
void initState() {
  super.initState();
  a.stream.listen((event) => print(event));
}
```

### UI builder

``` dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: a.ui(builder: (context, aVal) => Text("$aVal")),
    ),
  );
}
```

### Combine two ArcSubject

``` dart
var combined =
    a.combine2(b.stream, (a, dynamic b) => (a == "hello" && b == 5));
```

### null/empty check extension - hasValue

``` dart
print(5.hasValue); // true
print("hello".hasValue); // true
print(a.val.hasValue); // with ArcSubject
print("".hasValue); // false
print([].hasValue); // false
print(null.hasValue); // false
```

### null/empty check extension - isNullOrEmpty

``` dart
print(5.isNullOrEnpty); // false
print("hello".isNullOrEnpty); // false
print(a.val.isNullOrEnpty); // with ArcSubject
print("".isNullOrEnpty); // true
print([].isNullOrEnpty); // true 
print(null.isNullOrEnpty); // true
```

Extension also needs import. careful.

# Simple data storage (save/load data from SharedPreferences)

### save

``` dart
var a = "hello".sbj;
a.save("saveKey"); // save the value of subject 'a' to SharedPreferences key "saveKey"
```

### load

``` dart
var a = "".sbj;
a.load("saveKey"); // load data from SharedPreferences key "saveKey" and put into 'a'
print(a.val); // "hello"
```

### direct use preferences instance

``` dart
Arc.preferences?.setString("saveKey", "hi");
print(Arc.preferences?.getString("saveKey")); // "hi"
```
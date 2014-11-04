#Emitters [![Build Status](https://drone.io/github.com/0xor1/emitters/status.png)](https://drone.io/github.com/0xor1/emitters/latest)

Emitters provides a simple mixin class, Emitter, to enable any object to emit arbitrary
objects. It also provides a convenience mixin class, Receiver, to assist
objects in managing their handler functions.

##Example

```dart
import 'package:emitters/emitters.dart';

class Foo{}
class Bar{}

void main(){
  var emitter = new Emitter();
  var fooSub = emitter.on(Foo, (_) => print('Foo'));
  var barSub = emitter.on(Bar, (_) => print('Bar'));
  emitter.emit(new Foo());
  emitter.emit(new Bar());
}
```

##Example with Receiver

```dart
import 'package:emitters/emitters.dart';

class Dog extends Object with Emitter{
  void bark(int volume){
    emit(new Bark(volume));
  }
}

class Cat extends Object with Receiver{
  void dogBarkHandler(Emission<Bark> emission){
    var bark = emission.data;
    if(bark.volume > 10){
      print('cat running away');
    }else{
      print('cat not disturbed');
    }
  }
}

class Bark{
  final int volume;
  Bark(this.volume);
}

void main(){
  var dog = new Dog();
  var cat = new Cat();
  cat.listen(dog, Bark, cat.dogBarkHandler);
  dog.bark(9);  // cat not disturbed
  dog.bark(11); // cat running away
}
```

##All

There is a special Type **All** which allows receivers to listen for every object emitted
by an **Emitter** with a single handler regardless of the objects type.

```dart
/// raw emiiter
emitter.on(All, (_) => print('handling all emitted objects'));
/// receiver equivalent
receiver.listen(emitter, All, (_) => print('handling all emitted objects'));
```
/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library emitters.test.unit;

import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:emitters/emitters.dart';

part 'emitter.dart';
part 'event.dart';
part 'receiver.dart';

class TypeA{}
class TypeB{}

Emitter emitter1;
Emitter emitter2;
Receiver receiver;

Event lastReceivedEvent;
int typeAReceivedCount;
int typeBReceivedCount;

Handler handler = (event){
  if(event.data is TypeA){
    typeAReceivedCount++;
  }
  else if(event.data is TypeB){
    typeBReceivedCount++;
  }
  lastReceivedEvent = event;
};

void setUpTestObjects(){
  emitter1 = new Emitter();
  emitter2 = new Emitter();
  receiver = new Receiver();

  typeAReceivedCount = typeBReceivedCount = 0;

  receiver.listen(emitter1, TypeA, handler);
  receiver.listen(emitter2, TypeB, handler);
}

void tearDownTestObjects(){
  emitter1 = emitter2 = receiver = lastReceivedEvent = null;
  typeAReceivedCount = typeBReceivedCount = 0;
}

void main(){
  setUp(setUpTestObjects);
  tearDown(tearDownTestObjects);
  runEmitterTests();
  runEventTests();
  runReceiverTests();
}
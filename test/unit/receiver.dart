/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters.test.unit;

void runReceiverTests(){

  group('Receiver', (){

    test('.ignoreAll() unhooks all Handlers.', (){
      receiver.ignoreAll();
      emitter1.emit(new TypeA());
      emitter2.emit(new TypeB());
      Timer.run(expectAsync((){
        expect(typeAReceivedCount, equals(0));
        expect(typeBReceivedCount, equals(0));
      }));
    });

    test('calling ignore methods doesn\'t throw errors when no types are currently being listened for.', (){
      var receiver = new Receiver();
      var emitter = new Emitter();
      receiver.ignoreAll();
      receiver.ignoreEmitter(emitter);
      receiver.ignoreType(Object);
      expect(true, equals(true));
    });

    test('.ignoreType(type) unhooks all Handlers of the specified type.', (){
      receiver.ignoreType(TypeA);
      emitter1.emit(new TypeA());
      emitter2.emit(new TypeB());
      Timer.run(expectAsync((){
        expect(typeAReceivedCount, equals(0));
        expect(typeBReceivedCount, equals(1));
      }));
    });

    test('.ignoreEmitter(emitter) unhooks all Handlers from the specified emitter.', (){
      receiver.ignoreEmitter(emitter1);
      emitter1.emit(new TypeA());
      emitter2.emit(new TypeB());
      Timer.run(expectAsync((){
        expect(typeAReceivedCount, equals(0));
        expect(typeBReceivedCount, equals(1));
      }));
    });

    test('throws a DuplicateReceiverSettingError if it attempts to listen to the same emitter/type combination more than once.', (){
      expect(() => receiver.listen(emitter1, TypeA, (emission){}), throwsA(new isInstanceOf<DuplicateReceiverSettingError>()));
    });

    test('.listenOnce only gets one emission.', (){
      var count = 0;
      receiver.ignoreAll();
      receiver.listenOnce(emitter1, TypeA, (_){count++;});
      emitter1.emit(new TypeA());
      emitter1.emit(new TypeA());
      emitter1.emit(new TypeA());
      Timer.run(expectAsync((){
        expect(count, equals(1));
      }));
    });

    test('.listenOnce handlers get removed with ignore.', (){
      var count = 0;
      receiver.ignoreAll();
      receiver.listenOnce(emitter1, TypeA, (_){count++;});
      receiver.ignoreTypeFromEmitter(emitter1, TypeA);
      emitter1.emit(new TypeA());
      emitter1.emit(new TypeA());
      Timer.run(expectAsync((){
        expect(count, equals(0));
      }));
    });

    test('throws a DuplicateReceiverSettingError if it attempts to listenOnce to the same emitter/type combination more than once.', (){
      expect(() => receiver.listenOnce(emitter1, TypeA, (emission){}), throwsA(new isInstanceOf<DuplicateReceiverSettingError>()));
    });
  });

}
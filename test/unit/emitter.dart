/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters.test.unit;

void runEmitterTests(){

  group('Emitter', (){

    test('Handlers are called asynchronously.', (){
      emitter1.emit(new TypeA());
      expect(lastReceivedEmission, equals(null));
      Timer.run(expectAsync((){
        expect(lastReceivedEmission.emitter, equals(emitter1));
      }));
    });

    test('listening to All type receives all types from an emitter.', (){
      receiver.ignoreAll();
      receiver.listen(emitter1, All, handler);
      emitter1.emit(new TypeA());
      emitter1.emit(new TypeA());
      emitter1.emit(new TypeB());
      emitter2.emit(new TypeB());
      Timer.run(expectAsync((){
        expect(typeAReceivedCount, equals(2));
        expect(typeBReceivedCount, equals(1));
      }));
    });

    test('throws an EmitTimeQueueChangeError if an attempt is made to add or remove an Handler during the time that type is being emitted.', (){
      var detectorCopy = receiver;
      var error;
      emitter1.on(TypeA, (event){
          detectorCopy.ignoreAll();
      });
      expect(emitter1.emit(new TypeA()), throwsA(new isInstanceOf<EmitTimeQueueChangeError>()));
    });

    test('emit returns a Future which completes with the emitted event.', (){
      var setInFuture;
      emitter1.emit(new TypeA()).then((event){ setInFuture = event; });
      Timer.run(expectAsync((){
        Timer.run(expectAsync((){
          expect(setInFuture, equals(lastReceivedEmission));
        }));
      }));
    });

  });

}
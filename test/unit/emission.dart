/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters.test.unit;

void runEmissionTests(){

  group('Emission', (){

    test('contains the emitter object by default.', (){
      emitter1.emit(new TypeA());
      Timer.run(expectAsync((){
        expect(lastReceivedEmission.emitter, equals(emitter1));
      }));
    });

    test('contains the data.', (){
      var data = new TypeA();
      emitter1.emit(data);
      Timer.run(expectAsync((){
        expect(lastReceivedEmission.data, equals(data));
      }));
    });

    test('contains the finished future which completes with the emission.', (){
      var data = new TypeA();
      emitter1.emit(data);
      Timer.run(expectAsync((){
        var setInFuture;
        lastReceivedEmission.finished.then((event){ setInFuture = event; });
        Timer.run(expectAsync((){
          expect(setInFuture.data, equals(data));
        }));
      }));
    });

    test('event.data is readonly.', (){
      emitter1.emit(new TypeA());
      Timer.run(expectAsync((){
        expect(() => lastReceivedEmission.data = null, throwsA(new isInstanceOf<NoSuchMethodError>()));
      }));
    });

    test('event.emitter is readonly.', (){
      emitter1.emit(new TypeA());
      Timer.run(expectAsync((){
        expect(() => lastReceivedEmission.emitter = null, throwsA(new isInstanceOf<NoSuchMethodError>()));
      }));
    });

    test('event.finished is getter only.', (){
      emitter1.emit(new TypeA());
      Timer.run(expectAsync((){
        expect(() => lastReceivedEmission.finished = null, throwsA(new isInstanceOf<NoSuchMethodError>()));
      }));
    });

  });

}
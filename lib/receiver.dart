/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters;

/// A convenience mixin to enable any object to manage [Handler]s listening to [Emitter]s.
class Receiver{

  Map<Emitter, Map<Type, Handler>> _typeIndexes;
  Map<Type, Map<Emitter, Handler>> _emitterIndexes;

  /// Adds the [handler] to the [emitter]s handler queue of [type].
  void listen(Emitter emitter, Type type, Handler handler) => _listen(emitter, type, handler, (e, t, h) => e.on(t, h));

  /// Adds the [handler] to the [emitter]s handler queue of [type] for one emission only.
  void listenOnce(Emitter emitter, Type type, Handler handler) => _listen(emitter, type, handler, (e, t, h) => e.once(t, h));

  void _listen(Emitter emitter, Type type, Handler handler, void on(Emitter emitter, Type type, Handler handler)){
    _initialiseIndexes(emitter, type);
    if(_typeIndexes[emitter][type] != null){
      throw new DuplicateReceiverSettingError._internal(this, emitter, type, _typeIndexes[emitter][type], handler);
    }else{
      _typeIndexes[emitter][type] = _emitterIndexes[type][emitter] = handler;
      on(emitter, type, handler);
    }
  }

  void _initialiseIndexes(Emitter emitter, Type type){
    if(_typeIndexes == null){
      _typeIndexes = new Map<Emitter, Map<Type, Handler>>();
    }
    if(_typeIndexes[emitter] == null){
      _typeIndexes[emitter] = new Map<Type, Handler>();
    }
    if(_emitterIndexes == null){
      _emitterIndexes = new Map<Type, Map<Emitter, Handler>>();
    }
    if(_emitterIndexes[type] == null){
      _emitterIndexes[type] = new Map<Emitter, Handler>();
    }
  }

  /// Removes the [Handler] assigned to the [emitter]s handler queue of [type].
  void ignoreTypeFromEmitter(Emitter emitter, Type type){
    if(_typeIndexes != null && _typeIndexes[emitter] != null && _typeIndexes[emitter][type] != null){
      Handler handler = _typeIndexes[emitter].remove(type);
      _emitterIndexes[type].remove(emitter);
      emitter.off(type, handler);
      if(_typeIndexes[emitter].isEmpty){
        _typeIndexes.remove(emitter);
      }
      if(_emitterIndexes[type].isEmpty){
        _emitterIndexes.remove(type);
      }
    }
  }

  /// Removes all [Handler]s attached to all handler queues of [type].
  void ignoreType(Type type){
    if(_emitterIndexes != null && _emitterIndexes[type] != null){
      var emitterIndex = _emitterIndexes[type];
      while(emitterIndex.isNotEmpty){
        ignoreTypeFromEmitter(emitterIndex.keys.first, type);
      }
    }
  }

  /// Removes all [Handler]s attached to [emitter].
  void ignoreFrom(Emitter emitter){
    if(_typeIndexes != null && _typeIndexes[emitter] != null){
      var typeIndex = _typeIndexes[emitter];
      while(typeIndex.isNotEmpty){
        ignoreTypeFromEmitter(emitter, typeIndex.keys.first);
      }
    }
  }

  /// Removes all [Handler]s this object has previously attached to all [Emitter]s for all data types.
  void ignoreAll(){
    if(_typeIndexes != null)
    while(_typeIndexes.isNotEmpty){
      ignoreFrom(_typeIndexes.keys.first);
    }
  }
}
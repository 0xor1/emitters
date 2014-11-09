/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters;

/// A mixin class to enable any object to emit events with arbitrary data types.
class Emitter{

  Map<Type, Set<Handler>> _handlerQueues;
  Map<Handler, Handler> _onceWrapperHandlerMap;
  /// Describes whether the object is currently emitting.
  bool get isEmitting => _emittingType != null;
  Type _emittingType;
  /// Specifies which data type is currently being emitted by the object.
  Type get emittingType => _emittingType;

  /// Adds [handler] to the handler queue of [type].
  void on(Type type, Handler handler){
    if(_emittingType == type){
      _emittingType = null;
      throw new EmitTimeQueueChangeError._internal(this, type, handler);
    }
    if(_handlerQueues == null){
      _handlerQueues = new Map<Type, Set<Handler>>();
    }
    if(_handlerQueues[type] == null){
      _handlerQueues[type] = new Set<Handler>();
    }
    _handlerQueues[type].add(handler);
  }

  /// Adds [handler] to the handler queue of [type] and removes it after one event.
  void once(Type type, Handler handler){
    var onceWrapperHandler;
    onceWrapperHandler = (Event emission){
      handler(emission);
      emission.finished.then((_){
        off(type, onceWrapperHandler);
        _onceWrapperHandlerMap.remove(handler);
        if(_onceWrapperHandlerMap.isEmpty){
          _onceWrapperHandlerMap = null;
        }
      });
    };
    if(_onceWrapperHandlerMap == null){
      _onceWrapperHandlerMap = new Map<Handler, Handler>();
    }
    if(_onceWrapperHandlerMap[handler] == null){
      _onceWrapperHandlerMap[handler] = onceWrapperHandler;
      on(type, onceWrapperHandler);
    }
  }

  /// Removes the [handler] from the handler queue of [type].
  void off(Type type, Handler handler){
    if(_emittingType == type){
      _emittingType = null;
      throw new EmitTimeQueueChangeError._internal(this, type, handler);
    }
    if(_handlerQueues != null && _handlerQueues[type] != null){
      _handlerQueues[type].remove(handler);
      if(_handlerQueues[type].isEmpty){
        _handlerQueues.remove(type);
        if(_handlerQueues.isEmpty){
          _handlerQueues = null;
        }
      }
    }
    if(_onceWrapperHandlerMap != null && _onceWrapperHandlerMap[handler] != null){
      var onceWrapperHandler = _onceWrapperHandlerMap[handler];
      off(type, onceWrapperHandler);
      _onceWrapperHandlerMap.remove(handler);
      if(_onceWrapperHandlerMap.isEmpty){
        _onceWrapperHandlerMap = null;
      }
    }
  }

  /**
   * Calls all the handlers in the queue of type [data] with an [Event] containing [data]
   * asynchronously, returning a [Future] that completes with the [Event] when all of the
   * [Handler]s have been called.
   */
  Future<Event> emit(dynamic data){
    var event = new Event._internal(this, data);
    var finished;
    //make eventQueues execute async so only one event queue is ever executing at a time.
    finished = new Future<Event>.delayed(new Duration(), (){
      event._finished = finished;
      _emittingType = data.runtimeType;
      if(_handlerQueues != null && _handlerQueues[_emittingType] != null){
        _handlerQueues[_emittingType].forEach((Handler handler){ handler(event); });
      }

      if(_handlerQueues != null && _handlerQueues[All] != null){
        _handlerQueues[All].forEach((Handler handler){ handler(event); });
      }
      _emittingType = null;
      return event;
    });

    return finished;
  }
}
/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters;

/// All emitted [data] comes inside an [Event] object.
class Event<T>{
  /// The emitting object
  final Emitter emitter;
  /// The emitted data
  final T data;
  /// completes when the event has finished propogating
  Future get finished => _finished;
  Future _finished;

  Event._internal(this.emitter, this.data);
}
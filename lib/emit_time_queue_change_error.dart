/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters;

/// Thrown when [handler] attempts to add or remove [Handler]s from the handler queue currently being called.
class EmitTimeQueueChangeError extends Error{
  String get message => 'The emitter is currently emitting an event with data of type "$type", a call to on/off at emit time, of that data type, is an error.';
  final Type type;
  final Emitter emitter;
  final Handler handler;
  EmitTimeQueueChangeError._internal(this.emitter, this.type, this.handler);
}
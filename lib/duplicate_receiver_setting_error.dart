/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters;

/// Thrown when [receiver] attempts to add [newHandler] to [emitter]s handler queue of [type] and an [existingHandler] is already assigned.
class DuplicateReceiverSettingError extends Error{
  String get message => 'The receiver is already listening for "$type" data type from the given emitter';
  final Type type;
  final Emitter emitter;
  final Receiver receiver;
  final Handler existingHandler;
  final Handler newHandler;
  DuplicateReceiverSettingError._internal(this.receiver, this.emitter, this.type, this.existingHandler, this.newHandler);
}
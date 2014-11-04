/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of emitters;

/// All emitted [data] comes inside an [Emission] object.
class Emission<T>{
  /// The emitting object
  final Emitter emitter;
  /// The emitted data
  final T data;
  /// completes when the emission has finished propogating
  Future get finished => _finished;
  Future _finished;

  Emission._internal(this.emitter, this.data);
}
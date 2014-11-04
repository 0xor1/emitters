/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

/// Mixins to make any object into an [Emitter] or [Receiver] of arbitrary objects.
library emitters;

import 'dart:async';

part 'emit_time_queue_change_error.dart';
part 'duplicate_receiver_setting_error.dart';
part 'emission.dart';
part 'emitter.dart';
part 'receiver.dart';

/// Special type used for listening to all events from an [Emitter] with a single [Handler].
abstract class All{}

/// Function signature of an [Handler].
typedef void Handler<T>(Emission<T> emission);
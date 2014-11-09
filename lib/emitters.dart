/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

/// Mixins to make any object into an [Event] [Emitter] or [Receiver] of arbitrary data types.
library emitters;

import 'dart:async';

part 'emit_time_queue_change_error.dart';
part 'duplicate_receiver_setting_error.dart';
part 'event.dart';
part 'emitter.dart';
part 'receiver.dart';

/// Special type used for listening to all events from an [Emitter] with a single [Handler].
abstract class All{}

/// Function signature of an event handler.
typedef void Handler<T>(Event<T> event);
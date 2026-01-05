/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Reminder
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Reminder._({
    required this.activityId,
    required this.tripId,
    required this.tripDayId,
    required this.title,
    required this.message,
    this.startTime,
  });

  factory Reminder({
    required int activityId,
    required int tripId,
    required int tripDayId,
    required String title,
    required String message,
    DateTime? startTime,
  }) = _ReminderImpl;

  factory Reminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reminder(
      activityId: jsonSerialization['activityId'] as int,
      tripId: jsonSerialization['tripId'] as int,
      tripDayId: jsonSerialization['tripDayId'] as int,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      startTime: jsonSerialization['startTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startTime']),
    );
  }

  int activityId;

  int tripId;

  int tripDayId;

  String title;

  String message;

  DateTime? startTime;

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reminder copyWith({
    int? activityId,
    int? tripId,
    int? tripDayId,
    String? title,
    String? message,
    DateTime? startTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reminder',
      'activityId': activityId,
      'tripId': tripId,
      'tripDayId': tripDayId,
      'title': title,
      'message': message,
      if (startTime != null) 'startTime': startTime?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reminder',
      'activityId': activityId,
      'tripId': tripId,
      'tripDayId': tripDayId,
      'title': title,
      'message': message,
      if (startTime != null) 'startTime': startTime?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderImpl extends Reminder {
  _ReminderImpl({
    required int activityId,
    required int tripId,
    required int tripDayId,
    required String title,
    required String message,
    DateTime? startTime,
  }) : super._(
         activityId: activityId,
         tripId: tripId,
         tripDayId: tripDayId,
         title: title,
         message: message,
         startTime: startTime,
       );

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reminder copyWith({
    int? activityId,
    int? tripId,
    int? tripDayId,
    String? title,
    String? message,
    Object? startTime = _Undefined,
  }) {
    return Reminder(
      activityId: activityId ?? this.activityId,
      tripId: tripId ?? this.tripId,
      tripDayId: tripDayId ?? this.tripDayId,
      title: title ?? this.title,
      message: message ?? this.message,
      startTime: startTime is DateTime? ? startTime : this.startTime,
    );
  }
}

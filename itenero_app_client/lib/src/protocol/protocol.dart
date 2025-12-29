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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'activity.dart' as _i2;
import 'day_briefing.dart' as _i3;
import 'greetings/greeting.dart' as _i4;
import 'remainder.dart' as _i5;
import 'trip.dart' as _i6;
import 'trip_day.dart' as _i7;
import 'trip_with_plan.dart' as _i8;
import 'package:itenero_app_client/src/protocol/trip.dart' as _i9;
import 'package:itenero_app_client/src/protocol/activity.dart' as _i10;
import 'package:itenero_app_client/src/protocol/remainder.dart' as _i11;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i12;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i13;
export 'activity.dart';
export 'day_briefing.dart';
export 'greetings/greeting.dart';
export 'remainder.dart';
export 'trip.dart';
export 'trip_day.dart';
export 'trip_with_plan.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Activity) {
      return _i2.Activity.fromJson(data) as T;
    }
    if (t == _i3.DayBriefing) {
      return _i3.DayBriefing.fromJson(data) as T;
    }
    if (t == _i4.Greeting) {
      return _i4.Greeting.fromJson(data) as T;
    }
    if (t == _i5.Reminder) {
      return _i5.Reminder.fromJson(data) as T;
    }
    if (t == _i6.Trip) {
      return _i6.Trip.fromJson(data) as T;
    }
    if (t == _i7.TripDay) {
      return _i7.TripDay.fromJson(data) as T;
    }
    if (t == _i8.TripWithPlan) {
      return _i8.TripWithPlan.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Activity?>()) {
      return (data != null ? _i2.Activity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.DayBriefing?>()) {
      return (data != null ? _i3.DayBriefing.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Greeting?>()) {
      return (data != null ? _i4.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Reminder?>()) {
      return (data != null ? _i5.Reminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Trip?>()) {
      return (data != null ? _i6.Trip.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.TripDay?>()) {
      return (data != null ? _i7.TripDay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.TripWithPlan?>()) {
      return (data != null ? _i8.TripWithPlan.fromJson(data) : null) as T;
    }
    if (t == List<_i7.TripDay>) {
      return (data as List).map((e) => deserialize<_i7.TripDay>(e)).toList()
          as T;
    }
    if (t == List<_i2.Activity>) {
      return (data as List).map((e) => deserialize<_i2.Activity>(e)).toList()
          as T;
    }
    if (t == List<_i9.Trip>) {
      return (data as List).map((e) => deserialize<_i9.Trip>(e)).toList() as T;
    }
    if (t == List<_i10.Activity>) {
      return (data as List).map((e) => deserialize<_i10.Activity>(e)).toList()
          as T;
    }
    if (t == List<_i11.Reminder>) {
      return (data as List).map((e) => deserialize<_i11.Reminder>(e)).toList()
          as T;
    }
    try {
      return _i12.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Activity => 'Activity',
      _i3.DayBriefing => 'DayBriefing',
      _i4.Greeting => 'Greeting',
      _i5.Reminder => 'Reminder',
      _i6.Trip => 'Trip',
      _i7.TripDay => 'TripDay',
      _i8.TripWithPlan => 'TripWithPlan',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('itenero_app.', '');
    }

    switch (data) {
      case _i2.Activity():
        return 'Activity';
      case _i3.DayBriefing():
        return 'DayBriefing';
      case _i4.Greeting():
        return 'Greeting';
      case _i5.Reminder():
        return 'Reminder';
      case _i6.Trip():
        return 'Trip';
      case _i7.TripDay():
        return 'TripDay';
      case _i8.TripWithPlan():
        return 'TripWithPlan';
    }
    className = _i12.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Activity') {
      return deserialize<_i2.Activity>(data['data']);
    }
    if (dataClassName == 'DayBriefing') {
      return deserialize<_i3.DayBriefing>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i4.Greeting>(data['data']);
    }
    if (dataClassName == 'Reminder') {
      return deserialize<_i5.Reminder>(data['data']);
    }
    if (dataClassName == 'Trip') {
      return deserialize<_i6.Trip>(data['data']);
    }
    if (dataClassName == 'TripDay') {
      return deserialize<_i7.TripDay>(data['data']);
    }
    if (dataClassName == 'TripWithPlan') {
      return deserialize<_i8.TripWithPlan>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i12.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i13.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

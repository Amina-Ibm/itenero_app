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
import 'trip.dart' as _i2;
import 'trip_day.dart' as _i3;
import 'activity.dart' as _i4;
import 'package:itenero_app_server/src/generated/protocol.dart' as _i5;

abstract class TripWithPlan
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TripWithPlan._({
    required this.trip,
    required this.days,
    required this.activities,
  });

  factory TripWithPlan({
    required _i2.Trip trip,
    required List<_i3.TripDay> days,
    required List<_i4.Activity> activities,
  }) = _TripWithPlanImpl;

  factory TripWithPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return TripWithPlan(
      trip: _i5.Protocol().deserialize<_i2.Trip>(jsonSerialization['trip']),
      days: _i5.Protocol().deserialize<List<_i3.TripDay>>(
        jsonSerialization['days'],
      ),
      activities: _i5.Protocol().deserialize<List<_i4.Activity>>(
        jsonSerialization['activities'],
      ),
    );
  }

  _i2.Trip trip;

  List<_i3.TripDay> days;

  List<_i4.Activity> activities;

  /// Returns a shallow copy of this [TripWithPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TripWithPlan copyWith({
    _i2.Trip? trip,
    List<_i3.TripDay>? days,
    List<_i4.Activity>? activities,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TripWithPlan',
      'trip': trip.toJson(),
      'days': days.toJson(valueToJson: (v) => v.toJson()),
      'activities': activities.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TripWithPlan',
      'trip': trip.toJsonForProtocol(),
      'days': days.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'activities': activities.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TripWithPlanImpl extends TripWithPlan {
  _TripWithPlanImpl({
    required _i2.Trip trip,
    required List<_i3.TripDay> days,
    required List<_i4.Activity> activities,
  }) : super._(
         trip: trip,
         days: days,
         activities: activities,
       );

  /// Returns a shallow copy of this [TripWithPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TripWithPlan copyWith({
    _i2.Trip? trip,
    List<_i3.TripDay>? days,
    List<_i4.Activity>? activities,
  }) {
    return TripWithPlan(
      trip: trip ?? this.trip.copyWith(),
      days: days ?? this.days.map((e0) => e0.copyWith()).toList(),
      activities:
          activities ?? this.activities.map((e0) => e0.copyWith()).toList(),
    );
  }
}

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

abstract class DayBriefing implements _i1.SerializableModel {
  DayBriefing._({
    required this.tripId,
    required this.tripDayId,
    required this.dayIndex,
    required this.summary,
  });

  factory DayBriefing({
    required int tripId,
    required int tripDayId,
    required int dayIndex,
    required String summary,
  }) = _DayBriefingImpl;

  factory DayBriefing.fromJson(Map<String, dynamic> jsonSerialization) {
    return DayBriefing(
      tripId: jsonSerialization['tripId'] as int,
      tripDayId: jsonSerialization['tripDayId'] as int,
      dayIndex: jsonSerialization['dayIndex'] as int,
      summary: jsonSerialization['summary'] as String,
    );
  }

  int tripId;

  int tripDayId;

  int dayIndex;

  String summary;

  /// Returns a shallow copy of this [DayBriefing]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DayBriefing copyWith({
    int? tripId,
    int? tripDayId,
    int? dayIndex,
    String? summary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DayBriefing',
      'tripId': tripId,
      'tripDayId': tripDayId,
      'dayIndex': dayIndex,
      'summary': summary,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DayBriefingImpl extends DayBriefing {
  _DayBriefingImpl({
    required int tripId,
    required int tripDayId,
    required int dayIndex,
    required String summary,
  }) : super._(
         tripId: tripId,
         tripDayId: tripDayId,
         dayIndex: dayIndex,
         summary: summary,
       );

  /// Returns a shallow copy of this [DayBriefing]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DayBriefing copyWith({
    int? tripId,
    int? tripDayId,
    int? dayIndex,
    String? summary,
  }) {
    return DayBriefing(
      tripId: tripId ?? this.tripId,
      tripDayId: tripDayId ?? this.tripDayId,
      dayIndex: dayIndex ?? this.dayIndex,
      summary: summary ?? this.summary,
    );
  }
}

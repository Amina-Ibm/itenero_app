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

abstract class TripDay implements _i1.SerializableModel {
  TripDay._({
    this.id,
    required this.tripId,
    required this.dayIndex,
    this.date,
    this.summary,
  });

  factory TripDay({
    int? id,
    required int tripId,
    required int dayIndex,
    DateTime? date,
    String? summary,
  }) = _TripDayImpl;

  factory TripDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return TripDay(
      id: jsonSerialization['id'] as int?,
      tripId: jsonSerialization['tripId'] as int,
      dayIndex: jsonSerialization['dayIndex'] as int,
      date: jsonSerialization['date'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      summary: jsonSerialization['summary'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int tripId;

  int dayIndex;

  DateTime? date;

  String? summary;

  /// Returns a shallow copy of this [TripDay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TripDay copyWith({
    int? id,
    int? tripId,
    int? dayIndex,
    DateTime? date,
    String? summary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TripDay',
      if (id != null) 'id': id,
      'tripId': tripId,
      'dayIndex': dayIndex,
      if (date != null) 'date': date?.toJson(),
      if (summary != null) 'summary': summary,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TripDayImpl extends TripDay {
  _TripDayImpl({
    int? id,
    required int tripId,
    required int dayIndex,
    DateTime? date,
    String? summary,
  }) : super._(
         id: id,
         tripId: tripId,
         dayIndex: dayIndex,
         date: date,
         summary: summary,
       );

  /// Returns a shallow copy of this [TripDay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TripDay copyWith({
    Object? id = _Undefined,
    int? tripId,
    int? dayIndex,
    Object? date = _Undefined,
    Object? summary = _Undefined,
  }) {
    return TripDay(
      id: id is int? ? id : this.id,
      tripId: tripId ?? this.tripId,
      dayIndex: dayIndex ?? this.dayIndex,
      date: date is DateTime? ? date : this.date,
      summary: summary is String? ? summary : this.summary,
    );
  }
}

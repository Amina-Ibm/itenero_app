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

abstract class Activity implements _i1.SerializableModel {
  Activity._({
    this.id,
    required this.tripDayId,
    required this.title,
    required this.description,
    required this.category,
    this.startTime,
    this.endTime,
    this.locationName,
    this.lat,
    this.lon,
    this.estimatedCost,
  });

  factory Activity({
    int? id,
    required int tripDayId,
    required String title,
    required String description,
    required String category,
    DateTime? startTime,
    DateTime? endTime,
    String? locationName,
    double? lat,
    double? lon,
    double? estimatedCost,
  }) = _ActivityImpl;

  factory Activity.fromJson(Map<String, dynamic> jsonSerialization) {
    return Activity(
      id: jsonSerialization['id'] as int?,
      tripDayId: jsonSerialization['tripDayId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      startTime: jsonSerialization['startTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startTime']),
      endTime: jsonSerialization['endTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      locationName: jsonSerialization['locationName'] as String?,
      lat: (jsonSerialization['lat'] as num?)?.toDouble(),
      lon: (jsonSerialization['lon'] as num?)?.toDouble(),
      estimatedCost: (jsonSerialization['estimatedCost'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int tripDayId;

  String title;

  String description;

  String category;

  DateTime? startTime;

  DateTime? endTime;

  String? locationName;

  double? lat;

  double? lon;

  double? estimatedCost;

  /// Returns a shallow copy of this [Activity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Activity copyWith({
    int? id,
    int? tripDayId,
    String? title,
    String? description,
    String? category,
    DateTime? startTime,
    DateTime? endTime,
    String? locationName,
    double? lat,
    double? lon,
    double? estimatedCost,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Activity',
      if (id != null) 'id': id,
      'tripDayId': tripDayId,
      'title': title,
      'description': description,
      'category': category,
      if (startTime != null) 'startTime': startTime?.toJson(),
      if (endTime != null) 'endTime': endTime?.toJson(),
      if (locationName != null) 'locationName': locationName,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivityImpl extends Activity {
  _ActivityImpl({
    int? id,
    required int tripDayId,
    required String title,
    required String description,
    required String category,
    DateTime? startTime,
    DateTime? endTime,
    String? locationName,
    double? lat,
    double? lon,
    double? estimatedCost,
  }) : super._(
         id: id,
         tripDayId: tripDayId,
         title: title,
         description: description,
         category: category,
         startTime: startTime,
         endTime: endTime,
         locationName: locationName,
         lat: lat,
         lon: lon,
         estimatedCost: estimatedCost,
       );

  /// Returns a shallow copy of this [Activity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Activity copyWith({
    Object? id = _Undefined,
    int? tripDayId,
    String? title,
    String? description,
    String? category,
    Object? startTime = _Undefined,
    Object? endTime = _Undefined,
    Object? locationName = _Undefined,
    Object? lat = _Undefined,
    Object? lon = _Undefined,
    Object? estimatedCost = _Undefined,
  }) {
    return Activity(
      id: id is int? ? id : this.id,
      tripDayId: tripDayId ?? this.tripDayId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startTime: startTime is DateTime? ? startTime : this.startTime,
      endTime: endTime is DateTime? ? endTime : this.endTime,
      locationName: locationName is String? ? locationName : this.locationName,
      lat: lat is double? ? lat : this.lat,
      lon: lon is double? ? lon : this.lon,
      estimatedCost: estimatedCost is double?
          ? estimatedCost
          : this.estimatedCost,
    );
  }
}

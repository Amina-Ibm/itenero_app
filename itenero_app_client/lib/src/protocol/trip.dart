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

abstract class Trip implements _i1.SerializableModel {
  Trip._({
    this.id,
    this.userId,
    required this.destination,
    required this.daysCount,
    required this.focus,
    required this.travelersType,
    this.budget,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.latitude,
    required this.longitude,
    this.originAddress,
    this.originLat,
    this.originLon,
  });

  factory Trip({
    int? id,
    String? userId,
    required String destination,
    required int daysCount,
    required String focus,
    required String travelersType,
    String? budget,
    required DateTime createdAt,
    required DateTime startDate,
    required DateTime endDate,
    required double latitude,
    required double longitude,
    String? originAddress,
    double? originLat,
    double? originLon,
  }) = _TripImpl;

  factory Trip.fromJson(Map<String, dynamic> jsonSerialization) {
    return Trip(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      destination: jsonSerialization['destination'] as String,
      daysCount: jsonSerialization['daysCount'] as int,
      focus: jsonSerialization['focus'] as String,
      travelersType: jsonSerialization['travelersType'] as String,
      budget: jsonSerialization['budget'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      originAddress: jsonSerialization['originAddress'] as String?,
      originLat: (jsonSerialization['originLat'] as num?)?.toDouble(),
      originLon: (jsonSerialization['originLon'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? userId;

  String destination;

  int daysCount;

  String focus;

  String travelersType;

  String? budget;

  DateTime createdAt;

  DateTime startDate;

  DateTime endDate;

  double latitude;

  double longitude;

  String? originAddress;

  double? originLat;

  double? originLon;

  /// Returns a shallow copy of this [Trip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Trip copyWith({
    int? id,
    String? userId,
    String? destination,
    int? daysCount,
    String? focus,
    String? travelersType,
    String? budget,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    double? latitude,
    double? longitude,
    String? originAddress,
    double? originLat,
    double? originLon,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Trip',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'destination': destination,
      'daysCount': daysCount,
      'focus': focus,
      'travelersType': travelersType,
      if (budget != null) 'budget': budget,
      'createdAt': createdAt.toJson(),
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      if (originAddress != null) 'originAddress': originAddress,
      if (originLat != null) 'originLat': originLat,
      if (originLon != null) 'originLon': originLon,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TripImpl extends Trip {
  _TripImpl({
    int? id,
    String? userId,
    required String destination,
    required int daysCount,
    required String focus,
    required String travelersType,
    String? budget,
    required DateTime createdAt,
    required DateTime startDate,
    required DateTime endDate,
    required double latitude,
    required double longitude,
    String? originAddress,
    double? originLat,
    double? originLon,
  }) : super._(
         id: id,
         userId: userId,
         destination: destination,
         daysCount: daysCount,
         focus: focus,
         travelersType: travelersType,
         budget: budget,
         createdAt: createdAt,
         startDate: startDate,
         endDate: endDate,
         latitude: latitude,
         longitude: longitude,
         originAddress: originAddress,
         originLat: originLat,
         originLon: originLon,
       );

  /// Returns a shallow copy of this [Trip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Trip copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    String? destination,
    int? daysCount,
    String? focus,
    String? travelersType,
    Object? budget = _Undefined,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    double? latitude,
    double? longitude,
    Object? originAddress = _Undefined,
    Object? originLat = _Undefined,
    Object? originLon = _Undefined,
  }) {
    return Trip(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      destination: destination ?? this.destination,
      daysCount: daysCount ?? this.daysCount,
      focus: focus ?? this.focus,
      travelersType: travelersType ?? this.travelersType,
      budget: budget is String? ? budget : this.budget,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      originAddress: originAddress is String?
          ? originAddress
          : this.originAddress,
      originLat: originLat is double? ? originLat : this.originLat,
      originLon: originLon is double? ? originLon : this.originLon,
    );
  }
}

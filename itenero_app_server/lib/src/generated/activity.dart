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

abstract class Activity
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ActivityTable();

  static const db = ActivityRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ActivityInclude include() {
    return ActivityInclude._();
  }

  static ActivityIncludeList includeList({
    _i1.WhereExpressionBuilder<ActivityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActivityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActivityTable>? orderByList,
    ActivityInclude? include,
  }) {
    return ActivityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Activity.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Activity.t),
      include: include,
    );
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

class ActivityUpdateTable extends _i1.UpdateTable<ActivityTable> {
  ActivityUpdateTable(super.table);

  _i1.ColumnValue<int, int> tripDayId(int value) => _i1.ColumnValue(
    table.tripDayId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime? value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endTime(DateTime? value) =>
      _i1.ColumnValue(
        table.endTime,
        value,
      );

  _i1.ColumnValue<String, String> locationName(String? value) =>
      _i1.ColumnValue(
        table.locationName,
        value,
      );

  _i1.ColumnValue<double, double> lat(double? value) => _i1.ColumnValue(
    table.lat,
    value,
  );

  _i1.ColumnValue<double, double> lon(double? value) => _i1.ColumnValue(
    table.lon,
    value,
  );

  _i1.ColumnValue<double, double> estimatedCost(double? value) =>
      _i1.ColumnValue(
        table.estimatedCost,
        value,
      );
}

class ActivityTable extends _i1.Table<int?> {
  ActivityTable({super.tableRelation}) : super(tableName: 'activity') {
    updateTable = ActivityUpdateTable(this);
    tripDayId = _i1.ColumnInt(
      'tripDayId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    locationName = _i1.ColumnString(
      'locationName',
      this,
    );
    lat = _i1.ColumnDouble(
      'lat',
      this,
    );
    lon = _i1.ColumnDouble(
      'lon',
      this,
    );
    estimatedCost = _i1.ColumnDouble(
      'estimatedCost',
      this,
    );
  }

  late final ActivityUpdateTable updateTable;

  late final _i1.ColumnInt tripDayId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString category;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnString locationName;

  late final _i1.ColumnDouble lat;

  late final _i1.ColumnDouble lon;

  late final _i1.ColumnDouble estimatedCost;

  @override
  List<_i1.Column> get columns => [
    id,
    tripDayId,
    title,
    description,
    category,
    startTime,
    endTime,
    locationName,
    lat,
    lon,
    estimatedCost,
  ];
}

class ActivityInclude extends _i1.IncludeObject {
  ActivityInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Activity.t;
}

class ActivityIncludeList extends _i1.IncludeList {
  ActivityIncludeList._({
    _i1.WhereExpressionBuilder<ActivityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Activity.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Activity.t;
}

class ActivityRepository {
  const ActivityRepository._();

  /// Returns a list of [Activity]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Activity>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActivityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActivityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActivityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Activity>(
      where: where?.call(Activity.t),
      orderBy: orderBy?.call(Activity.t),
      orderByList: orderByList?.call(Activity.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Activity] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Activity?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActivityTable>? where,
    int? offset,
    _i1.OrderByBuilder<ActivityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ActivityTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Activity>(
      where: where?.call(Activity.t),
      orderBy: orderBy?.call(Activity.t),
      orderByList: orderByList?.call(Activity.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Activity] by its [id] or null if no such row exists.
  Future<Activity?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Activity>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Activity]s in the list and returns the inserted rows.
  ///
  /// The returned [Activity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Activity>> insert(
    _i1.Session session,
    List<Activity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Activity>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Activity] and returns the inserted row.
  ///
  /// The returned [Activity] will have its `id` field set.
  Future<Activity> insertRow(
    _i1.Session session,
    Activity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Activity>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Activity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Activity>> update(
    _i1.Session session,
    List<Activity> rows, {
    _i1.ColumnSelections<ActivityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Activity>(
      rows,
      columns: columns?.call(Activity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Activity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Activity> updateRow(
    _i1.Session session,
    Activity row, {
    _i1.ColumnSelections<ActivityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Activity>(
      row,
      columns: columns?.call(Activity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Activity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Activity?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ActivityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Activity>(
      id,
      columnValues: columnValues(Activity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Activity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Activity>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ActivityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ActivityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ActivityTable>? orderBy,
    _i1.OrderByListBuilder<ActivityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Activity>(
      columnValues: columnValues(Activity.t.updateTable),
      where: where(Activity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Activity.t),
      orderByList: orderByList?.call(Activity.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Activity]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Activity>> delete(
    _i1.Session session,
    List<Activity> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Activity>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Activity].
  Future<Activity> deleteRow(
    _i1.Session session,
    Activity row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Activity>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Activity>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ActivityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Activity>(
      where: where(Activity.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ActivityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Activity>(
      where: where?.call(Activity.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

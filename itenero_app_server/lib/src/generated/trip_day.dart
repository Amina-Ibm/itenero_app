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

abstract class TripDay
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = TripDayTable();

  static const db = TripDayRepository._();

  @override
  int? id;

  int tripId;

  int dayIndex;

  DateTime? date;

  String? summary;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TripDay',
      if (id != null) 'id': id,
      'tripId': tripId,
      'dayIndex': dayIndex,
      if (date != null) 'date': date?.toJson(),
      if (summary != null) 'summary': summary,
    };
  }

  static TripDayInclude include() {
    return TripDayInclude._();
  }

  static TripDayIncludeList includeList({
    _i1.WhereExpressionBuilder<TripDayTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TripDayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TripDayTable>? orderByList,
    TripDayInclude? include,
  }) {
    return TripDayIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TripDay.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TripDay.t),
      include: include,
    );
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

class TripDayUpdateTable extends _i1.UpdateTable<TripDayTable> {
  TripDayUpdateTable(super.table);

  _i1.ColumnValue<int, int> tripId(int value) => _i1.ColumnValue(
    table.tripId,
    value,
  );

  _i1.ColumnValue<int, int> dayIndex(int value) => _i1.ColumnValue(
    table.dayIndex,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime? value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> summary(String? value) => _i1.ColumnValue(
    table.summary,
    value,
  );
}

class TripDayTable extends _i1.Table<int?> {
  TripDayTable({super.tableRelation}) : super(tableName: 'trip_day') {
    updateTable = TripDayUpdateTable(this);
    tripId = _i1.ColumnInt(
      'tripId',
      this,
    );
    dayIndex = _i1.ColumnInt(
      'dayIndex',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    summary = _i1.ColumnString(
      'summary',
      this,
    );
  }

  late final TripDayUpdateTable updateTable;

  late final _i1.ColumnInt tripId;

  late final _i1.ColumnInt dayIndex;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnString summary;

  @override
  List<_i1.Column> get columns => [
    id,
    tripId,
    dayIndex,
    date,
    summary,
  ];
}

class TripDayInclude extends _i1.IncludeObject {
  TripDayInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TripDay.t;
}

class TripDayIncludeList extends _i1.IncludeList {
  TripDayIncludeList._({
    _i1.WhereExpressionBuilder<TripDayTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TripDay.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TripDay.t;
}

class TripDayRepository {
  const TripDayRepository._();

  /// Returns a list of [TripDay]s matching the given query parameters.
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
  Future<List<TripDay>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TripDayTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TripDayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TripDayTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TripDay>(
      where: where?.call(TripDay.t),
      orderBy: orderBy?.call(TripDay.t),
      orderByList: orderByList?.call(TripDay.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TripDay] matching the given query parameters.
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
  Future<TripDay?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TripDayTable>? where,
    int? offset,
    _i1.OrderByBuilder<TripDayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TripDayTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TripDay>(
      where: where?.call(TripDay.t),
      orderBy: orderBy?.call(TripDay.t),
      orderByList: orderByList?.call(TripDay.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TripDay] by its [id] or null if no such row exists.
  Future<TripDay?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TripDay>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TripDay]s in the list and returns the inserted rows.
  ///
  /// The returned [TripDay]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TripDay>> insert(
    _i1.Session session,
    List<TripDay> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TripDay>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TripDay] and returns the inserted row.
  ///
  /// The returned [TripDay] will have its `id` field set.
  Future<TripDay> insertRow(
    _i1.Session session,
    TripDay row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TripDay>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TripDay]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TripDay>> update(
    _i1.Session session,
    List<TripDay> rows, {
    _i1.ColumnSelections<TripDayTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TripDay>(
      rows,
      columns: columns?.call(TripDay.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TripDay]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TripDay> updateRow(
    _i1.Session session,
    TripDay row, {
    _i1.ColumnSelections<TripDayTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TripDay>(
      row,
      columns: columns?.call(TripDay.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TripDay] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TripDay?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TripDayUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TripDay>(
      id,
      columnValues: columnValues(TripDay.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TripDay]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TripDay>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TripDayUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TripDayTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TripDayTable>? orderBy,
    _i1.OrderByListBuilder<TripDayTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TripDay>(
      columnValues: columnValues(TripDay.t.updateTable),
      where: where(TripDay.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TripDay.t),
      orderByList: orderByList?.call(TripDay.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TripDay]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TripDay>> delete(
    _i1.Session session,
    List<TripDay> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TripDay>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TripDay].
  Future<TripDay> deleteRow(
    _i1.Session session,
    TripDay row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TripDay>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TripDay>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TripDayTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TripDay>(
      where: where(TripDay.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TripDayTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TripDay>(
      where: where?.call(TripDay.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

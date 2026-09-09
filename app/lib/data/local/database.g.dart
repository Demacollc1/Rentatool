// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    parentId,
    name,
    level,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? parentId;
  final String name;
  final int level;
  const Category({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    this.parentId,
    required this.name,
    required this.level,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['level'] = Variable<int>(level);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      level: Value(level),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<int>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<int>(level),
    };
  }

  Category copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> parentId = const Value.absent(),
    String? name,
    int? level,
  }) => Category(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    level: level ?? this.level,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, parentId, name, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.level == this.level);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<int> level;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.parentId = const Value.absent(),
    required String name,
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<int>? level,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? parentId,
    Value<String>? name,
    Value<int>? level,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      level: level ?? this.level,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    parentId,
    name,
    level,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Location> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? parentId;
  final String name;
  final int level;
  const Location({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    this.parentId,
    required this.name,
    required this.level,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['name'] = Variable<String>(name);
    map['level'] = Variable<int>(level);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      level: Value(level),
    );
  }

  factory Location.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<int>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'parentId': serializer.toJson<String?>(parentId),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<int>(level),
    };
  }

  Location copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> parentId = const Value.absent(),
    String? name,
    int? level,
  }) => Location(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    level: level ?? this.level,
  );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, parentId, name, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.level == this.level);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> parentId;
  final Value<String> name;
  final Value<int> level;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.parentId = const Value.absent(),
    required String name,
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Location> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? parentId,
    Expression<String>? name,
    Expression<int>? level,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? parentId,
    Value<String>? name,
    Value<int>? level,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      level: level ?? this.level,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rucMeta = const VerificationMeta('ruc');
  @override
  late final GeneratedColumn<String> ruc = GeneratedColumn<String>(
    'ruc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    name,
    ruc,
    phone,
    email,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ruc')) {
      context.handle(
        _rucMeta,
        ruc.isAcceptableOrUnknown(data['ruc']!, _rucMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ruc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruc'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? ruc;
  final String? phone;
  final String? email;
  final String? notes;
  const Supplier({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.ruc,
    this.phone,
    this.email,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || ruc != null) {
      map['ruc'] = Variable<String>(ruc);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      ruc: ruc == null && nullToAbsent ? const Value.absent() : Value(ruc),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      ruc: serializer.fromJson<String?>(json['ruc']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'ruc': serializer.toJson<String?>(ruc),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Supplier copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> ruc = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Supplier(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    ruc: ruc.present ? ruc.value : this.ruc,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    notes: notes.present ? notes.value : this.notes,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      ruc: data.ruc.present ? data.ruc.value : this.ruc,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('ruc: $ruc, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, name, ruc, phone, email, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.ruc == this.ruc &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.notes == this.notes);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> ruc;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> notes;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.ruc = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.ruc = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? ruc,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (ruc != null) 'ruc': ruc,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? ruc,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      ruc: ruc ?? this.ruc,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ruc.present) {
      map['ruc'] = Variable<String>(ruc.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('ruc: $ruc, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CanonicalsTable extends Canonicals
    with TableInfo<$CanonicalsTable, Canonical> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CanonicalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconLocalPathMeta = const VerificationMeta(
    'iconLocalPath',
  );
  @override
  late final GeneratedColumn<String> iconLocalPath = GeneratedColumn<String>(
    'icon_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconUploadedAtMeta = const VerificationMeta(
    'iconUploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> iconUploadedAt =
      GeneratedColumn<DateTime>(
        'icon_uploaded_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    code,
    name,
    iconPath,
    iconLocalPath,
    iconUploadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'canonicals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Canonical> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('icon_local_path')) {
      context.handle(
        _iconLocalPathMeta,
        iconLocalPath.isAcceptableOrUnknown(
          data['icon_local_path']!,
          _iconLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('icon_uploaded_at')) {
      context.handle(
        _iconUploadedAtMeta,
        iconUploadedAt.isAcceptableOrUnknown(
          data['icon_uploaded_at']!,
          _iconUploadedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Canonical map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Canonical(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      iconLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_local_path'],
      ),
      iconUploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}icon_uploaded_at'],
      ),
    );
  }

  @override
  $CanonicalsTable createAlias(String alias) {
    return $CanonicalsTable(attachedDatabase, alias);
  }
}

class Canonical extends DataClass implements Insertable<Canonical> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String code;
  final String name;

  /// Ícono: ruta remota (la pone el sync al subir) y locales.
  final String? iconPath;
  final String? iconLocalPath;
  final DateTime? iconUploadedAt;
  const Canonical({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.code,
    required this.name,
    this.iconPath,
    this.iconLocalPath,
    this.iconUploadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    if (!nullToAbsent || iconLocalPath != null) {
      map['icon_local_path'] = Variable<String>(iconLocalPath);
    }
    if (!nullToAbsent || iconUploadedAt != null) {
      map['icon_uploaded_at'] = Variable<DateTime>(iconUploadedAt);
    }
    return map;
  }

  CanonicalsCompanion toCompanion(bool nullToAbsent) {
    return CanonicalsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      code: Value(code),
      name: Value(name),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      iconLocalPath: iconLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconLocalPath),
      iconUploadedAt: iconUploadedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(iconUploadedAt),
    );
  }

  factory Canonical.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Canonical(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      iconLocalPath: serializer.fromJson<String?>(json['iconLocalPath']),
      iconUploadedAt: serializer.fromJson<DateTime?>(json['iconUploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'iconPath': serializer.toJson<String?>(iconPath),
      'iconLocalPath': serializer.toJson<String?>(iconLocalPath),
      'iconUploadedAt': serializer.toJson<DateTime?>(iconUploadedAt),
    };
  }

  Canonical copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? code,
    String? name,
    Value<String?> iconPath = const Value.absent(),
    Value<String?> iconLocalPath = const Value.absent(),
    Value<DateTime?> iconUploadedAt = const Value.absent(),
  }) => Canonical(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    code: code ?? this.code,
    name: name ?? this.name,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    iconLocalPath: iconLocalPath.present
        ? iconLocalPath.value
        : this.iconLocalPath,
    iconUploadedAt: iconUploadedAt.present
        ? iconUploadedAt.value
        : this.iconUploadedAt,
  );
  Canonical copyWithCompanion(CanonicalsCompanion data) {
    return Canonical(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      iconLocalPath: data.iconLocalPath.present
          ? data.iconLocalPath.value
          : this.iconLocalPath,
      iconUploadedAt: data.iconUploadedAt.present
          ? data.iconUploadedAt.value
          : this.iconUploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Canonical(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('iconPath: $iconPath, ')
          ..write('iconLocalPath: $iconLocalPath, ')
          ..write('iconUploadedAt: $iconUploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    code,
    name,
    iconPath,
    iconLocalPath,
    iconUploadedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Canonical &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.code == this.code &&
          other.name == this.name &&
          other.iconPath == this.iconPath &&
          other.iconLocalPath == this.iconLocalPath &&
          other.iconUploadedAt == this.iconUploadedAt);
}

class CanonicalsCompanion extends UpdateCompanion<Canonical> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> iconPath;
  final Value<String?> iconLocalPath;
  final Value<DateTime?> iconUploadedAt;
  final Value<int> rowid;
  const CanonicalsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.iconLocalPath = const Value.absent(),
    this.iconUploadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CanonicalsCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String code,
    required String name,
    this.iconPath = const Value.absent(),
    this.iconLocalPath = const Value.absent(),
    this.iconUploadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name);
  static Insertable<Canonical> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? iconPath,
    Expression<String>? iconLocalPath,
    Expression<DateTime>? iconUploadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (iconPath != null) 'icon_path': iconPath,
      if (iconLocalPath != null) 'icon_local_path': iconLocalPath,
      if (iconUploadedAt != null) 'icon_uploaded_at': iconUploadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CanonicalsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? iconPath,
    Value<String?>? iconLocalPath,
    Value<DateTime?>? iconUploadedAt,
    Value<int>? rowid,
  }) {
    return CanonicalsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      code: code ?? this.code,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      iconLocalPath: iconLocalPath ?? this.iconLocalPath,
      iconUploadedAt: iconUploadedAt ?? this.iconUploadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (iconLocalPath.present) {
      map['icon_local_path'] = Variable<String>(iconLocalPath.value);
    }
    if (iconUploadedAt.present) {
      map['icon_uploaded_at'] = Variable<DateTime>(iconUploadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CanonicalsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('iconPath: $iconPath, ')
          ..write('iconLocalPath: $iconLocalPath, ')
          ..write('iconUploadedAt: $iconUploadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToolModelsTable extends ToolModels
    with TableInfo<$ToolModelsTable, ToolModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToolModelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specMeta = const VerificationMeta('spec');
  @override
  late final GeneratedColumn<String> spec = GeneratedColumn<String>(
    'spec',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineMeta = const VerificationMeta('line');
  @override
  late final GeneratedColumn<String> line = GeneratedColumn<String>(
    'line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ind'),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierCodeMeta = const VerificationMeta(
    'supplierCode',
  );
  @override
  late final GeneratedColumn<String> supplierCode = GeneratedColumn<String>(
    'supplier_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listCostMeta = const VerificationMeta(
    'listCost',
  );
  @override
  late final GeneratedColumn<double> listCost = GeneratedColumn<double>(
    'list_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rateHalfDayMeta = const VerificationMeta(
    'rateHalfDay',
  );
  @override
  late final GeneratedColumn<double> rateHalfDay = GeneratedColumn<double>(
    'rate_half_day',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateDayMeta = const VerificationMeta(
    'rateDay',
  );
  @override
  late final GeneratedColumn<double> rateDay = GeneratedColumn<double>(
    'rate_day',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateWeekMeta = const VerificationMeta(
    'rateWeek',
  );
  @override
  late final GeneratedColumn<double> rateWeek = GeneratedColumn<double>(
    'rate_week',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rateMonthMeta = const VerificationMeta(
    'rateMonth',
  );
  @override
  late final GeneratedColumn<double> rateMonth = GeneratedColumn<double>(
    'rate_month',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _b87QtyMeta = const VerificationMeta('b87Qty');
  @override
  late final GeneratedColumn<double> b87Qty = GeneratedColumn<double>(
    'b87_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _publishedMeta = const VerificationMeta(
    'published',
  );
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
    'published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratCodeMeta = const VerificationMeta(
    'ratCode',
  );
  @override
  late final GeneratedColumn<String> ratCode = GeneratedColumn<String>(
    'rat_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canonicalCodeMeta = const VerificationMeta(
    'canonicalCode',
  );
  @override
  late final GeneratedColumn<String> canonicalCode = GeneratedColumn<String>(
    'canonical_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canonicalNameMeta = const VerificationMeta(
    'canonicalName',
  );
  @override
  late final GeneratedColumn<String> canonicalName = GeneratedColumn<String>(
    'canonical_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _variantMeta = const VerificationMeta(
    'variant',
  );
  @override
  late final GeneratedColumn<String> variant = GeneratedColumn<String>(
    'variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    name,
    spec,
    line,
    brand,
    supplierCode,
    description,
    categoryId,
    listCost,
    rateHalfDay,
    rateDay,
    rateWeek,
    rateMonth,
    b87Qty,
    published,
    photoPath,
    notes,
    ratCode,
    canonicalCode,
    canonicalName,
    variant,
    supplierId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tool_models';
  @override
  VerificationContext validateIntegrity(
    Insertable<ToolModel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('spec')) {
      context.handle(
        _specMeta,
        spec.isAcceptableOrUnknown(data['spec']!, _specMeta),
      );
    }
    if (data.containsKey('line')) {
      context.handle(
        _lineMeta,
        line.isAcceptableOrUnknown(data['line']!, _lineMeta),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('supplier_code')) {
      context.handle(
        _supplierCodeMeta,
        supplierCode.isAcceptableOrUnknown(
          data['supplier_code']!,
          _supplierCodeMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('list_cost')) {
      context.handle(
        _listCostMeta,
        listCost.isAcceptableOrUnknown(data['list_cost']!, _listCostMeta),
      );
    }
    if (data.containsKey('rate_half_day')) {
      context.handle(
        _rateHalfDayMeta,
        rateHalfDay.isAcceptableOrUnknown(
          data['rate_half_day']!,
          _rateHalfDayMeta,
        ),
      );
    }
    if (data.containsKey('rate_day')) {
      context.handle(
        _rateDayMeta,
        rateDay.isAcceptableOrUnknown(data['rate_day']!, _rateDayMeta),
      );
    }
    if (data.containsKey('rate_week')) {
      context.handle(
        _rateWeekMeta,
        rateWeek.isAcceptableOrUnknown(data['rate_week']!, _rateWeekMeta),
      );
    }
    if (data.containsKey('rate_month')) {
      context.handle(
        _rateMonthMeta,
        rateMonth.isAcceptableOrUnknown(data['rate_month']!, _rateMonthMeta),
      );
    }
    if (data.containsKey('b87_qty')) {
      context.handle(
        _b87QtyMeta,
        b87Qty.isAcceptableOrUnknown(data['b87_qty']!, _b87QtyMeta),
      );
    }
    if (data.containsKey('published')) {
      context.handle(
        _publishedMeta,
        published.isAcceptableOrUnknown(data['published']!, _publishedMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('rat_code')) {
      context.handle(
        _ratCodeMeta,
        ratCode.isAcceptableOrUnknown(data['rat_code']!, _ratCodeMeta),
      );
    }
    if (data.containsKey('canonical_code')) {
      context.handle(
        _canonicalCodeMeta,
        canonicalCode.isAcceptableOrUnknown(
          data['canonical_code']!,
          _canonicalCodeMeta,
        ),
      );
    }
    if (data.containsKey('canonical_name')) {
      context.handle(
        _canonicalNameMeta,
        canonicalName.isAcceptableOrUnknown(
          data['canonical_name']!,
          _canonicalNameMeta,
        ),
      );
    }
    if (data.containsKey('variant')) {
      context.handle(
        _variantMeta,
        variant.isAcceptableOrUnknown(data['variant']!, _variantMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToolModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToolModel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      spec: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec'],
      ),
      line: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      supplierCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_code'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      listCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}list_cost'],
      )!,
      rateHalfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_half_day'],
      ),
      rateDay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_day'],
      ),
      rateWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_week'],
      ),
      rateMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_month'],
      ),
      b87Qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}b87_qty'],
      )!,
      published: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}published'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      ratCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rat_code'],
      ),
      canonicalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_code'],
      ),
      canonicalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_name'],
      ),
      variant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
    );
  }

  @override
  $ToolModelsTable createAlias(String alias) {
    return $ToolModelsTable(attachedDatabase, alias);
  }
}

class ToolModel extends DataClass implements Insertable<ToolModel> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? spec;

  /// ind = industrial (DeWalt) · diy = económica (Craftsman/Stanley).
  final String line;
  final String? brand;
  final String? supplierCode;
  final String? description;
  final String? categoryId;
  final double listCost;

  /// Tarifas de renta (precarga 14%/20%/70%/200% del costo, editables).
  final double? rateHalfDay;
  final double? rateDay;
  final double? rateWeek;
  final double? rateMonth;

  /// Existencias en la bodega B87 según el maestro (informativo).
  final double b87Qty;

  /// Se publica a la red YASTA vía Connect.
  final bool published;
  final String? photoPath;
  final String? notes;

  /// Código propio Rent a Tool: canónico + secuencial (ej. AAQ-003).
  final String? ratCode;

  /// Subgrupo canónico del ERP Demaco (ej. AAQ) y su nombre completo.
  final String? canonicalCode;
  final String? canonicalName;

  /// Variación dentro del mismo producto (ej. "kit 2 baterías").
  final String? variant;
  final String? supplierId;
  const ToolModel({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.spec,
    required this.line,
    this.brand,
    this.supplierCode,
    this.description,
    this.categoryId,
    required this.listCost,
    this.rateHalfDay,
    this.rateDay,
    this.rateWeek,
    this.rateMonth,
    required this.b87Qty,
    required this.published,
    this.photoPath,
    this.notes,
    this.ratCode,
    this.canonicalCode,
    this.canonicalName,
    this.variant,
    this.supplierId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || spec != null) {
      map['spec'] = Variable<String>(spec);
    }
    map['line'] = Variable<String>(line);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || supplierCode != null) {
      map['supplier_code'] = Variable<String>(supplierCode);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['list_cost'] = Variable<double>(listCost);
    if (!nullToAbsent || rateHalfDay != null) {
      map['rate_half_day'] = Variable<double>(rateHalfDay);
    }
    if (!nullToAbsent || rateDay != null) {
      map['rate_day'] = Variable<double>(rateDay);
    }
    if (!nullToAbsent || rateWeek != null) {
      map['rate_week'] = Variable<double>(rateWeek);
    }
    if (!nullToAbsent || rateMonth != null) {
      map['rate_month'] = Variable<double>(rateMonth);
    }
    map['b87_qty'] = Variable<double>(b87Qty);
    map['published'] = Variable<bool>(published);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || ratCode != null) {
      map['rat_code'] = Variable<String>(ratCode);
    }
    if (!nullToAbsent || canonicalCode != null) {
      map['canonical_code'] = Variable<String>(canonicalCode);
    }
    if (!nullToAbsent || canonicalName != null) {
      map['canonical_name'] = Variable<String>(canonicalName);
    }
    if (!nullToAbsent || variant != null) {
      map['variant'] = Variable<String>(variant);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    return map;
  }

  ToolModelsCompanion toCompanion(bool nullToAbsent) {
    return ToolModelsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      spec: spec == null && nullToAbsent ? const Value.absent() : Value(spec),
      line: Value(line),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      supplierCode: supplierCode == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierCode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      listCost: Value(listCost),
      rateHalfDay: rateHalfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(rateHalfDay),
      rateDay: rateDay == null && nullToAbsent
          ? const Value.absent()
          : Value(rateDay),
      rateWeek: rateWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(rateWeek),
      rateMonth: rateMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(rateMonth),
      b87Qty: Value(b87Qty),
      published: Value(published),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      ratCode: ratCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ratCode),
      canonicalCode: canonicalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(canonicalCode),
      canonicalName: canonicalName == null && nullToAbsent
          ? const Value.absent()
          : Value(canonicalName),
      variant: variant == null && nullToAbsent
          ? const Value.absent()
          : Value(variant),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
    );
  }

  factory ToolModel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToolModel(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      spec: serializer.fromJson<String?>(json['spec']),
      line: serializer.fromJson<String>(json['line']),
      brand: serializer.fromJson<String?>(json['brand']),
      supplierCode: serializer.fromJson<String?>(json['supplierCode']),
      description: serializer.fromJson<String?>(json['description']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      listCost: serializer.fromJson<double>(json['listCost']),
      rateHalfDay: serializer.fromJson<double?>(json['rateHalfDay']),
      rateDay: serializer.fromJson<double?>(json['rateDay']),
      rateWeek: serializer.fromJson<double?>(json['rateWeek']),
      rateMonth: serializer.fromJson<double?>(json['rateMonth']),
      b87Qty: serializer.fromJson<double>(json['b87Qty']),
      published: serializer.fromJson<bool>(json['published']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      ratCode: serializer.fromJson<String?>(json['ratCode']),
      canonicalCode: serializer.fromJson<String?>(json['canonicalCode']),
      canonicalName: serializer.fromJson<String?>(json['canonicalName']),
      variant: serializer.fromJson<String?>(json['variant']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'spec': serializer.toJson<String?>(spec),
      'line': serializer.toJson<String>(line),
      'brand': serializer.toJson<String?>(brand),
      'supplierCode': serializer.toJson<String?>(supplierCode),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<String?>(categoryId),
      'listCost': serializer.toJson<double>(listCost),
      'rateHalfDay': serializer.toJson<double?>(rateHalfDay),
      'rateDay': serializer.toJson<double?>(rateDay),
      'rateWeek': serializer.toJson<double?>(rateWeek),
      'rateMonth': serializer.toJson<double?>(rateMonth),
      'b87Qty': serializer.toJson<double>(b87Qty),
      'published': serializer.toJson<bool>(published),
      'photoPath': serializer.toJson<String?>(photoPath),
      'notes': serializer.toJson<String?>(notes),
      'ratCode': serializer.toJson<String?>(ratCode),
      'canonicalCode': serializer.toJson<String?>(canonicalCode),
      'canonicalName': serializer.toJson<String?>(canonicalName),
      'variant': serializer.toJson<String?>(variant),
      'supplierId': serializer.toJson<String?>(supplierId),
    };
  }

  ToolModel copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> spec = const Value.absent(),
    String? line,
    Value<String?> brand = const Value.absent(),
    Value<String?> supplierCode = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    double? listCost,
    Value<double?> rateHalfDay = const Value.absent(),
    Value<double?> rateDay = const Value.absent(),
    Value<double?> rateWeek = const Value.absent(),
    Value<double?> rateMonth = const Value.absent(),
    double? b87Qty,
    bool? published,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> ratCode = const Value.absent(),
    Value<String?> canonicalCode = const Value.absent(),
    Value<String?> canonicalName = const Value.absent(),
    Value<String?> variant = const Value.absent(),
    Value<String?> supplierId = const Value.absent(),
  }) => ToolModel(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    spec: spec.present ? spec.value : this.spec,
    line: line ?? this.line,
    brand: brand.present ? brand.value : this.brand,
    supplierCode: supplierCode.present ? supplierCode.value : this.supplierCode,
    description: description.present ? description.value : this.description,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    listCost: listCost ?? this.listCost,
    rateHalfDay: rateHalfDay.present ? rateHalfDay.value : this.rateHalfDay,
    rateDay: rateDay.present ? rateDay.value : this.rateDay,
    rateWeek: rateWeek.present ? rateWeek.value : this.rateWeek,
    rateMonth: rateMonth.present ? rateMonth.value : this.rateMonth,
    b87Qty: b87Qty ?? this.b87Qty,
    published: published ?? this.published,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    notes: notes.present ? notes.value : this.notes,
    ratCode: ratCode.present ? ratCode.value : this.ratCode,
    canonicalCode: canonicalCode.present
        ? canonicalCode.value
        : this.canonicalCode,
    canonicalName: canonicalName.present
        ? canonicalName.value
        : this.canonicalName,
    variant: variant.present ? variant.value : this.variant,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
  );
  ToolModel copyWithCompanion(ToolModelsCompanion data) {
    return ToolModel(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      spec: data.spec.present ? data.spec.value : this.spec,
      line: data.line.present ? data.line.value : this.line,
      brand: data.brand.present ? data.brand.value : this.brand,
      supplierCode: data.supplierCode.present
          ? data.supplierCode.value
          : this.supplierCode,
      description: data.description.present
          ? data.description.value
          : this.description,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      listCost: data.listCost.present ? data.listCost.value : this.listCost,
      rateHalfDay: data.rateHalfDay.present
          ? data.rateHalfDay.value
          : this.rateHalfDay,
      rateDay: data.rateDay.present ? data.rateDay.value : this.rateDay,
      rateWeek: data.rateWeek.present ? data.rateWeek.value : this.rateWeek,
      rateMonth: data.rateMonth.present ? data.rateMonth.value : this.rateMonth,
      b87Qty: data.b87Qty.present ? data.b87Qty.value : this.b87Qty,
      published: data.published.present ? data.published.value : this.published,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      ratCode: data.ratCode.present ? data.ratCode.value : this.ratCode,
      canonicalCode: data.canonicalCode.present
          ? data.canonicalCode.value
          : this.canonicalCode,
      canonicalName: data.canonicalName.present
          ? data.canonicalName.value
          : this.canonicalName,
      variant: data.variant.present ? data.variant.value : this.variant,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ToolModel(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('spec: $spec, ')
          ..write('line: $line, ')
          ..write('brand: $brand, ')
          ..write('supplierCode: $supplierCode, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('listCost: $listCost, ')
          ..write('rateHalfDay: $rateHalfDay, ')
          ..write('rateDay: $rateDay, ')
          ..write('rateWeek: $rateWeek, ')
          ..write('rateMonth: $rateMonth, ')
          ..write('b87Qty: $b87Qty, ')
          ..write('published: $published, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('ratCode: $ratCode, ')
          ..write('canonicalCode: $canonicalCode, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('variant: $variant, ')
          ..write('supplierId: $supplierId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    updatedAt,
    deletedAt,
    name,
    spec,
    line,
    brand,
    supplierCode,
    description,
    categoryId,
    listCost,
    rateHalfDay,
    rateDay,
    rateWeek,
    rateMonth,
    b87Qty,
    published,
    photoPath,
    notes,
    ratCode,
    canonicalCode,
    canonicalName,
    variant,
    supplierId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToolModel &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.spec == this.spec &&
          other.line == this.line &&
          other.brand == this.brand &&
          other.supplierCode == this.supplierCode &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.listCost == this.listCost &&
          other.rateHalfDay == this.rateHalfDay &&
          other.rateDay == this.rateDay &&
          other.rateWeek == this.rateWeek &&
          other.rateMonth == this.rateMonth &&
          other.b87Qty == this.b87Qty &&
          other.published == this.published &&
          other.photoPath == this.photoPath &&
          other.notes == this.notes &&
          other.ratCode == this.ratCode &&
          other.canonicalCode == this.canonicalCode &&
          other.canonicalName == this.canonicalName &&
          other.variant == this.variant &&
          other.supplierId == this.supplierId);
}

class ToolModelsCompanion extends UpdateCompanion<ToolModel> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> spec;
  final Value<String> line;
  final Value<String?> brand;
  final Value<String?> supplierCode;
  final Value<String?> description;
  final Value<String?> categoryId;
  final Value<double> listCost;
  final Value<double?> rateHalfDay;
  final Value<double?> rateDay;
  final Value<double?> rateWeek;
  final Value<double?> rateMonth;
  final Value<double> b87Qty;
  final Value<bool> published;
  final Value<String?> photoPath;
  final Value<String?> notes;
  final Value<String?> ratCode;
  final Value<String?> canonicalCode;
  final Value<String?> canonicalName;
  final Value<String?> variant;
  final Value<String?> supplierId;
  final Value<int> rowid;
  const ToolModelsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.spec = const Value.absent(),
    this.line = const Value.absent(),
    this.brand = const Value.absent(),
    this.supplierCode = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.listCost = const Value.absent(),
    this.rateHalfDay = const Value.absent(),
    this.rateDay = const Value.absent(),
    this.rateWeek = const Value.absent(),
    this.rateMonth = const Value.absent(),
    this.b87Qty = const Value.absent(),
    this.published = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.ratCode = const Value.absent(),
    this.canonicalCode = const Value.absent(),
    this.canonicalName = const Value.absent(),
    this.variant = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ToolModelsCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.spec = const Value.absent(),
    this.line = const Value.absent(),
    this.brand = const Value.absent(),
    this.supplierCode = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.listCost = const Value.absent(),
    this.rateHalfDay = const Value.absent(),
    this.rateDay = const Value.absent(),
    this.rateWeek = const Value.absent(),
    this.rateMonth = const Value.absent(),
    this.b87Qty = const Value.absent(),
    this.published = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.ratCode = const Value.absent(),
    this.canonicalCode = const Value.absent(),
    this.canonicalName = const Value.absent(),
    this.variant = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<ToolModel> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? spec,
    Expression<String>? line,
    Expression<String>? brand,
    Expression<String>? supplierCode,
    Expression<String>? description,
    Expression<String>? categoryId,
    Expression<double>? listCost,
    Expression<double>? rateHalfDay,
    Expression<double>? rateDay,
    Expression<double>? rateWeek,
    Expression<double>? rateMonth,
    Expression<double>? b87Qty,
    Expression<bool>? published,
    Expression<String>? photoPath,
    Expression<String>? notes,
    Expression<String>? ratCode,
    Expression<String>? canonicalCode,
    Expression<String>? canonicalName,
    Expression<String>? variant,
    Expression<String>? supplierId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (spec != null) 'spec': spec,
      if (line != null) 'line': line,
      if (brand != null) 'brand': brand,
      if (supplierCode != null) 'supplier_code': supplierCode,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (listCost != null) 'list_cost': listCost,
      if (rateHalfDay != null) 'rate_half_day': rateHalfDay,
      if (rateDay != null) 'rate_day': rateDay,
      if (rateWeek != null) 'rate_week': rateWeek,
      if (rateMonth != null) 'rate_month': rateMonth,
      if (b87Qty != null) 'b87_qty': b87Qty,
      if (published != null) 'published': published,
      if (photoPath != null) 'photo_path': photoPath,
      if (notes != null) 'notes': notes,
      if (ratCode != null) 'rat_code': ratCode,
      if (canonicalCode != null) 'canonical_code': canonicalCode,
      if (canonicalName != null) 'canonical_name': canonicalName,
      if (variant != null) 'variant': variant,
      if (supplierId != null) 'supplier_id': supplierId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ToolModelsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? spec,
    Value<String>? line,
    Value<String?>? brand,
    Value<String?>? supplierCode,
    Value<String?>? description,
    Value<String?>? categoryId,
    Value<double>? listCost,
    Value<double?>? rateHalfDay,
    Value<double?>? rateDay,
    Value<double?>? rateWeek,
    Value<double?>? rateMonth,
    Value<double>? b87Qty,
    Value<bool>? published,
    Value<String?>? photoPath,
    Value<String?>? notes,
    Value<String?>? ratCode,
    Value<String?>? canonicalCode,
    Value<String?>? canonicalName,
    Value<String?>? variant,
    Value<String?>? supplierId,
    Value<int>? rowid,
  }) {
    return ToolModelsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      spec: spec ?? this.spec,
      line: line ?? this.line,
      brand: brand ?? this.brand,
      supplierCode: supplierCode ?? this.supplierCode,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      listCost: listCost ?? this.listCost,
      rateHalfDay: rateHalfDay ?? this.rateHalfDay,
      rateDay: rateDay ?? this.rateDay,
      rateWeek: rateWeek ?? this.rateWeek,
      rateMonth: rateMonth ?? this.rateMonth,
      b87Qty: b87Qty ?? this.b87Qty,
      published: published ?? this.published,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      ratCode: ratCode ?? this.ratCode,
      canonicalCode: canonicalCode ?? this.canonicalCode,
      canonicalName: canonicalName ?? this.canonicalName,
      variant: variant ?? this.variant,
      supplierId: supplierId ?? this.supplierId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (spec.present) {
      map['spec'] = Variable<String>(spec.value);
    }
    if (line.present) {
      map['line'] = Variable<String>(line.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (supplierCode.present) {
      map['supplier_code'] = Variable<String>(supplierCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (listCost.present) {
      map['list_cost'] = Variable<double>(listCost.value);
    }
    if (rateHalfDay.present) {
      map['rate_half_day'] = Variable<double>(rateHalfDay.value);
    }
    if (rateDay.present) {
      map['rate_day'] = Variable<double>(rateDay.value);
    }
    if (rateWeek.present) {
      map['rate_week'] = Variable<double>(rateWeek.value);
    }
    if (rateMonth.present) {
      map['rate_month'] = Variable<double>(rateMonth.value);
    }
    if (b87Qty.present) {
      map['b87_qty'] = Variable<double>(b87Qty.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (ratCode.present) {
      map['rat_code'] = Variable<String>(ratCode.value);
    }
    if (canonicalCode.present) {
      map['canonical_code'] = Variable<String>(canonicalCode.value);
    }
    if (canonicalName.present) {
      map['canonical_name'] = Variable<String>(canonicalName.value);
    }
    if (variant.present) {
      map['variant'] = Variable<String>(variant.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('spec: $spec, ')
          ..write('line: $line, ')
          ..write('brand: $brand, ')
          ..write('supplierCode: $supplierCode, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('listCost: $listCost, ')
          ..write('rateHalfDay: $rateHalfDay, ')
          ..write('rateDay: $rateDay, ')
          ..write('rateWeek: $rateWeek, ')
          ..write('rateMonth: $rateMonth, ')
          ..write('b87Qty: $b87Qty, ')
          ..write('published: $published, ')
          ..write('photoPath: $photoPath, ')
          ..write('notes: $notes, ')
          ..write('ratCode: $ratCode, ')
          ..write('canonicalCode: $canonicalCode, ')
          ..write('canonicalName: $canonicalName, ')
          ..write('variant: $variant, ')
          ..write('supplierId: $supplierId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CanonicalAttributesTable extends CanonicalAttributes
    with TableInfo<$CanonicalAttributesTable, CanonicalAttribute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CanonicalAttributesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canonicalCodeMeta = const VerificationMeta(
    'canonicalCode',
  );
  @override
  late final GeneratedColumn<String> canonicalCode = GeneratedColumn<String>(
    'canonical_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    canonicalCode,
    name,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'canonical_attributes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CanonicalAttribute> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('canonical_code')) {
      context.handle(
        _canonicalCodeMeta,
        canonicalCode.isAcceptableOrUnknown(
          data['canonical_code']!,
          _canonicalCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CanonicalAttribute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CanonicalAttribute(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      canonicalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $CanonicalAttributesTable createAlias(String alias) {
    return $CanonicalAttributesTable(attachedDatabase, alias);
  }
}

class CanonicalAttribute extends DataClass
    implements Insertable<CanonicalAttribute> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String canonicalCode;
  final String name;
  final int position;
  const CanonicalAttribute({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.canonicalCode,
    required this.name,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['canonical_code'] = Variable<String>(canonicalCode);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    return map;
  }

  CanonicalAttributesCompanion toCompanion(bool nullToAbsent) {
    return CanonicalAttributesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      canonicalCode: Value(canonicalCode),
      name: Value(name),
      position: Value(position),
    );
  }

  factory CanonicalAttribute.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CanonicalAttribute(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      canonicalCode: serializer.fromJson<String>(json['canonicalCode']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'canonicalCode': serializer.toJson<String>(canonicalCode),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
    };
  }

  CanonicalAttribute copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? canonicalCode,
    String? name,
    int? position,
  }) => CanonicalAttribute(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    canonicalCode: canonicalCode ?? this.canonicalCode,
    name: name ?? this.name,
    position: position ?? this.position,
  );
  CanonicalAttribute copyWithCompanion(CanonicalAttributesCompanion data) {
    return CanonicalAttribute(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      canonicalCode: data.canonicalCode.present
          ? data.canonicalCode.value
          : this.canonicalCode,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CanonicalAttribute(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('canonicalCode: $canonicalCode, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, canonicalCode, name, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CanonicalAttribute &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.canonicalCode == this.canonicalCode &&
          other.name == this.name &&
          other.position == this.position);
}

class CanonicalAttributesCompanion extends UpdateCompanion<CanonicalAttribute> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> canonicalCode;
  final Value<String> name;
  final Value<int> position;
  final Value<int> rowid;
  const CanonicalAttributesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.canonicalCode = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CanonicalAttributesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String canonicalCode,
    required String name,
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       canonicalCode = Value(canonicalCode),
       name = Value(name);
  static Insertable<CanonicalAttribute> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? canonicalCode,
    Expression<String>? name,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (canonicalCode != null) 'canonical_code': canonicalCode,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CanonicalAttributesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? canonicalCode,
    Value<String>? name,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return CanonicalAttributesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      canonicalCode: canonicalCode ?? this.canonicalCode,
      name: name ?? this.name,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (canonicalCode.present) {
      map['canonical_code'] = Variable<String>(canonicalCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CanonicalAttributesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('canonicalCode: $canonicalCode, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToolModelAttributesTable extends ToolModelAttributes
    with TableInfo<$ToolModelAttributesTable, ToolModelAttribute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToolModelAttributesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toolModelIdMeta = const VerificationMeta(
    'toolModelId',
  );
  @override
  late final GeneratedColumn<String> toolModelId = GeneratedColumn<String>(
    'tool_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    toolModelId,
    name,
    value,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tool_model_attributes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ToolModelAttribute> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('tool_model_id')) {
      context.handle(
        _toolModelIdMeta,
        toolModelId.isAcceptableOrUnknown(
          data['tool_model_id']!,
          _toolModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toolModelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToolModelAttribute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToolModelAttribute(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      toolModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_model_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ToolModelAttributesTable createAlias(String alias) {
    return $ToolModelAttributesTable(attachedDatabase, alias);
  }
}

class ToolModelAttribute extends DataClass
    implements Insertable<ToolModelAttribute> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String toolModelId;
  final String name;
  final String value;
  final int position;
  const ToolModelAttribute({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.toolModelId,
    required this.name,
    required this.value,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['tool_model_id'] = Variable<String>(toolModelId);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    map['position'] = Variable<int>(position);
    return map;
  }

  ToolModelAttributesCompanion toCompanion(bool nullToAbsent) {
    return ToolModelAttributesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      toolModelId: Value(toolModelId),
      name: Value(name),
      value: Value(value),
      position: Value(position),
    );
  }

  factory ToolModelAttribute.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToolModelAttribute(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      toolModelId: serializer.fromJson<String>(json['toolModelId']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'toolModelId': serializer.toJson<String>(toolModelId),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
      'position': serializer.toJson<int>(position),
    };
  }

  ToolModelAttribute copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? toolModelId,
    String? name,
    String? value,
    int? position,
  }) => ToolModelAttribute(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    toolModelId: toolModelId ?? this.toolModelId,
    name: name ?? this.name,
    value: value ?? this.value,
    position: position ?? this.position,
  );
  ToolModelAttribute copyWithCompanion(ToolModelAttributesCompanion data) {
    return ToolModelAttribute(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      toolModelId: data.toolModelId.present
          ? data.toolModelId.value
          : this.toolModelId,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelAttribute(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, toolModelId, name, value, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToolModelAttribute &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.toolModelId == this.toolModelId &&
          other.name == this.name &&
          other.value == this.value &&
          other.position == this.position);
}

class ToolModelAttributesCompanion extends UpdateCompanion<ToolModelAttribute> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> toolModelId;
  final Value<String> name;
  final Value<String> value;
  final Value<int> position;
  final Value<int> rowid;
  const ToolModelAttributesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.toolModelId = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ToolModelAttributesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String toolModelId,
    required String name,
    required String value,
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       toolModelId = Value(toolModelId),
       name = Value(name),
       value = Value(value);
  static Insertable<ToolModelAttribute> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? toolModelId,
    Expression<String>? name,
    Expression<String>? value,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (toolModelId != null) 'tool_model_id': toolModelId,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ToolModelAttributesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? toolModelId,
    Value<String>? name,
    Value<String>? value,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return ToolModelAttributesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      toolModelId: toolModelId ?? this.toolModelId,
      name: name ?? this.name,
      value: value ?? this.value,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (toolModelId.present) {
      map['tool_model_id'] = Variable<String>(toolModelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelAttributesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToolModelCategoriesTable extends ToolModelCategories
    with TableInfo<$ToolModelCategoriesTable, ToolModelCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToolModelCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toolModelIdMeta = const VerificationMeta(
    'toolModelId',
  );
  @override
  late final GeneratedColumn<String> toolModelId = GeneratedColumn<String>(
    'tool_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    toolModelId,
    categoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tool_model_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ToolModelCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('tool_model_id')) {
      context.handle(
        _toolModelIdMeta,
        toolModelId.isAcceptableOrUnknown(
          data['tool_model_id']!,
          _toolModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toolModelIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToolModelCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToolModelCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      toolModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_model_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $ToolModelCategoriesTable createAlias(String alias) {
    return $ToolModelCategoriesTable(attachedDatabase, alias);
  }
}

class ToolModelCategory extends DataClass
    implements Insertable<ToolModelCategory> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String toolModelId;
  final String categoryId;
  const ToolModelCategory({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.toolModelId,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['tool_model_id'] = Variable<String>(toolModelId);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  ToolModelCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ToolModelCategoriesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      toolModelId: Value(toolModelId),
      categoryId: Value(categoryId),
    );
  }

  factory ToolModelCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToolModelCategory(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      toolModelId: serializer.fromJson<String>(json['toolModelId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'toolModelId': serializer.toJson<String>(toolModelId),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  ToolModelCategory copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? toolModelId,
    String? categoryId,
  }) => ToolModelCategory(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    toolModelId: toolModelId ?? this.toolModelId,
    categoryId: categoryId ?? this.categoryId,
  );
  ToolModelCategory copyWithCompanion(ToolModelCategoriesCompanion data) {
    return ToolModelCategory(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      toolModelId: data.toolModelId.present
          ? data.toolModelId.value
          : this.toolModelId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelCategory(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, toolModelId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToolModelCategory &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.toolModelId == this.toolModelId &&
          other.categoryId == this.categoryId);
}

class ToolModelCategoriesCompanion extends UpdateCompanion<ToolModelCategory> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> toolModelId;
  final Value<String> categoryId;
  final Value<int> rowid;
  const ToolModelCategoriesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.toolModelId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ToolModelCategoriesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String toolModelId,
    required String categoryId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       toolModelId = Value(toolModelId),
       categoryId = Value(categoryId);
  static Insertable<ToolModelCategory> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? toolModelId,
    Expression<String>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (toolModelId != null) 'tool_model_id': toolModelId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ToolModelCategoriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? toolModelId,
    Value<String>? categoryId,
    Value<int>? rowid,
  }) {
    return ToolModelCategoriesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      toolModelId: toolModelId ?? this.toolModelId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (toolModelId.present) {
      map['tool_model_id'] = Variable<String>(toolModelId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toolModelIdMeta = const VerificationMeta(
    'toolModelId',
  );
  @override
  late final GeneratedColumn<String> toolModelId = GeneratedColumn<String>(
    'tool_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTagMeta = const VerificationMeta(
    'assetTag',
  );
  @override
  late final GeneratedColumn<String> assetTag = GeneratedColumn<String>(
    'asset_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<String> serial = GeneratedColumn<String>(
    'serial',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('available'),
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseCostMeta = const VerificationMeta(
    'purchaseCost',
  );
  @override
  late final GeneratedColumn<double> purchaseCost = GeneratedColumn<double>(
    'purchase_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mfrModelMeta = const VerificationMeta(
    'mfrModel',
  );
  @override
  late final GeneratedColumn<String> mfrModel = GeneratedColumn<String>(
    'mfr_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _datasheetUrlMeta = const VerificationMeta(
    'datasheetUrl',
  );
  @override
  late final GeneratedColumn<String> datasheetUrl = GeneratedColumn<String>(
    'datasheet_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    toolModelId,
    assetTag,
    serial,
    status,
    condition,
    locationId,
    purchaseDate,
    purchaseCost,
    notes,
    supplierId,
    invoiceNumber,
    brand,
    mfrModel,
    datasheetUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Asset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('tool_model_id')) {
      context.handle(
        _toolModelIdMeta,
        toolModelId.isAcceptableOrUnknown(
          data['tool_model_id']!,
          _toolModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toolModelIdMeta);
    }
    if (data.containsKey('asset_tag')) {
      context.handle(
        _assetTagMeta,
        assetTag.isAcceptableOrUnknown(data['asset_tag']!, _assetTagMeta),
      );
    } else if (isInserting) {
      context.missing(_assetTagMeta);
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('purchase_cost')) {
      context.handle(
        _purchaseCostMeta,
        purchaseCost.isAcceptableOrUnknown(
          data['purchase_cost']!,
          _purchaseCostMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('mfr_model')) {
      context.handle(
        _mfrModelMeta,
        mfrModel.isAcceptableOrUnknown(data['mfr_model']!, _mfrModelMeta),
      );
    }
    if (data.containsKey('datasheet_url')) {
      context.handle(
        _datasheetUrlMeta,
        datasheetUrl.isAcceptableOrUnknown(
          data['datasheet_url']!,
          _datasheetUrlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      toolModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_model_id'],
      )!,
      assetTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_tag'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      purchaseCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_cost'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      ),
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      mfrModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mfr_model'],
      ),
      datasheetUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_url'],
      ),
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String toolModelId;

  /// Correlativo humano impreso en la etiqueta: DEM-0001…
  final String assetTag;
  final String? serial;
  final String status;
  final String condition;
  final String? locationId;
  final DateTime? purchaseDate;
  final double purchaseCost;
  final String? notes;

  /// Compra: proveedor y número de factura.
  final String? supplierId;
  final String? invoiceNumber;

  /// Fabricante de ESTA unidad (el producto es genérico por specs;
  /// dos unidades del mismo producto pueden ser de marcas distintas).
  final String? brand;
  final String? mfrModel;

  /// Link a la ficha técnica del modelo de esta unidad.
  final String? datasheetUrl;
  const Asset({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.toolModelId,
    required this.assetTag,
    this.serial,
    required this.status,
    required this.condition,
    this.locationId,
    this.purchaseDate,
    required this.purchaseCost,
    this.notes,
    this.supplierId,
    this.invoiceNumber,
    this.brand,
    this.mfrModel,
    this.datasheetUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['tool_model_id'] = Variable<String>(toolModelId);
    map['asset_tag'] = Variable<String>(assetTag);
    if (!nullToAbsent || serial != null) {
      map['serial'] = Variable<String>(serial);
    }
    map['status'] = Variable<String>(status);
    map['condition'] = Variable<String>(condition);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    map['purchase_cost'] = Variable<double>(purchaseCost);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || mfrModel != null) {
      map['mfr_model'] = Variable<String>(mfrModel);
    }
    if (!nullToAbsent || datasheetUrl != null) {
      map['datasheet_url'] = Variable<String>(datasheetUrl);
    }
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      toolModelId: Value(toolModelId),
      assetTag: Value(assetTag),
      serial: serial == null && nullToAbsent
          ? const Value.absent()
          : Value(serial),
      status: Value(status),
      condition: Value(condition),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      purchaseCost: Value(purchaseCost),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      mfrModel: mfrModel == null && nullToAbsent
          ? const Value.absent()
          : Value(mfrModel),
      datasheetUrl: datasheetUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(datasheetUrl),
    );
  }

  factory Asset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      toolModelId: serializer.fromJson<String>(json['toolModelId']),
      assetTag: serializer.fromJson<String>(json['assetTag']),
      serial: serializer.fromJson<String?>(json['serial']),
      status: serializer.fromJson<String>(json['status']),
      condition: serializer.fromJson<String>(json['condition']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      purchaseCost: serializer.fromJson<double>(json['purchaseCost']),
      notes: serializer.fromJson<String?>(json['notes']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      brand: serializer.fromJson<String?>(json['brand']),
      mfrModel: serializer.fromJson<String?>(json['mfrModel']),
      datasheetUrl: serializer.fromJson<String?>(json['datasheetUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'toolModelId': serializer.toJson<String>(toolModelId),
      'assetTag': serializer.toJson<String>(assetTag),
      'serial': serializer.toJson<String?>(serial),
      'status': serializer.toJson<String>(status),
      'condition': serializer.toJson<String>(condition),
      'locationId': serializer.toJson<String?>(locationId),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'purchaseCost': serializer.toJson<double>(purchaseCost),
      'notes': serializer.toJson<String?>(notes),
      'supplierId': serializer.toJson<String?>(supplierId),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'brand': serializer.toJson<String?>(brand),
      'mfrModel': serializer.toJson<String?>(mfrModel),
      'datasheetUrl': serializer.toJson<String?>(datasheetUrl),
    };
  }

  Asset copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? toolModelId,
    String? assetTag,
    Value<String?> serial = const Value.absent(),
    String? status,
    String? condition,
    Value<String?> locationId = const Value.absent(),
    Value<DateTime?> purchaseDate = const Value.absent(),
    double? purchaseCost,
    Value<String?> notes = const Value.absent(),
    Value<String?> supplierId = const Value.absent(),
    Value<String?> invoiceNumber = const Value.absent(),
    Value<String?> brand = const Value.absent(),
    Value<String?> mfrModel = const Value.absent(),
    Value<String?> datasheetUrl = const Value.absent(),
  }) => Asset(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    toolModelId: toolModelId ?? this.toolModelId,
    assetTag: assetTag ?? this.assetTag,
    serial: serial.present ? serial.value : this.serial,
    status: status ?? this.status,
    condition: condition ?? this.condition,
    locationId: locationId.present ? locationId.value : this.locationId,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    purchaseCost: purchaseCost ?? this.purchaseCost,
    notes: notes.present ? notes.value : this.notes,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    brand: brand.present ? brand.value : this.brand,
    mfrModel: mfrModel.present ? mfrModel.value : this.mfrModel,
    datasheetUrl: datasheetUrl.present ? datasheetUrl.value : this.datasheetUrl,
  );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      toolModelId: data.toolModelId.present
          ? data.toolModelId.value
          : this.toolModelId,
      assetTag: data.assetTag.present ? data.assetTag.value : this.assetTag,
      serial: data.serial.present ? data.serial.value : this.serial,
      status: data.status.present ? data.status.value : this.status,
      condition: data.condition.present ? data.condition.value : this.condition,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchaseCost: data.purchaseCost.present
          ? data.purchaseCost.value
          : this.purchaseCost,
      notes: data.notes.present ? data.notes.value : this.notes,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      brand: data.brand.present ? data.brand.value : this.brand,
      mfrModel: data.mfrModel.present ? data.mfrModel.value : this.mfrModel,
      datasheetUrl: data.datasheetUrl.present
          ? data.datasheetUrl.value
          : this.datasheetUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('assetTag: $assetTag, ')
          ..write('serial: $serial, ')
          ..write('status: $status, ')
          ..write('condition: $condition, ')
          ..write('locationId: $locationId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchaseCost: $purchaseCost, ')
          ..write('notes: $notes, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('brand: $brand, ')
          ..write('mfrModel: $mfrModel, ')
          ..write('datasheetUrl: $datasheetUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    toolModelId,
    assetTag,
    serial,
    status,
    condition,
    locationId,
    purchaseDate,
    purchaseCost,
    notes,
    supplierId,
    invoiceNumber,
    brand,
    mfrModel,
    datasheetUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.toolModelId == this.toolModelId &&
          other.assetTag == this.assetTag &&
          other.serial == this.serial &&
          other.status == this.status &&
          other.condition == this.condition &&
          other.locationId == this.locationId &&
          other.purchaseDate == this.purchaseDate &&
          other.purchaseCost == this.purchaseCost &&
          other.notes == this.notes &&
          other.supplierId == this.supplierId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.brand == this.brand &&
          other.mfrModel == this.mfrModel &&
          other.datasheetUrl == this.datasheetUrl);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> toolModelId;
  final Value<String> assetTag;
  final Value<String?> serial;
  final Value<String> status;
  final Value<String> condition;
  final Value<String?> locationId;
  final Value<DateTime?> purchaseDate;
  final Value<double> purchaseCost;
  final Value<String?> notes;
  final Value<String?> supplierId;
  final Value<String?> invoiceNumber;
  final Value<String?> brand;
  final Value<String?> mfrModel;
  final Value<String?> datasheetUrl;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.toolModelId = const Value.absent(),
    this.assetTag = const Value.absent(),
    this.serial = const Value.absent(),
    this.status = const Value.absent(),
    this.condition = const Value.absent(),
    this.locationId = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchaseCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.brand = const Value.absent(),
    this.mfrModel = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String toolModelId,
    required String assetTag,
    this.serial = const Value.absent(),
    this.status = const Value.absent(),
    this.condition = const Value.absent(),
    this.locationId = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchaseCost = const Value.absent(),
    this.notes = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.brand = const Value.absent(),
    this.mfrModel = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       toolModelId = Value(toolModelId),
       assetTag = Value(assetTag);
  static Insertable<Asset> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? toolModelId,
    Expression<String>? assetTag,
    Expression<String>? serial,
    Expression<String>? status,
    Expression<String>? condition,
    Expression<String>? locationId,
    Expression<DateTime>? purchaseDate,
    Expression<double>? purchaseCost,
    Expression<String>? notes,
    Expression<String>? supplierId,
    Expression<String>? invoiceNumber,
    Expression<String>? brand,
    Expression<String>? mfrModel,
    Expression<String>? datasheetUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (toolModelId != null) 'tool_model_id': toolModelId,
      if (assetTag != null) 'asset_tag': assetTag,
      if (serial != null) 'serial': serial,
      if (status != null) 'status': status,
      if (condition != null) 'condition': condition,
      if (locationId != null) 'location_id': locationId,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchaseCost != null) 'purchase_cost': purchaseCost,
      if (notes != null) 'notes': notes,
      if (supplierId != null) 'supplier_id': supplierId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (brand != null) 'brand': brand,
      if (mfrModel != null) 'mfr_model': mfrModel,
      if (datasheetUrl != null) 'datasheet_url': datasheetUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? toolModelId,
    Value<String>? assetTag,
    Value<String?>? serial,
    Value<String>? status,
    Value<String>? condition,
    Value<String?>? locationId,
    Value<DateTime?>? purchaseDate,
    Value<double>? purchaseCost,
    Value<String?>? notes,
    Value<String?>? supplierId,
    Value<String?>? invoiceNumber,
    Value<String?>? brand,
    Value<String?>? mfrModel,
    Value<String?>? datasheetUrl,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      toolModelId: toolModelId ?? this.toolModelId,
      assetTag: assetTag ?? this.assetTag,
      serial: serial ?? this.serial,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      locationId: locationId ?? this.locationId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      notes: notes ?? this.notes,
      supplierId: supplierId ?? this.supplierId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      brand: brand ?? this.brand,
      mfrModel: mfrModel ?? this.mfrModel,
      datasheetUrl: datasheetUrl ?? this.datasheetUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (toolModelId.present) {
      map['tool_model_id'] = Variable<String>(toolModelId.value);
    }
    if (assetTag.present) {
      map['asset_tag'] = Variable<String>(assetTag.value);
    }
    if (serial.present) {
      map['serial'] = Variable<String>(serial.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (purchaseCost.present) {
      map['purchase_cost'] = Variable<double>(purchaseCost.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (mfrModel.present) {
      map['mfr_model'] = Variable<String>(mfrModel.value);
    }
    if (datasheetUrl.present) {
      map['datasheet_url'] = Variable<String>(datasheetUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('assetTag: $assetTag, ')
          ..write('serial: $serial, ')
          ..write('status: $status, ')
          ..write('condition: $condition, ')
          ..write('locationId: $locationId, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchaseCost: $purchaseCost, ')
          ..write('notes: $notes, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('brand: $brand, ')
          ..write('mfrModel: $mfrModel, ')
          ..write('datasheetUrl: $datasheetUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsumablesTable extends Consumables
    with TableInfo<$ConsumablesTable, Consumable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsumablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('u'),
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<double> stock = GeneratedColumn<double>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minStockMeta = const VerificationMeta(
    'minStock',
  );
  @override
  late final GeneratedColumn<double> minStock = GeneratedColumn<double>(
    'min_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canonicalCodeMeta = const VerificationMeta(
    'canonicalCode',
  );
  @override
  late final GeneratedColumn<String> canonicalCode = GeneratedColumn<String>(
    'canonical_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    code,
    name,
    unit,
    cost,
    salePrice,
    stock,
    minStock,
    locationId,
    canonicalCode,
    supplierId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consumables';
  @override
  VerificationContext validateIntegrity(
    Insertable<Consumable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    if (data.containsKey('min_stock')) {
      context.handle(
        _minStockMeta,
        minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('canonical_code')) {
      context.handle(
        _canonicalCodeMeta,
        canonicalCode.isAcceptableOrUnknown(
          data['canonical_code']!,
          _canonicalCodeMeta,
        ),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Consumable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Consumable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock'],
      )!,
      minStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_stock'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      canonicalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_code'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
    );
  }

  @override
  $ConsumablesTable createAlias(String alias) {
    return $ConsumablesTable(attachedDatabase, alias);
  }
}

class Consumable extends DataClass implements Insertable<Consumable> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? code;
  final String name;
  final String unit;
  final double cost;
  final double salePrice;
  final double stock;
  final double minStock;
  final String? locationId;
  final String? canonicalCode;
  final String? supplierId;
  const Consumable({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    this.code,
    required this.name,
    required this.unit,
    required this.cost,
    required this.salePrice,
    required this.stock,
    required this.minStock,
    this.locationId,
    this.canonicalCode,
    this.supplierId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['cost'] = Variable<double>(cost);
    map['sale_price'] = Variable<double>(salePrice);
    map['stock'] = Variable<double>(stock);
    map['min_stock'] = Variable<double>(minStock);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || canonicalCode != null) {
      map['canonical_code'] = Variable<String>(canonicalCode);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    return map;
  }

  ConsumablesCompanion toCompanion(bool nullToAbsent) {
    return ConsumablesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      name: Value(name),
      unit: Value(unit),
      cost: Value(cost),
      salePrice: Value(salePrice),
      stock: Value(stock),
      minStock: Value(minStock),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      canonicalCode: canonicalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(canonicalCode),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
    );
  }

  factory Consumable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Consumable(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      code: serializer.fromJson<String?>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      cost: serializer.fromJson<double>(json['cost']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      stock: serializer.fromJson<double>(json['stock']),
      minStock: serializer.fromJson<double>(json['minStock']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      canonicalCode: serializer.fromJson<String?>(json['canonicalCode']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'code': serializer.toJson<String?>(code),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'cost': serializer.toJson<double>(cost),
      'salePrice': serializer.toJson<double>(salePrice),
      'stock': serializer.toJson<double>(stock),
      'minStock': serializer.toJson<double>(minStock),
      'locationId': serializer.toJson<String?>(locationId),
      'canonicalCode': serializer.toJson<String?>(canonicalCode),
      'supplierId': serializer.toJson<String?>(supplierId),
    };
  }

  Consumable copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> code = const Value.absent(),
    String? name,
    String? unit,
    double? cost,
    double? salePrice,
    double? stock,
    double? minStock,
    Value<String?> locationId = const Value.absent(),
    Value<String?> canonicalCode = const Value.absent(),
    Value<String?> supplierId = const Value.absent(),
  }) => Consumable(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    code: code.present ? code.value : this.code,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    cost: cost ?? this.cost,
    salePrice: salePrice ?? this.salePrice,
    stock: stock ?? this.stock,
    minStock: minStock ?? this.minStock,
    locationId: locationId.present ? locationId.value : this.locationId,
    canonicalCode: canonicalCode.present
        ? canonicalCode.value
        : this.canonicalCode,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
  );
  Consumable copyWithCompanion(ConsumablesCompanion data) {
    return Consumable(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      cost: data.cost.present ? data.cost.value : this.cost,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      stock: data.stock.present ? data.stock.value : this.stock,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      canonicalCode: data.canonicalCode.present
          ? data.canonicalCode.value
          : this.canonicalCode,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Consumable(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('cost: $cost, ')
          ..write('salePrice: $salePrice, ')
          ..write('stock: $stock, ')
          ..write('minStock: $minStock, ')
          ..write('locationId: $locationId, ')
          ..write('canonicalCode: $canonicalCode, ')
          ..write('supplierId: $supplierId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    code,
    name,
    unit,
    cost,
    salePrice,
    stock,
    minStock,
    locationId,
    canonicalCode,
    supplierId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Consumable &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.code == this.code &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.cost == this.cost &&
          other.salePrice == this.salePrice &&
          other.stock == this.stock &&
          other.minStock == this.minStock &&
          other.locationId == this.locationId &&
          other.canonicalCode == this.canonicalCode &&
          other.supplierId == this.supplierId);
}

class ConsumablesCompanion extends UpdateCompanion<Consumable> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> code;
  final Value<String> name;
  final Value<String> unit;
  final Value<double> cost;
  final Value<double> salePrice;
  final Value<double> stock;
  final Value<double> minStock;
  final Value<String?> locationId;
  final Value<String?> canonicalCode;
  final Value<String?> supplierId;
  final Value<int> rowid;
  const ConsumablesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.cost = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.stock = const Value.absent(),
    this.minStock = const Value.absent(),
    this.locationId = const Value.absent(),
    this.canonicalCode = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsumablesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.code = const Value.absent(),
    required String name,
    this.unit = const Value.absent(),
    this.cost = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.stock = const Value.absent(),
    this.minStock = const Value.absent(),
    this.locationId = const Value.absent(),
    this.canonicalCode = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Consumable> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? cost,
    Expression<double>? salePrice,
    Expression<double>? stock,
    Expression<double>? minStock,
    Expression<String>? locationId,
    Expression<String>? canonicalCode,
    Expression<String>? supplierId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (cost != null) 'cost': cost,
      if (salePrice != null) 'sale_price': salePrice,
      if (stock != null) 'stock': stock,
      if (minStock != null) 'min_stock': minStock,
      if (locationId != null) 'location_id': locationId,
      if (canonicalCode != null) 'canonical_code': canonicalCode,
      if (supplierId != null) 'supplier_id': supplierId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsumablesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? code,
    Value<String>? name,
    Value<String>? unit,
    Value<double>? cost,
    Value<double>? salePrice,
    Value<double>? stock,
    Value<double>? minStock,
    Value<String?>? locationId,
    Value<String?>? canonicalCode,
    Value<String?>? supplierId,
    Value<int>? rowid,
  }) {
    return ConsumablesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      cost: cost ?? this.cost,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      locationId: locationId ?? this.locationId,
      canonicalCode: canonicalCode ?? this.canonicalCode,
      supplierId: supplierId ?? this.supplierId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (stock.present) {
      map['stock'] = Variable<double>(stock.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<double>(minStock.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (canonicalCode.present) {
      map['canonical_code'] = Variable<String>(canonicalCode.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsumablesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('cost: $cost, ')
          ..write('salePrice: $salePrice, ')
          ..write('stock: $stock, ')
          ..write('minStock: $minStock, ')
          ..write('locationId: $locationId, ')
          ..write('canonicalCode: $canonicalCode, ')
          ..write('supplierId: $supplierId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ToolModelConsumablesTable extends ToolModelConsumables
    with TableInfo<$ToolModelConsumablesTable, ToolModelConsumable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToolModelConsumablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toolModelIdMeta = const VerificationMeta(
    'toolModelId',
  );
  @override
  late final GeneratedColumn<String> toolModelId = GeneratedColumn<String>(
    'tool_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consumableIdMeta = const VerificationMeta(
    'consumableId',
  );
  @override
  late final GeneratedColumn<String> consumableId = GeneratedColumn<String>(
    'consumable_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    toolModelId,
    consumableId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tool_model_consumables';
  @override
  VerificationContext validateIntegrity(
    Insertable<ToolModelConsumable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('tool_model_id')) {
      context.handle(
        _toolModelIdMeta,
        toolModelId.isAcceptableOrUnknown(
          data['tool_model_id']!,
          _toolModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toolModelIdMeta);
    }
    if (data.containsKey('consumable_id')) {
      context.handle(
        _consumableIdMeta,
        consumableId.isAcceptableOrUnknown(
          data['consumable_id']!,
          _consumableIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consumableIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToolModelConsumable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToolModelConsumable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      toolModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_model_id'],
      )!,
      consumableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consumable_id'],
      )!,
    );
  }

  @override
  $ToolModelConsumablesTable createAlias(String alias) {
    return $ToolModelConsumablesTable(attachedDatabase, alias);
  }
}

class ToolModelConsumable extends DataClass
    implements Insertable<ToolModelConsumable> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String toolModelId;
  final String consumableId;
  const ToolModelConsumable({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.toolModelId,
    required this.consumableId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['tool_model_id'] = Variable<String>(toolModelId);
    map['consumable_id'] = Variable<String>(consumableId);
    return map;
  }

  ToolModelConsumablesCompanion toCompanion(bool nullToAbsent) {
    return ToolModelConsumablesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      toolModelId: Value(toolModelId),
      consumableId: Value(consumableId),
    );
  }

  factory ToolModelConsumable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToolModelConsumable(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      toolModelId: serializer.fromJson<String>(json['toolModelId']),
      consumableId: serializer.fromJson<String>(json['consumableId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'toolModelId': serializer.toJson<String>(toolModelId),
      'consumableId': serializer.toJson<String>(consumableId),
    };
  }

  ToolModelConsumable copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? toolModelId,
    String? consumableId,
  }) => ToolModelConsumable(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    toolModelId: toolModelId ?? this.toolModelId,
    consumableId: consumableId ?? this.consumableId,
  );
  ToolModelConsumable copyWithCompanion(ToolModelConsumablesCompanion data) {
    return ToolModelConsumable(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      toolModelId: data.toolModelId.present
          ? data.toolModelId.value
          : this.toolModelId,
      consumableId: data.consumableId.present
          ? data.consumableId.value
          : this.consumableId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelConsumable(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('consumableId: $consumableId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deletedAt, toolModelId, consumableId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToolModelConsumable &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.toolModelId == this.toolModelId &&
          other.consumableId == this.consumableId);
}

class ToolModelConsumablesCompanion
    extends UpdateCompanion<ToolModelConsumable> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> toolModelId;
  final Value<String> consumableId;
  final Value<int> rowid;
  const ToolModelConsumablesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.toolModelId = const Value.absent(),
    this.consumableId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ToolModelConsumablesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String toolModelId,
    required String consumableId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       toolModelId = Value(toolModelId),
       consumableId = Value(consumableId);
  static Insertable<ToolModelConsumable> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? toolModelId,
    Expression<String>? consumableId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (toolModelId != null) 'tool_model_id': toolModelId,
      if (consumableId != null) 'consumable_id': consumableId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ToolModelConsumablesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? toolModelId,
    Value<String>? consumableId,
    Value<int>? rowid,
  }) {
    return ToolModelConsumablesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      toolModelId: toolModelId ?? this.toolModelId,
      consumableId: consumableId ?? this.consumableId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (toolModelId.present) {
      map['tool_model_id'] = Variable<String>(toolModelId.value);
    }
    if (consumableId.present) {
      map['consumable_id'] = Variable<String>(consumableId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToolModelConsumablesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('consumableId: $consumableId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryMovementsTable extends InventoryMovements
    with TableInfo<$InventoryMovementsTable, InventoryMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consumableIdMeta = const VerificationMeta(
    'consumableId',
  );
  @override
  late final GeneratedColumn<String> consumableId = GeneratedColumn<String>(
    'consumable_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _fromLocationIdMeta = const VerificationMeta(
    'fromLocationId',
  );
  @override
  late final GeneratedColumn<String> fromLocationId = GeneratedColumn<String>(
    'from_location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toLocationIdMeta = const VerificationMeta(
    'toLocationId',
  );
  @override
  late final GeneratedColumn<String> toLocationId = GeneratedColumn<String>(
    'to_location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractRefMeta = const VerificationMeta(
    'contractRef',
  );
  @override
  late final GeneratedColumn<String> contractRef = GeneratedColumn<String>(
    'contract_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _movedAtMeta = const VerificationMeta(
    'movedAt',
  );
  @override
  late final GeneratedColumn<DateTime> movedAt = GeneratedColumn<DateTime>(
    'moved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    assetId,
    consumableId,
    kind,
    quantity,
    fromLocationId,
    toLocationId,
    contractRef,
    movedAt,
    createdBy,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    }
    if (data.containsKey('consumable_id')) {
      context.handle(
        _consumableIdMeta,
        consumableId.isAcceptableOrUnknown(
          data['consumable_id']!,
          _consumableIdMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('from_location_id')) {
      context.handle(
        _fromLocationIdMeta,
        fromLocationId.isAcceptableOrUnknown(
          data['from_location_id']!,
          _fromLocationIdMeta,
        ),
      );
    }
    if (data.containsKey('to_location_id')) {
      context.handle(
        _toLocationIdMeta,
        toLocationId.isAcceptableOrUnknown(
          data['to_location_id']!,
          _toLocationIdMeta,
        ),
      );
    }
    if (data.containsKey('contract_ref')) {
      context.handle(
        _contractRefMeta,
        contractRef.isAcceptableOrUnknown(
          data['contract_ref']!,
          _contractRefMeta,
        ),
      );
    }
    if (data.containsKey('moved_at')) {
      context.handle(
        _movedAtMeta,
        movedAt.isAcceptableOrUnknown(data['moved_at']!, _movedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_movedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      ),
      consumableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consumable_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      fromLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_location_id'],
      ),
      toLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_location_id'],
      ),
      contractRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_ref'],
      ),
      movedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}moved_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $InventoryMovementsTable createAlias(String alias) {
    return $InventoryMovementsTable(attachedDatabase, alias);
  }
}

class InventoryMovement extends DataClass
    implements Insertable<InventoryMovement> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? assetId;
  final String? consumableId;

  /// intake | transfer | rent_out | rent_return | maintenance_out |
  /// maintenance_return | adjust | retire | consume | restock
  final String kind;
  final double quantity;
  final String? fromLocationId;
  final String? toLocationId;
  final String? contractRef;
  final DateTime movedAt;
  final String? createdBy;
  final String? notes;
  const InventoryMovement({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    this.assetId,
    this.consumableId,
    required this.kind,
    required this.quantity,
    this.fromLocationId,
    this.toLocationId,
    this.contractRef,
    required this.movedAt,
    this.createdBy,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || assetId != null) {
      map['asset_id'] = Variable<String>(assetId);
    }
    if (!nullToAbsent || consumableId != null) {
      map['consumable_id'] = Variable<String>(consumableId);
    }
    map['kind'] = Variable<String>(kind);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || fromLocationId != null) {
      map['from_location_id'] = Variable<String>(fromLocationId);
    }
    if (!nullToAbsent || toLocationId != null) {
      map['to_location_id'] = Variable<String>(toLocationId);
    }
    if (!nullToAbsent || contractRef != null) {
      map['contract_ref'] = Variable<String>(contractRef);
    }
    map['moved_at'] = Variable<DateTime>(movedAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  InventoryMovementsCompanion toCompanion(bool nullToAbsent) {
    return InventoryMovementsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      assetId: assetId == null && nullToAbsent
          ? const Value.absent()
          : Value(assetId),
      consumableId: consumableId == null && nullToAbsent
          ? const Value.absent()
          : Value(consumableId),
      kind: Value(kind),
      quantity: Value(quantity),
      fromLocationId: fromLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromLocationId),
      toLocationId: toLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(toLocationId),
      contractRef: contractRef == null && nullToAbsent
          ? const Value.absent()
          : Value(contractRef),
      movedAt: Value(movedAt),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory InventoryMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryMovement(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      assetId: serializer.fromJson<String?>(json['assetId']),
      consumableId: serializer.fromJson<String?>(json['consumableId']),
      kind: serializer.fromJson<String>(json['kind']),
      quantity: serializer.fromJson<double>(json['quantity']),
      fromLocationId: serializer.fromJson<String?>(json['fromLocationId']),
      toLocationId: serializer.fromJson<String?>(json['toLocationId']),
      contractRef: serializer.fromJson<String?>(json['contractRef']),
      movedAt: serializer.fromJson<DateTime>(json['movedAt']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'assetId': serializer.toJson<String?>(assetId),
      'consumableId': serializer.toJson<String?>(consumableId),
      'kind': serializer.toJson<String>(kind),
      'quantity': serializer.toJson<double>(quantity),
      'fromLocationId': serializer.toJson<String?>(fromLocationId),
      'toLocationId': serializer.toJson<String?>(toLocationId),
      'contractRef': serializer.toJson<String?>(contractRef),
      'movedAt': serializer.toJson<DateTime>(movedAt),
      'createdBy': serializer.toJson<String?>(createdBy),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  InventoryMovement copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> assetId = const Value.absent(),
    Value<String?> consumableId = const Value.absent(),
    String? kind,
    double? quantity,
    Value<String?> fromLocationId = const Value.absent(),
    Value<String?> toLocationId = const Value.absent(),
    Value<String?> contractRef = const Value.absent(),
    DateTime? movedAt,
    Value<String?> createdBy = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => InventoryMovement(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    assetId: assetId.present ? assetId.value : this.assetId,
    consumableId: consumableId.present ? consumableId.value : this.consumableId,
    kind: kind ?? this.kind,
    quantity: quantity ?? this.quantity,
    fromLocationId: fromLocationId.present
        ? fromLocationId.value
        : this.fromLocationId,
    toLocationId: toLocationId.present ? toLocationId.value : this.toLocationId,
    contractRef: contractRef.present ? contractRef.value : this.contractRef,
    movedAt: movedAt ?? this.movedAt,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    notes: notes.present ? notes.value : this.notes,
  );
  InventoryMovement copyWithCompanion(InventoryMovementsCompanion data) {
    return InventoryMovement(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      consumableId: data.consumableId.present
          ? data.consumableId.value
          : this.consumableId,
      kind: data.kind.present ? data.kind.value : this.kind,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      fromLocationId: data.fromLocationId.present
          ? data.fromLocationId.value
          : this.fromLocationId,
      toLocationId: data.toLocationId.present
          ? data.toLocationId.value
          : this.toLocationId,
      contractRef: data.contractRef.present
          ? data.contractRef.value
          : this.contractRef,
      movedAt: data.movedAt.present ? data.movedAt.value : this.movedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovement(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('assetId: $assetId, ')
          ..write('consumableId: $consumableId, ')
          ..write('kind: $kind, ')
          ..write('quantity: $quantity, ')
          ..write('fromLocationId: $fromLocationId, ')
          ..write('toLocationId: $toLocationId, ')
          ..write('contractRef: $contractRef, ')
          ..write('movedAt: $movedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    assetId,
    consumableId,
    kind,
    quantity,
    fromLocationId,
    toLocationId,
    contractRef,
    movedAt,
    createdBy,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryMovement &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.assetId == this.assetId &&
          other.consumableId == this.consumableId &&
          other.kind == this.kind &&
          other.quantity == this.quantity &&
          other.fromLocationId == this.fromLocationId &&
          other.toLocationId == this.toLocationId &&
          other.contractRef == this.contractRef &&
          other.movedAt == this.movedAt &&
          other.createdBy == this.createdBy &&
          other.notes == this.notes);
}

class InventoryMovementsCompanion extends UpdateCompanion<InventoryMovement> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> assetId;
  final Value<String?> consumableId;
  final Value<String> kind;
  final Value<double> quantity;
  final Value<String?> fromLocationId;
  final Value<String?> toLocationId;
  final Value<String?> contractRef;
  final Value<DateTime> movedAt;
  final Value<String?> createdBy;
  final Value<String?> notes;
  final Value<int> rowid;
  const InventoryMovementsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.assetId = const Value.absent(),
    this.consumableId = const Value.absent(),
    this.kind = const Value.absent(),
    this.quantity = const Value.absent(),
    this.fromLocationId = const Value.absent(),
    this.toLocationId = const Value.absent(),
    this.contractRef = const Value.absent(),
    this.movedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryMovementsCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.assetId = const Value.absent(),
    this.consumableId = const Value.absent(),
    required String kind,
    this.quantity = const Value.absent(),
    this.fromLocationId = const Value.absent(),
    this.toLocationId = const Value.absent(),
    this.contractRef = const Value.absent(),
    required DateTime movedAt,
    this.createdBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       movedAt = Value(movedAt);
  static Insertable<InventoryMovement> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? assetId,
    Expression<String>? consumableId,
    Expression<String>? kind,
    Expression<double>? quantity,
    Expression<String>? fromLocationId,
    Expression<String>? toLocationId,
    Expression<String>? contractRef,
    Expression<DateTime>? movedAt,
    Expression<String>? createdBy,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (assetId != null) 'asset_id': assetId,
      if (consumableId != null) 'consumable_id': consumableId,
      if (kind != null) 'kind': kind,
      if (quantity != null) 'quantity': quantity,
      if (fromLocationId != null) 'from_location_id': fromLocationId,
      if (toLocationId != null) 'to_location_id': toLocationId,
      if (contractRef != null) 'contract_ref': contractRef,
      if (movedAt != null) 'moved_at': movedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryMovementsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? assetId,
    Value<String?>? consumableId,
    Value<String>? kind,
    Value<double>? quantity,
    Value<String?>? fromLocationId,
    Value<String?>? toLocationId,
    Value<String?>? contractRef,
    Value<DateTime>? movedAt,
    Value<String?>? createdBy,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return InventoryMovementsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      assetId: assetId ?? this.assetId,
      consumableId: consumableId ?? this.consumableId,
      kind: kind ?? this.kind,
      quantity: quantity ?? this.quantity,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationId: toLocationId ?? this.toLocationId,
      contractRef: contractRef ?? this.contractRef,
      movedAt: movedAt ?? this.movedAt,
      createdBy: createdBy ?? this.createdBy,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (consumableId.present) {
      map['consumable_id'] = Variable<String>(consumableId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (fromLocationId.present) {
      map['from_location_id'] = Variable<String>(fromLocationId.value);
    }
    if (toLocationId.present) {
      map['to_location_id'] = Variable<String>(toLocationId.value);
    }
    if (contractRef.present) {
      map['contract_ref'] = Variable<String>(contractRef.value);
    }
    if (movedAt.present) {
      map['moved_at'] = Variable<DateTime>(movedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('assetId: $assetId, ')
          ..write('consumableId: $consumableId, ')
          ..write('kind: $kind, ')
          ..write('quantity: $quantity, ')
          ..write('fromLocationId: $fromLocationId, ')
          ..write('toLocationId: $toLocationId, ')
          ..write('contractRef: $contractRef, ')
          ..write('movedAt: $movedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idNumberMeta = const VerificationMeta(
    'idNumber',
  );
  @override
  late final GeneratedColumn<String> idNumber = GeneratedColumn<String>(
    'id_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    name,
    idNumber,
    phone,
    email,
    address,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('id_number')) {
      context.handle(
        _idNumberMeta,
        idNumber.isAcceptableOrUnknown(data['id_number']!, _idNumberMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      idNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_number'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? idNumber;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  const Customer({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.idNumber,
    this.phone,
    this.email,
    this.address,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || idNumber != null) {
      map['id_number'] = Variable<String>(idNumber);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      idNumber: idNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(idNumber),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      idNumber: serializer.fromJson<String?>(json['idNumber']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'idNumber': serializer.toJson<String?>(idNumber),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Customer copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> idNumber = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Customer(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    idNumber: idNumber.present ? idNumber.value : this.idNumber,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      idNumber: data.idNumber.present ? data.idNumber.value : this.idNumber,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('idNumber: $idNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    name,
    idNumber,
    phone,
    email,
    address,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.idNumber == this.idNumber &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> idNumber;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.idNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.idNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? idNumber,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (idNumber != null) 'id_number': idNumber,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? idNumber,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      idNumber: idNumber ?? this.idNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (idNumber.present) {
      map['id_number'] = Variable<String>(idNumber.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('idNumber: $idNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RentalContractsTable extends RentalContracts
    with TableInfo<$RentalContractsTable, RentalContract> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RentalContractsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractNumberMeta = const VerificationMeta(
    'contractNumber',
  );
  @override
  late final GeneratedColumn<String> contractNumber = GeneratedColumn<String>(
    'contract_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _depositMeta = const VerificationMeta(
    'deposit',
  );
  @override
  late final GeneratedColumn<double> deposit = GeneratedColumn<double>(
    'deposit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    contractNumber,
    customerId,
    status,
    startAt,
    dueAt,
    returnedAt,
    deposit,
    notes,
    createdBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rental_contracts';
  @override
  VerificationContext validateIntegrity(
    Insertable<RentalContract> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('contract_number')) {
      context.handle(
        _contractNumberMeta,
        contractNumber.isAcceptableOrUnknown(
          data['contract_number']!,
          _contractNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    }
    if (data.containsKey('deposit')) {
      context.handle(
        _depositMeta,
        deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RentalContract map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RentalContract(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      contractNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_number'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      ),
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      ),
      deposit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deposit'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
    );
  }

  @override
  $RentalContractsTable createAlias(String alias) {
    return $RentalContractsTable(attachedDatabase, alias);
  }
}

class RentalContract extends DataClass implements Insertable<RentalContract> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  /// Correlativo humano: CTR-0001…
  final String contractNumber;
  final String customerId;
  final String status;
  final DateTime? startAt;
  final DateTime? dueAt;
  final DateTime? returnedAt;

  /// Garantía recibida (se devuelve al cierre).
  final double deposit;
  final String? notes;
  final String? createdBy;
  const RentalContract({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.contractNumber,
    required this.customerId,
    required this.status,
    this.startAt,
    this.dueAt,
    this.returnedAt,
    required this.deposit,
    this.notes,
    this.createdBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['contract_number'] = Variable<String>(contractNumber);
    map['customer_id'] = Variable<String>(customerId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<DateTime>(startAt);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || returnedAt != null) {
      map['returned_at'] = Variable<DateTime>(returnedAt);
    }
    map['deposit'] = Variable<double>(deposit);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    return map;
  }

  RentalContractsCompanion toCompanion(bool nullToAbsent) {
    return RentalContractsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      contractNumber: Value(contractNumber),
      customerId: Value(customerId),
      status: Value(status),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      returnedAt: returnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedAt),
      deposit: Value(deposit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory RentalContract.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RentalContract(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      contractNumber: serializer.fromJson<String>(json['contractNumber']),
      customerId: serializer.fromJson<String>(json['customerId']),
      status: serializer.fromJson<String>(json['status']),
      startAt: serializer.fromJson<DateTime?>(json['startAt']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      returnedAt: serializer.fromJson<DateTime?>(json['returnedAt']),
      deposit: serializer.fromJson<double>(json['deposit']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'contractNumber': serializer.toJson<String>(contractNumber),
      'customerId': serializer.toJson<String>(customerId),
      'status': serializer.toJson<String>(status),
      'startAt': serializer.toJson<DateTime?>(startAt),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'returnedAt': serializer.toJson<DateTime?>(returnedAt),
      'deposit': serializer.toJson<double>(deposit),
      'notes': serializer.toJson<String?>(notes),
      'createdBy': serializer.toJson<String?>(createdBy),
    };
  }

  RentalContract copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? contractNumber,
    String? customerId,
    String? status,
    Value<DateTime?> startAt = const Value.absent(),
    Value<DateTime?> dueAt = const Value.absent(),
    Value<DateTime?> returnedAt = const Value.absent(),
    double? deposit,
    Value<String?> notes = const Value.absent(),
    Value<String?> createdBy = const Value.absent(),
  }) => RentalContract(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    contractNumber: contractNumber ?? this.contractNumber,
    customerId: customerId ?? this.customerId,
    status: status ?? this.status,
    startAt: startAt.present ? startAt.value : this.startAt,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    returnedAt: returnedAt.present ? returnedAt.value : this.returnedAt,
    deposit: deposit ?? this.deposit,
    notes: notes.present ? notes.value : this.notes,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
  );
  RentalContract copyWithCompanion(RentalContractsCompanion data) {
    return RentalContract(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      contractNumber: data.contractNumber.present
          ? data.contractNumber.value
          : this.contractNumber,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      status: data.status.present ? data.status.value : this.status,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      deposit: data.deposit.present ? data.deposit.value : this.deposit,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RentalContract(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('contractNumber: $contractNumber, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('startAt: $startAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('deposit: $deposit, ')
          ..write('notes: $notes, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    contractNumber,
    customerId,
    status,
    startAt,
    dueAt,
    returnedAt,
    deposit,
    notes,
    createdBy,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RentalContract &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.contractNumber == this.contractNumber &&
          other.customerId == this.customerId &&
          other.status == this.status &&
          other.startAt == this.startAt &&
          other.dueAt == this.dueAt &&
          other.returnedAt == this.returnedAt &&
          other.deposit == this.deposit &&
          other.notes == this.notes &&
          other.createdBy == this.createdBy);
}

class RentalContractsCompanion extends UpdateCompanion<RentalContract> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> contractNumber;
  final Value<String> customerId;
  final Value<String> status;
  final Value<DateTime?> startAt;
  final Value<DateTime?> dueAt;
  final Value<DateTime?> returnedAt;
  final Value<double> deposit;
  final Value<String?> notes;
  final Value<String?> createdBy;
  final Value<int> rowid;
  const RentalContractsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.contractNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.startAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.deposit = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RentalContractsCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String contractNumber,
    required String customerId,
    this.status = const Value.absent(),
    this.startAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.deposit = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contractNumber = Value(contractNumber),
       customerId = Value(customerId);
  static Insertable<RentalContract> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? contractNumber,
    Expression<String>? customerId,
    Expression<String>? status,
    Expression<DateTime>? startAt,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? returnedAt,
    Expression<double>? deposit,
    Expression<String>? notes,
    Expression<String>? createdBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (contractNumber != null) 'contract_number': contractNumber,
      if (customerId != null) 'customer_id': customerId,
      if (status != null) 'status': status,
      if (startAt != null) 'start_at': startAt,
      if (dueAt != null) 'due_at': dueAt,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (deposit != null) 'deposit': deposit,
      if (notes != null) 'notes': notes,
      if (createdBy != null) 'created_by': createdBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RentalContractsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? contractNumber,
    Value<String>? customerId,
    Value<String>? status,
    Value<DateTime?>? startAt,
    Value<DateTime?>? dueAt,
    Value<DateTime?>? returnedAt,
    Value<double>? deposit,
    Value<String?>? notes,
    Value<String?>? createdBy,
    Value<int>? rowid,
  }) {
    return RentalContractsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      contractNumber: contractNumber ?? this.contractNumber,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      startAt: startAt ?? this.startAt,
      dueAt: dueAt ?? this.dueAt,
      returnedAt: returnedAt ?? this.returnedAt,
      deposit: deposit ?? this.deposit,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (contractNumber.present) {
      map['contract_number'] = Variable<String>(contractNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<double>(deposit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RentalContractsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('contractNumber: $contractNumber, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('startAt: $startAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('deposit: $deposit, ')
          ..write('notes: $notes, ')
          ..write('createdBy: $createdBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RentalLinesTable extends RentalLines
    with TableInfo<$RentalLinesTable, RentalLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RentalLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractIdMeta = const VerificationMeta(
    'contractId',
  );
  @override
  late final GeneratedColumn<String> contractId = GeneratedColumn<String>(
    'contract_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toolModelIdMeta = const VerificationMeta(
    'toolModelId',
  );
  @override
  late final GeneratedColumn<String> toolModelId = GeneratedColumn<String>(
    'tool_model_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateKindMeta = const VerificationMeta(
    'rateKind',
  );
  @override
  late final GeneratedColumn<String> rateKind = GeneratedColumn<String>(
    'rate_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('day'),
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _periodsMeta = const VerificationMeta(
    'periods',
  );
  @override
  late final GeneratedColumn<double> periods = GeneratedColumn<double>(
    'periods',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deliveredAtMeta = const VerificationMeta(
    'deliveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
    'delivered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionOutMeta = const VerificationMeta(
    'conditionOut',
  );
  @override
  late final GeneratedColumn<String> conditionOut = GeneratedColumn<String>(
    'condition_out',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionInMeta = const VerificationMeta(
    'conditionIn',
  );
  @override
  late final GeneratedColumn<String> conditionIn = GeneratedColumn<String>(
    'condition_in',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deletedAt,
    contractId,
    assetId,
    toolModelId,
    rateKind,
    rate,
    periods,
    amount,
    deliveredAt,
    returnedAt,
    conditionOut,
    conditionIn,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rental_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<RentalLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('contract_id')) {
      context.handle(
        _contractIdMeta,
        contractId.isAcceptableOrUnknown(data['contract_id']!, _contractIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('tool_model_id')) {
      context.handle(
        _toolModelIdMeta,
        toolModelId.isAcceptableOrUnknown(
          data['tool_model_id']!,
          _toolModelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toolModelIdMeta);
    }
    if (data.containsKey('rate_kind')) {
      context.handle(
        _rateKindMeta,
        rateKind.isAcceptableOrUnknown(data['rate_kind']!, _rateKindMeta),
      );
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    }
    if (data.containsKey('periods')) {
      context.handle(
        _periodsMeta,
        periods.isAcceptableOrUnknown(data['periods']!, _periodsMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
        _deliveredAtMeta,
        deliveredAt.isAcceptableOrUnknown(
          data['delivered_at']!,
          _deliveredAtMeta,
        ),
      );
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    }
    if (data.containsKey('condition_out')) {
      context.handle(
        _conditionOutMeta,
        conditionOut.isAcceptableOrUnknown(
          data['condition_out']!,
          _conditionOutMeta,
        ),
      );
    }
    if (data.containsKey('condition_in')) {
      context.handle(
        _conditionInMeta,
        conditionIn.isAcceptableOrUnknown(
          data['condition_in']!,
          _conditionInMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RentalLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RentalLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      contractId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      toolModelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool_model_id'],
      )!,
      rateKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate_kind'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      periods: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}periods'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      deliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_at'],
      ),
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      ),
      conditionOut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_out'],
      ),
      conditionIn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_in'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $RentalLinesTable createAlias(String alias) {
    return $RentalLinesTable(attachedDatabase, alias);
  }
}

class RentalLine extends DataClass implements Insertable<RentalLine> {
  final String id;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String contractId;
  final String assetId;
  final String toolModelId;

  /// half_day (bloque 4-5h) | day | week | month.
  final String rateKind;
  final double rate;
  final double periods;
  final double amount;
  final DateTime? deliveredAt;
  final DateTime? returnedAt;
  final String? conditionOut;
  final String? conditionIn;
  final String? notes;
  const RentalLine({
    required this.id,
    required this.updatedAt,
    this.deletedAt,
    required this.contractId,
    required this.assetId,
    required this.toolModelId,
    required this.rateKind,
    required this.rate,
    required this.periods,
    required this.amount,
    this.deliveredAt,
    this.returnedAt,
    this.conditionOut,
    this.conditionIn,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['contract_id'] = Variable<String>(contractId);
    map['asset_id'] = Variable<String>(assetId);
    map['tool_model_id'] = Variable<String>(toolModelId);
    map['rate_kind'] = Variable<String>(rateKind);
    map['rate'] = Variable<double>(rate);
    map['periods'] = Variable<double>(periods);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    if (!nullToAbsent || returnedAt != null) {
      map['returned_at'] = Variable<DateTime>(returnedAt);
    }
    if (!nullToAbsent || conditionOut != null) {
      map['condition_out'] = Variable<String>(conditionOut);
    }
    if (!nullToAbsent || conditionIn != null) {
      map['condition_in'] = Variable<String>(conditionIn);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  RentalLinesCompanion toCompanion(bool nullToAbsent) {
    return RentalLinesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      contractId: Value(contractId),
      assetId: Value(assetId),
      toolModelId: Value(toolModelId),
      rateKind: Value(rateKind),
      rate: Value(rate),
      periods: Value(periods),
      amount: Value(amount),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      returnedAt: returnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedAt),
      conditionOut: conditionOut == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionOut),
      conditionIn: conditionIn == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionIn),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory RentalLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RentalLine(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      contractId: serializer.fromJson<String>(json['contractId']),
      assetId: serializer.fromJson<String>(json['assetId']),
      toolModelId: serializer.fromJson<String>(json['toolModelId']),
      rateKind: serializer.fromJson<String>(json['rateKind']),
      rate: serializer.fromJson<double>(json['rate']),
      periods: serializer.fromJson<double>(json['periods']),
      amount: serializer.fromJson<double>(json['amount']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
      returnedAt: serializer.fromJson<DateTime?>(json['returnedAt']),
      conditionOut: serializer.fromJson<String?>(json['conditionOut']),
      conditionIn: serializer.fromJson<String?>(json['conditionIn']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'contractId': serializer.toJson<String>(contractId),
      'assetId': serializer.toJson<String>(assetId),
      'toolModelId': serializer.toJson<String>(toolModelId),
      'rateKind': serializer.toJson<String>(rateKind),
      'rate': serializer.toJson<double>(rate),
      'periods': serializer.toJson<double>(periods),
      'amount': serializer.toJson<double>(amount),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
      'returnedAt': serializer.toJson<DateTime?>(returnedAt),
      'conditionOut': serializer.toJson<String?>(conditionOut),
      'conditionIn': serializer.toJson<String?>(conditionIn),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  RentalLine copyWith({
    String? id,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? contractId,
    String? assetId,
    String? toolModelId,
    String? rateKind,
    double? rate,
    double? periods,
    double? amount,
    Value<DateTime?> deliveredAt = const Value.absent(),
    Value<DateTime?> returnedAt = const Value.absent(),
    Value<String?> conditionOut = const Value.absent(),
    Value<String?> conditionIn = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => RentalLine(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    contractId: contractId ?? this.contractId,
    assetId: assetId ?? this.assetId,
    toolModelId: toolModelId ?? this.toolModelId,
    rateKind: rateKind ?? this.rateKind,
    rate: rate ?? this.rate,
    periods: periods ?? this.periods,
    amount: amount ?? this.amount,
    deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
    returnedAt: returnedAt.present ? returnedAt.value : this.returnedAt,
    conditionOut: conditionOut.present ? conditionOut.value : this.conditionOut,
    conditionIn: conditionIn.present ? conditionIn.value : this.conditionIn,
    notes: notes.present ? notes.value : this.notes,
  );
  RentalLine copyWithCompanion(RentalLinesCompanion data) {
    return RentalLine(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      contractId: data.contractId.present
          ? data.contractId.value
          : this.contractId,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      toolModelId: data.toolModelId.present
          ? data.toolModelId.value
          : this.toolModelId,
      rateKind: data.rateKind.present ? data.rateKind.value : this.rateKind,
      rate: data.rate.present ? data.rate.value : this.rate,
      periods: data.periods.present ? data.periods.value : this.periods,
      amount: data.amount.present ? data.amount.value : this.amount,
      deliveredAt: data.deliveredAt.present
          ? data.deliveredAt.value
          : this.deliveredAt,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      conditionOut: data.conditionOut.present
          ? data.conditionOut.value
          : this.conditionOut,
      conditionIn: data.conditionIn.present
          ? data.conditionIn.value
          : this.conditionIn,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RentalLine(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('contractId: $contractId, ')
          ..write('assetId: $assetId, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('rateKind: $rateKind, ')
          ..write('rate: $rate, ')
          ..write('periods: $periods, ')
          ..write('amount: $amount, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('conditionOut: $conditionOut, ')
          ..write('conditionIn: $conditionIn, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deletedAt,
    contractId,
    assetId,
    toolModelId,
    rateKind,
    rate,
    periods,
    amount,
    deliveredAt,
    returnedAt,
    conditionOut,
    conditionIn,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RentalLine &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.contractId == this.contractId &&
          other.assetId == this.assetId &&
          other.toolModelId == this.toolModelId &&
          other.rateKind == this.rateKind &&
          other.rate == this.rate &&
          other.periods == this.periods &&
          other.amount == this.amount &&
          other.deliveredAt == this.deliveredAt &&
          other.returnedAt == this.returnedAt &&
          other.conditionOut == this.conditionOut &&
          other.conditionIn == this.conditionIn &&
          other.notes == this.notes);
}

class RentalLinesCompanion extends UpdateCompanion<RentalLine> {
  final Value<String> id;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> contractId;
  final Value<String> assetId;
  final Value<String> toolModelId;
  final Value<String> rateKind;
  final Value<double> rate;
  final Value<double> periods;
  final Value<double> amount;
  final Value<DateTime?> deliveredAt;
  final Value<DateTime?> returnedAt;
  final Value<String?> conditionOut;
  final Value<String?> conditionIn;
  final Value<String?> notes;
  final Value<int> rowid;
  const RentalLinesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.contractId = const Value.absent(),
    this.assetId = const Value.absent(),
    this.toolModelId = const Value.absent(),
    this.rateKind = const Value.absent(),
    this.rate = const Value.absent(),
    this.periods = const Value.absent(),
    this.amount = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.conditionOut = const Value.absent(),
    this.conditionIn = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RentalLinesCompanion.insert({
    required String id,
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String contractId,
    required String assetId,
    required String toolModelId,
    this.rateKind = const Value.absent(),
    this.rate = const Value.absent(),
    this.periods = const Value.absent(),
    this.amount = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.conditionOut = const Value.absent(),
    this.conditionIn = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contractId = Value(contractId),
       assetId = Value(assetId),
       toolModelId = Value(toolModelId);
  static Insertable<RentalLine> custom({
    Expression<String>? id,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? contractId,
    Expression<String>? assetId,
    Expression<String>? toolModelId,
    Expression<String>? rateKind,
    Expression<double>? rate,
    Expression<double>? periods,
    Expression<double>? amount,
    Expression<DateTime>? deliveredAt,
    Expression<DateTime>? returnedAt,
    Expression<String>? conditionOut,
    Expression<String>? conditionIn,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (contractId != null) 'contract_id': contractId,
      if (assetId != null) 'asset_id': assetId,
      if (toolModelId != null) 'tool_model_id': toolModelId,
      if (rateKind != null) 'rate_kind': rateKind,
      if (rate != null) 'rate': rate,
      if (periods != null) 'periods': periods,
      if (amount != null) 'amount': amount,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (conditionOut != null) 'condition_out': conditionOut,
      if (conditionIn != null) 'condition_in': conditionIn,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RentalLinesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? contractId,
    Value<String>? assetId,
    Value<String>? toolModelId,
    Value<String>? rateKind,
    Value<double>? rate,
    Value<double>? periods,
    Value<double>? amount,
    Value<DateTime?>? deliveredAt,
    Value<DateTime?>? returnedAt,
    Value<String?>? conditionOut,
    Value<String?>? conditionIn,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return RentalLinesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      contractId: contractId ?? this.contractId,
      assetId: assetId ?? this.assetId,
      toolModelId: toolModelId ?? this.toolModelId,
      rateKind: rateKind ?? this.rateKind,
      rate: rate ?? this.rate,
      periods: periods ?? this.periods,
      amount: amount ?? this.amount,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      returnedAt: returnedAt ?? this.returnedAt,
      conditionOut: conditionOut ?? this.conditionOut,
      conditionIn: conditionIn ?? this.conditionIn,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<String>(contractId.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (toolModelId.present) {
      map['tool_model_id'] = Variable<String>(toolModelId.value);
    }
    if (rateKind.present) {
      map['rate_kind'] = Variable<String>(rateKind.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (periods.present) {
      map['periods'] = Variable<double>(periods.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (conditionOut.present) {
      map['condition_out'] = Variable<String>(conditionOut.value);
    }
    if (conditionIn.present) {
      map['condition_in'] = Variable<String>(conditionIn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RentalLinesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('contractId: $contractId, ')
          ..write('assetId: $assetId, ')
          ..write('toolModelId: $toolModelId, ')
          ..write('rateKind: $rateKind, ')
          ..write('rate: $rate, ')
          ..write('periods: $periods, ')
          ..write('amount: $amount, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('conditionOut: $conditionOut, ')
          ..write('conditionIn: $conditionIn, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tableRefMeta = const VerificationMeta(
    'tableRef',
  );
  @override
  late final GeneratedColumn<String> tableRef = GeneratedColumn<String>(
    'table_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    tableRef,
    rowId,
    op,
    payload,
    queuedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('table_ref')) {
      context.handle(
        _tableRefMeta,
        tableRef.isAcceptableOrUnknown(data['table_ref']!, _tableRefMeta),
      );
    } else if (isInserting) {
      context.missing(_tableRefMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      tableRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_ref'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int seq;
  final String tableRef;
  final String rowId;
  final String op;
  final String payload;
  final DateTime queuedAt;
  const SyncQueueData({
    required this.seq,
    required this.tableRef,
    required this.rowId,
    required this.op,
    required this.payload,
    required this.queuedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['table_ref'] = Variable<String>(tableRef);
    map['row_id'] = Variable<String>(rowId);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      seq: Value(seq),
      tableRef: Value(tableRef),
      rowId: Value(rowId),
      op: Value(op),
      payload: Value(payload),
      queuedAt: Value(queuedAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      seq: serializer.fromJson<int>(json['seq']),
      tableRef: serializer.fromJson<String>(json['tableRef']),
      rowId: serializer.fromJson<String>(json['rowId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'tableRef': serializer.toJson<String>(tableRef),
      'rowId': serializer.toJson<String>(rowId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
    };
  }

  SyncQueueData copyWith({
    int? seq,
    String? tableRef,
    String? rowId,
    String? op,
    String? payload,
    DateTime? queuedAt,
  }) => SyncQueueData(
    seq: seq ?? this.seq,
    tableRef: tableRef ?? this.tableRef,
    rowId: rowId ?? this.rowId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    queuedAt: queuedAt ?? this.queuedAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      seq: data.seq.present ? data.seq.value : this.seq,
      tableRef: data.tableRef.present ? data.tableRef.value : this.tableRef,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('seq: $seq, ')
          ..write('tableRef: $tableRef, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('queuedAt: $queuedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seq, tableRef, rowId, op, payload, queuedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.seq == this.seq &&
          other.tableRef == this.tableRef &&
          other.rowId == this.rowId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.queuedAt == this.queuedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> seq;
  final Value<String> tableRef;
  final Value<String> rowId;
  final Value<String> op;
  final Value<String> payload;
  final Value<DateTime> queuedAt;
  const SyncQueueCompanion({
    this.seq = const Value.absent(),
    this.tableRef = const Value.absent(),
    this.rowId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.queuedAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.seq = const Value.absent(),
    required String tableRef,
    required String rowId,
    required String op,
    required String payload,
    this.queuedAt = const Value.absent(),
  }) : tableRef = Value(tableRef),
       rowId = Value(rowId),
       op = Value(op),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? seq,
    Expression<String>? tableRef,
    Expression<String>? rowId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<DateTime>? queuedAt,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (tableRef != null) 'table_ref': tableRef,
      if (rowId != null) 'row_id': rowId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (queuedAt != null) 'queued_at': queuedAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? seq,
    Value<String>? tableRef,
    Value<String>? rowId,
    Value<String>? op,
    Value<String>? payload,
    Value<DateTime>? queuedAt,
  }) {
    return SyncQueueCompanion(
      seq: seq ?? this.seq,
      tableRef: tableRef ?? this.tableRef,
      rowId: rowId ?? this.rowId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      queuedAt: queuedAt ?? this.queuedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (tableRef.present) {
      map['table_ref'] = Variable<String>(tableRef.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('seq: $seq, ')
          ..write('tableRef: $tableRef, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('queuedAt: $queuedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String key;
  final String value;
  const SyncStateData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(key: Value(key), value: Value(value));
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncStateData copyWith({String? key, String? value}) =>
      SyncStateData(key: key ?? this.key, value: value ?? this.value);
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncStateData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $CanonicalsTable canonicals = $CanonicalsTable(this);
  late final $ToolModelsTable toolModels = $ToolModelsTable(this);
  late final $CanonicalAttributesTable canonicalAttributes =
      $CanonicalAttributesTable(this);
  late final $ToolModelAttributesTable toolModelAttributes =
      $ToolModelAttributesTable(this);
  late final $ToolModelCategoriesTable toolModelCategories =
      $ToolModelCategoriesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $ConsumablesTable consumables = $ConsumablesTable(this);
  late final $ToolModelConsumablesTable toolModelConsumables =
      $ToolModelConsumablesTable(this);
  late final $InventoryMovementsTable inventoryMovements =
      $InventoryMovementsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $RentalContractsTable rentalContracts = $RentalContractsTable(
    this,
  );
  late final $RentalLinesTable rentalLines = $RentalLinesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    locations,
    suppliers,
    canonicals,
    toolModels,
    canonicalAttributes,
    toolModelAttributes,
    toolModelCategories,
    assets,
    consumables,
    toolModelConsumables,
    inventoryMovements,
    customers,
    rentalContracts,
    rentalLines,
    syncQueue,
    syncState,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> parentId,
      required String name,
      Value<int> level,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> parentId,
      Value<String> name,
      Value<int> level,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentId: parentId,
                name: name,
                level: level,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<int> level = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentId: parentId,
                name: name,
                level: level,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> parentId,
      required String name,
      Value<int> level,
      Value<int> rowid,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> parentId,
      Value<String> name,
      Value<int> level,
      Value<int> rowid,
    });

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          Location,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (Location, BaseReferences<_$AppDatabase, $LocationsTable, Location>),
          Location,
          PrefetchHooks Function()
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentId: parentId,
                name: name,
                level: level,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required String name,
                Value<int> level = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                parentId: parentId,
                name: name,
                level: level,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocationsTable, Location>(table),
                  BaseReferences<_$AppDatabase, $LocationsTable, Location>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      Location,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (Location, BaseReferences<_$AppDatabase, $LocationsTable, Location>),
      Location,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> ruc,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> ruc,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ruc =>
      $composableBuilder(column: $table.ruc, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
          Supplier,
          PrefetchHooks Function()
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> ruc = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                ruc: ruc,
                phone: phone,
                email: email,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> ruc = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                ruc: ruc,
                phone: phone,
                email: email,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SuppliersTable, Supplier>(table),
                  BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
      Supplier,
      PrefetchHooks Function()
    >;
typedef $$CanonicalsTableCreateCompanionBuilder =
    CanonicalsCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String code,
      required String name,
      Value<String?> iconPath,
      Value<String?> iconLocalPath,
      Value<DateTime?> iconUploadedAt,
      Value<int> rowid,
    });
typedef $$CanonicalsTableUpdateCompanionBuilder =
    CanonicalsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> code,
      Value<String> name,
      Value<String?> iconPath,
      Value<String?> iconLocalPath,
      Value<DateTime?> iconUploadedAt,
      Value<int> rowid,
    });

class $$CanonicalsTableFilterComposer
    extends Composer<_$AppDatabase, $CanonicalsTable> {
  $$CanonicalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconLocalPath => $composableBuilder(
    column: $table.iconLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get iconUploadedAt => $composableBuilder(
    column: $table.iconUploadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CanonicalsTableOrderingComposer
    extends Composer<_$AppDatabase, $CanonicalsTable> {
  $$CanonicalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconLocalPath => $composableBuilder(
    column: $table.iconLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get iconUploadedAt => $composableBuilder(
    column: $table.iconUploadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CanonicalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CanonicalsTable> {
  $$CanonicalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<String> get iconLocalPath => $composableBuilder(
    column: $table.iconLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get iconUploadedAt => $composableBuilder(
    column: $table.iconUploadedAt,
    builder: (column) => column,
  );
}

class $$CanonicalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CanonicalsTable,
          Canonical,
          $$CanonicalsTableFilterComposer,
          $$CanonicalsTableOrderingComposer,
          $$CanonicalsTableAnnotationComposer,
          $$CanonicalsTableCreateCompanionBuilder,
          $$CanonicalsTableUpdateCompanionBuilder,
          (
            Canonical,
            BaseReferences<_$AppDatabase, $CanonicalsTable, Canonical>,
          ),
          Canonical,
          PrefetchHooks Function()
        > {
  $$CanonicalsTableTableManager(_$AppDatabase db, $CanonicalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CanonicalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CanonicalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CanonicalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<String?> iconLocalPath = const Value.absent(),
                Value<DateTime?> iconUploadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanonicalsCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                code: code,
                name: name,
                iconPath: iconPath,
                iconLocalPath: iconLocalPath,
                iconUploadedAt: iconUploadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String code,
                required String name,
                Value<String?> iconPath = const Value.absent(),
                Value<String?> iconLocalPath = const Value.absent(),
                Value<DateTime?> iconUploadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanonicalsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                code: code,
                name: name,
                iconPath: iconPath,
                iconLocalPath: iconLocalPath,
                iconUploadedAt: iconUploadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CanonicalsTable, Canonical>(table),
                  BaseReferences<_$AppDatabase, $CanonicalsTable, Canonical>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CanonicalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CanonicalsTable,
      Canonical,
      $$CanonicalsTableFilterComposer,
      $$CanonicalsTableOrderingComposer,
      $$CanonicalsTableAnnotationComposer,
      $$CanonicalsTableCreateCompanionBuilder,
      $$CanonicalsTableUpdateCompanionBuilder,
      (Canonical, BaseReferences<_$AppDatabase, $CanonicalsTable, Canonical>),
      Canonical,
      PrefetchHooks Function()
    >;
typedef $$ToolModelsTableCreateCompanionBuilder =
    ToolModelsCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> spec,
      Value<String> line,
      Value<String?> brand,
      Value<String?> supplierCode,
      Value<String?> description,
      Value<String?> categoryId,
      Value<double> listCost,
      Value<double?> rateHalfDay,
      Value<double?> rateDay,
      Value<double?> rateWeek,
      Value<double?> rateMonth,
      Value<double> b87Qty,
      Value<bool> published,
      Value<String?> photoPath,
      Value<String?> notes,
      Value<String?> ratCode,
      Value<String?> canonicalCode,
      Value<String?> canonicalName,
      Value<String?> variant,
      Value<String?> supplierId,
      Value<int> rowid,
    });
typedef $$ToolModelsTableUpdateCompanionBuilder =
    ToolModelsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> spec,
      Value<String> line,
      Value<String?> brand,
      Value<String?> supplierCode,
      Value<String?> description,
      Value<String?> categoryId,
      Value<double> listCost,
      Value<double?> rateHalfDay,
      Value<double?> rateDay,
      Value<double?> rateWeek,
      Value<double?> rateMonth,
      Value<double> b87Qty,
      Value<bool> published,
      Value<String?> photoPath,
      Value<String?> notes,
      Value<String?> ratCode,
      Value<String?> canonicalCode,
      Value<String?> canonicalName,
      Value<String?> variant,
      Value<String?> supplierId,
      Value<int> rowid,
    });

class $$ToolModelsTableFilterComposer
    extends Composer<_$AppDatabase, $ToolModelsTable> {
  $$ToolModelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spec => $composableBuilder(
    column: $table.spec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get line => $composableBuilder(
    column: $table.line,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierCode => $composableBuilder(
    column: $table.supplierCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get listCost => $composableBuilder(
    column: $table.listCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rateHalfDay => $composableBuilder(
    column: $table.rateHalfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rateDay => $composableBuilder(
    column: $table.rateDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rateWeek => $composableBuilder(
    column: $table.rateWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rateMonth => $composableBuilder(
    column: $table.rateMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get b87Qty => $composableBuilder(
    column: $table.b87Qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ratCode => $composableBuilder(
    column: $table.ratCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalName => $composableBuilder(
    column: $table.canonicalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ToolModelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ToolModelsTable> {
  $$ToolModelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spec => $composableBuilder(
    column: $table.spec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get line => $composableBuilder(
    column: $table.line,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierCode => $composableBuilder(
    column: $table.supplierCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get listCost => $composableBuilder(
    column: $table.listCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rateHalfDay => $composableBuilder(
    column: $table.rateHalfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rateDay => $composableBuilder(
    column: $table.rateDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rateWeek => $composableBuilder(
    column: $table.rateWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rateMonth => $composableBuilder(
    column: $table.rateMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get b87Qty => $composableBuilder(
    column: $table.b87Qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get published => $composableBuilder(
    column: $table.published,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ratCode => $composableBuilder(
    column: $table.ratCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalName => $composableBuilder(
    column: $table.canonicalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variant => $composableBuilder(
    column: $table.variant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ToolModelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToolModelsTable> {
  $$ToolModelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get spec =>
      $composableBuilder(column: $table.spec, builder: (column) => column);

  GeneratedColumn<String> get line =>
      $composableBuilder(column: $table.line, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get supplierCode => $composableBuilder(
    column: $table.supplierCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get listCost =>
      $composableBuilder(column: $table.listCost, builder: (column) => column);

  GeneratedColumn<double> get rateHalfDay => $composableBuilder(
    column: $table.rateHalfDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rateDay =>
      $composableBuilder(column: $table.rateDay, builder: (column) => column);

  GeneratedColumn<double> get rateWeek =>
      $composableBuilder(column: $table.rateWeek, builder: (column) => column);

  GeneratedColumn<double> get rateMonth =>
      $composableBuilder(column: $table.rateMonth, builder: (column) => column);

  GeneratedColumn<double> get b87Qty =>
      $composableBuilder(column: $table.b87Qty, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get ratCode =>
      $composableBuilder(column: $table.ratCode, builder: (column) => column);

  GeneratedColumn<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonicalName => $composableBuilder(
    column: $table.canonicalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variant =>
      $composableBuilder(column: $table.variant, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );
}

class $$ToolModelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToolModelsTable,
          ToolModel,
          $$ToolModelsTableFilterComposer,
          $$ToolModelsTableOrderingComposer,
          $$ToolModelsTableAnnotationComposer,
          $$ToolModelsTableCreateCompanionBuilder,
          $$ToolModelsTableUpdateCompanionBuilder,
          (
            ToolModel,
            BaseReferences<_$AppDatabase, $ToolModelsTable, ToolModel>,
          ),
          ToolModel,
          PrefetchHooks Function()
        > {
  $$ToolModelsTableTableManager(_$AppDatabase db, $ToolModelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToolModelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToolModelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ToolModelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> spec = const Value.absent(),
                Value<String> line = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> supplierCode = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<double> listCost = const Value.absent(),
                Value<double?> rateHalfDay = const Value.absent(),
                Value<double?> rateDay = const Value.absent(),
                Value<double?> rateWeek = const Value.absent(),
                Value<double?> rateMonth = const Value.absent(),
                Value<double> b87Qty = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> ratCode = const Value.absent(),
                Value<String?> canonicalCode = const Value.absent(),
                Value<String?> canonicalName = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolModelsCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                spec: spec,
                line: line,
                brand: brand,
                supplierCode: supplierCode,
                description: description,
                categoryId: categoryId,
                listCost: listCost,
                rateHalfDay: rateHalfDay,
                rateDay: rateDay,
                rateWeek: rateWeek,
                rateMonth: rateMonth,
                b87Qty: b87Qty,
                published: published,
                photoPath: photoPath,
                notes: notes,
                ratCode: ratCode,
                canonicalCode: canonicalCode,
                canonicalName: canonicalName,
                variant: variant,
                supplierId: supplierId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> spec = const Value.absent(),
                Value<String> line = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> supplierCode = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<double> listCost = const Value.absent(),
                Value<double?> rateHalfDay = const Value.absent(),
                Value<double?> rateDay = const Value.absent(),
                Value<double?> rateWeek = const Value.absent(),
                Value<double?> rateMonth = const Value.absent(),
                Value<double> b87Qty = const Value.absent(),
                Value<bool> published = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> ratCode = const Value.absent(),
                Value<String?> canonicalCode = const Value.absent(),
                Value<String?> canonicalName = const Value.absent(),
                Value<String?> variant = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolModelsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                spec: spec,
                line: line,
                brand: brand,
                supplierCode: supplierCode,
                description: description,
                categoryId: categoryId,
                listCost: listCost,
                rateHalfDay: rateHalfDay,
                rateDay: rateDay,
                rateWeek: rateWeek,
                rateMonth: rateMonth,
                b87Qty: b87Qty,
                published: published,
                photoPath: photoPath,
                notes: notes,
                ratCode: ratCode,
                canonicalCode: canonicalCode,
                canonicalName: canonicalName,
                variant: variant,
                supplierId: supplierId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToolModelsTable, ToolModel>(table),
                  BaseReferences<_$AppDatabase, $ToolModelsTable, ToolModel>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ToolModelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToolModelsTable,
      ToolModel,
      $$ToolModelsTableFilterComposer,
      $$ToolModelsTableOrderingComposer,
      $$ToolModelsTableAnnotationComposer,
      $$ToolModelsTableCreateCompanionBuilder,
      $$ToolModelsTableUpdateCompanionBuilder,
      (ToolModel, BaseReferences<_$AppDatabase, $ToolModelsTable, ToolModel>),
      ToolModel,
      PrefetchHooks Function()
    >;
typedef $$CanonicalAttributesTableCreateCompanionBuilder =
    CanonicalAttributesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String canonicalCode,
      required String name,
      Value<int> position,
      Value<int> rowid,
    });
typedef $$CanonicalAttributesTableUpdateCompanionBuilder =
    CanonicalAttributesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> canonicalCode,
      Value<String> name,
      Value<int> position,
      Value<int> rowid,
    });

class $$CanonicalAttributesTableFilterComposer
    extends Composer<_$AppDatabase, $CanonicalAttributesTable> {
  $$CanonicalAttributesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CanonicalAttributesTableOrderingComposer
    extends Composer<_$AppDatabase, $CanonicalAttributesTable> {
  $$CanonicalAttributesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CanonicalAttributesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CanonicalAttributesTable> {
  $$CanonicalAttributesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CanonicalAttributesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CanonicalAttributesTable,
          CanonicalAttribute,
          $$CanonicalAttributesTableFilterComposer,
          $$CanonicalAttributesTableOrderingComposer,
          $$CanonicalAttributesTableAnnotationComposer,
          $$CanonicalAttributesTableCreateCompanionBuilder,
          $$CanonicalAttributesTableUpdateCompanionBuilder,
          (
            CanonicalAttribute,
            BaseReferences<
              _$AppDatabase,
              $CanonicalAttributesTable,
              CanonicalAttribute
            >,
          ),
          CanonicalAttribute,
          PrefetchHooks Function()
        > {
  $$CanonicalAttributesTableTableManager(
    _$AppDatabase db,
    $CanonicalAttributesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CanonicalAttributesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CanonicalAttributesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CanonicalAttributesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> canonicalCode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanonicalAttributesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                canonicalCode: canonicalCode,
                name: name,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String canonicalCode,
                required String name,
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanonicalAttributesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                canonicalCode: canonicalCode,
                name: name,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CanonicalAttributesTable, CanonicalAttribute>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CanonicalAttributesTable,
                    CanonicalAttribute
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CanonicalAttributesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CanonicalAttributesTable,
      CanonicalAttribute,
      $$CanonicalAttributesTableFilterComposer,
      $$CanonicalAttributesTableOrderingComposer,
      $$CanonicalAttributesTableAnnotationComposer,
      $$CanonicalAttributesTableCreateCompanionBuilder,
      $$CanonicalAttributesTableUpdateCompanionBuilder,
      (
        CanonicalAttribute,
        BaseReferences<
          _$AppDatabase,
          $CanonicalAttributesTable,
          CanonicalAttribute
        >,
      ),
      CanonicalAttribute,
      PrefetchHooks Function()
    >;
typedef $$ToolModelAttributesTableCreateCompanionBuilder =
    ToolModelAttributesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String toolModelId,
      required String name,
      required String value,
      Value<int> position,
      Value<int> rowid,
    });
typedef $$ToolModelAttributesTableUpdateCompanionBuilder =
    ToolModelAttributesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> toolModelId,
      Value<String> name,
      Value<String> value,
      Value<int> position,
      Value<int> rowid,
    });

class $$ToolModelAttributesTableFilterComposer
    extends Composer<_$AppDatabase, $ToolModelAttributesTable> {
  $$ToolModelAttributesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ToolModelAttributesTableOrderingComposer
    extends Composer<_$AppDatabase, $ToolModelAttributesTable> {
  $$ToolModelAttributesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ToolModelAttributesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToolModelAttributesTable> {
  $$ToolModelAttributesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$ToolModelAttributesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToolModelAttributesTable,
          ToolModelAttribute,
          $$ToolModelAttributesTableFilterComposer,
          $$ToolModelAttributesTableOrderingComposer,
          $$ToolModelAttributesTableAnnotationComposer,
          $$ToolModelAttributesTableCreateCompanionBuilder,
          $$ToolModelAttributesTableUpdateCompanionBuilder,
          (
            ToolModelAttribute,
            BaseReferences<
              _$AppDatabase,
              $ToolModelAttributesTable,
              ToolModelAttribute
            >,
          ),
          ToolModelAttribute,
          PrefetchHooks Function()
        > {
  $$ToolModelAttributesTableTableManager(
    _$AppDatabase db,
    $ToolModelAttributesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToolModelAttributesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToolModelAttributesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ToolModelAttributesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> toolModelId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolModelAttributesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                name: name,
                value: value,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String toolModelId,
                required String name,
                required String value,
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolModelAttributesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                name: name,
                value: value,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToolModelAttributesTable, ToolModelAttribute>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ToolModelAttributesTable,
                    ToolModelAttribute
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ToolModelAttributesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToolModelAttributesTable,
      ToolModelAttribute,
      $$ToolModelAttributesTableFilterComposer,
      $$ToolModelAttributesTableOrderingComposer,
      $$ToolModelAttributesTableAnnotationComposer,
      $$ToolModelAttributesTableCreateCompanionBuilder,
      $$ToolModelAttributesTableUpdateCompanionBuilder,
      (
        ToolModelAttribute,
        BaseReferences<
          _$AppDatabase,
          $ToolModelAttributesTable,
          ToolModelAttribute
        >,
      ),
      ToolModelAttribute,
      PrefetchHooks Function()
    >;
typedef $$ToolModelCategoriesTableCreateCompanionBuilder =
    ToolModelCategoriesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String toolModelId,
      required String categoryId,
      Value<int> rowid,
    });
typedef $$ToolModelCategoriesTableUpdateCompanionBuilder =
    ToolModelCategoriesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> toolModelId,
      Value<String> categoryId,
      Value<int> rowid,
    });

class $$ToolModelCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ToolModelCategoriesTable> {
  $$ToolModelCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ToolModelCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ToolModelCategoriesTable> {
  $$ToolModelCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ToolModelCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToolModelCategoriesTable> {
  $$ToolModelCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );
}

class $$ToolModelCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToolModelCategoriesTable,
          ToolModelCategory,
          $$ToolModelCategoriesTableFilterComposer,
          $$ToolModelCategoriesTableOrderingComposer,
          $$ToolModelCategoriesTableAnnotationComposer,
          $$ToolModelCategoriesTableCreateCompanionBuilder,
          $$ToolModelCategoriesTableUpdateCompanionBuilder,
          (
            ToolModelCategory,
            BaseReferences<
              _$AppDatabase,
              $ToolModelCategoriesTable,
              ToolModelCategory
            >,
          ),
          ToolModelCategory,
          PrefetchHooks Function()
        > {
  $$ToolModelCategoriesTableTableManager(
    _$AppDatabase db,
    $ToolModelCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToolModelCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToolModelCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ToolModelCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> toolModelId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolModelCategoriesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String toolModelId,
                required String categoryId,
                Value<int> rowid = const Value.absent(),
              }) => ToolModelCategoriesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToolModelCategoriesTable, ToolModelCategory>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ToolModelCategoriesTable,
                    ToolModelCategory
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ToolModelCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToolModelCategoriesTable,
      ToolModelCategory,
      $$ToolModelCategoriesTableFilterComposer,
      $$ToolModelCategoriesTableOrderingComposer,
      $$ToolModelCategoriesTableAnnotationComposer,
      $$ToolModelCategoriesTableCreateCompanionBuilder,
      $$ToolModelCategoriesTableUpdateCompanionBuilder,
      (
        ToolModelCategory,
        BaseReferences<
          _$AppDatabase,
          $ToolModelCategoriesTable,
          ToolModelCategory
        >,
      ),
      ToolModelCategory,
      PrefetchHooks Function()
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String toolModelId,
      required String assetTag,
      Value<String?> serial,
      Value<String> status,
      Value<String> condition,
      Value<String?> locationId,
      Value<DateTime?> purchaseDate,
      Value<double> purchaseCost,
      Value<String?> notes,
      Value<String?> supplierId,
      Value<String?> invoiceNumber,
      Value<String?> brand,
      Value<String?> mfrModel,
      Value<String?> datasheetUrl,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> toolModelId,
      Value<String> assetTag,
      Value<String?> serial,
      Value<String> status,
      Value<String> condition,
      Value<String?> locationId,
      Value<DateTime?> purchaseDate,
      Value<double> purchaseCost,
      Value<String?> notes,
      Value<String?> supplierId,
      Value<String?> invoiceNumber,
      Value<String?> brand,
      Value<String?> mfrModel,
      Value<String?> datasheetUrl,
      Value<int> rowid,
    });

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTag => $composableBuilder(
    column: $table.assetTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchaseCost => $composableBuilder(
    column: $table.purchaseCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mfrModel => $composableBuilder(
    column: $table.mfrModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetUrl => $composableBuilder(
    column: $table.datasheetUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTag => $composableBuilder(
    column: $table.assetTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchaseCost => $composableBuilder(
    column: $table.purchaseCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mfrModel => $composableBuilder(
    column: $table.mfrModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetUrl => $composableBuilder(
    column: $table.datasheetUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetTag =>
      $composableBuilder(column: $table.assetTag, builder: (column) => column);

  GeneratedColumn<String> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchaseCost => $composableBuilder(
    column: $table.purchaseCost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get mfrModel =>
      $composableBuilder(column: $table.mfrModel, builder: (column) => column);

  GeneratedColumn<String> get datasheetUrl => $composableBuilder(
    column: $table.datasheetUrl,
    builder: (column) => column,
  );
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          Asset,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
          Asset,
          PrefetchHooks Function()
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> toolModelId = const Value.absent(),
                Value<String> assetTag = const Value.absent(),
                Value<String?> serial = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double> purchaseCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> mfrModel = const Value.absent(),
                Value<String?> datasheetUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                assetTag: assetTag,
                serial: serial,
                status: status,
                condition: condition,
                locationId: locationId,
                purchaseDate: purchaseDate,
                purchaseCost: purchaseCost,
                notes: notes,
                supplierId: supplierId,
                invoiceNumber: invoiceNumber,
                brand: brand,
                mfrModel: mfrModel,
                datasheetUrl: datasheetUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String toolModelId,
                required String assetTag,
                Value<String?> serial = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<double> purchaseCost = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> mfrModel = const Value.absent(),
                Value<String?> datasheetUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                assetTag: assetTag,
                serial: serial,
                status: status,
                condition: condition,
                locationId: locationId,
                purchaseDate: purchaseDate,
                purchaseCost: purchaseCost,
                notes: notes,
                supplierId: supplierId,
                invoiceNumber: invoiceNumber,
                brand: brand,
                mfrModel: mfrModel,
                datasheetUrl: datasheetUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssetsTable, Asset>(table),
                  BaseReferences<_$AppDatabase, $AssetsTable, Asset>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      Asset,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
      Asset,
      PrefetchHooks Function()
    >;
typedef $$ConsumablesTableCreateCompanionBuilder =
    ConsumablesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> code,
      required String name,
      Value<String> unit,
      Value<double> cost,
      Value<double> salePrice,
      Value<double> stock,
      Value<double> minStock,
      Value<String?> locationId,
      Value<String?> canonicalCode,
      Value<String?> supplierId,
      Value<int> rowid,
    });
typedef $$ConsumablesTableUpdateCompanionBuilder =
    ConsumablesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> code,
      Value<String> name,
      Value<String> unit,
      Value<double> cost,
      Value<double> salePrice,
      Value<double> stock,
      Value<double> minStock,
      Value<String?> locationId,
      Value<String?> canonicalCode,
      Value<String?> supplierId,
      Value<int> rowid,
    });

class $$ConsumablesTableFilterComposer
    extends Composer<_$AppDatabase, $ConsumablesTable> {
  $$ConsumablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConsumablesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsumablesTable> {
  $$ConsumablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConsumablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsumablesTable> {
  $$ConsumablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<double> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<double> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonicalCode => $composableBuilder(
    column: $table.canonicalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );
}

class $$ConsumablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsumablesTable,
          Consumable,
          $$ConsumablesTableFilterComposer,
          $$ConsumablesTableOrderingComposer,
          $$ConsumablesTableAnnotationComposer,
          $$ConsumablesTableCreateCompanionBuilder,
          $$ConsumablesTableUpdateCompanionBuilder,
          (
            Consumable,
            BaseReferences<_$AppDatabase, $ConsumablesTable, Consumable>,
          ),
          Consumable,
          PrefetchHooks Function()
        > {
  $$ConsumablesTableTableManager(_$AppDatabase db, $ConsumablesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsumablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsumablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsumablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<double> stock = const Value.absent(),
                Value<double> minStock = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> canonicalCode = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsumablesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                code: code,
                name: name,
                unit: unit,
                cost: cost,
                salePrice: salePrice,
                stock: stock,
                minStock: minStock,
                locationId: locationId,
                canonicalCode: canonicalCode,
                supplierId: supplierId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> code = const Value.absent(),
                required String name,
                Value<String> unit = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<double> stock = const Value.absent(),
                Value<double> minStock = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String?> canonicalCode = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsumablesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                code: code,
                name: name,
                unit: unit,
                cost: cost,
                salePrice: salePrice,
                stock: stock,
                minStock: minStock,
                locationId: locationId,
                canonicalCode: canonicalCode,
                supplierId: supplierId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConsumablesTable, Consumable>(table),
                  BaseReferences<_$AppDatabase, $ConsumablesTable, Consumable>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsumablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsumablesTable,
      Consumable,
      $$ConsumablesTableFilterComposer,
      $$ConsumablesTableOrderingComposer,
      $$ConsumablesTableAnnotationComposer,
      $$ConsumablesTableCreateCompanionBuilder,
      $$ConsumablesTableUpdateCompanionBuilder,
      (
        Consumable,
        BaseReferences<_$AppDatabase, $ConsumablesTable, Consumable>,
      ),
      Consumable,
      PrefetchHooks Function()
    >;
typedef $$ToolModelConsumablesTableCreateCompanionBuilder =
    ToolModelConsumablesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String toolModelId,
      required String consumableId,
      Value<int> rowid,
    });
typedef $$ToolModelConsumablesTableUpdateCompanionBuilder =
    ToolModelConsumablesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> toolModelId,
      Value<String> consumableId,
      Value<int> rowid,
    });

class $$ToolModelConsumablesTableFilterComposer
    extends Composer<_$AppDatabase, $ToolModelConsumablesTable> {
  $$ToolModelConsumablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consumableId => $composableBuilder(
    column: $table.consumableId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ToolModelConsumablesTableOrderingComposer
    extends Composer<_$AppDatabase, $ToolModelConsumablesTable> {
  $$ToolModelConsumablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consumableId => $composableBuilder(
    column: $table.consumableId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ToolModelConsumablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ToolModelConsumablesTable> {
  $$ToolModelConsumablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get consumableId => $composableBuilder(
    column: $table.consumableId,
    builder: (column) => column,
  );
}

class $$ToolModelConsumablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ToolModelConsumablesTable,
          ToolModelConsumable,
          $$ToolModelConsumablesTableFilterComposer,
          $$ToolModelConsumablesTableOrderingComposer,
          $$ToolModelConsumablesTableAnnotationComposer,
          $$ToolModelConsumablesTableCreateCompanionBuilder,
          $$ToolModelConsumablesTableUpdateCompanionBuilder,
          (
            ToolModelConsumable,
            BaseReferences<
              _$AppDatabase,
              $ToolModelConsumablesTable,
              ToolModelConsumable
            >,
          ),
          ToolModelConsumable,
          PrefetchHooks Function()
        > {
  $$ToolModelConsumablesTableTableManager(
    _$AppDatabase db,
    $ToolModelConsumablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ToolModelConsumablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ToolModelConsumablesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ToolModelConsumablesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> toolModelId = const Value.absent(),
                Value<String> consumableId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ToolModelConsumablesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                consumableId: consumableId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String toolModelId,
                required String consumableId,
                Value<int> rowid = const Value.absent(),
              }) => ToolModelConsumablesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                toolModelId: toolModelId,
                consumableId: consumableId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ToolModelConsumablesTable, ToolModelConsumable>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ToolModelConsumablesTable,
                    ToolModelConsumable
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ToolModelConsumablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ToolModelConsumablesTable,
      ToolModelConsumable,
      $$ToolModelConsumablesTableFilterComposer,
      $$ToolModelConsumablesTableOrderingComposer,
      $$ToolModelConsumablesTableAnnotationComposer,
      $$ToolModelConsumablesTableCreateCompanionBuilder,
      $$ToolModelConsumablesTableUpdateCompanionBuilder,
      (
        ToolModelConsumable,
        BaseReferences<
          _$AppDatabase,
          $ToolModelConsumablesTable,
          ToolModelConsumable
        >,
      ),
      ToolModelConsumable,
      PrefetchHooks Function()
    >;
typedef $$InventoryMovementsTableCreateCompanionBuilder =
    InventoryMovementsCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> assetId,
      Value<String?> consumableId,
      required String kind,
      Value<double> quantity,
      Value<String?> fromLocationId,
      Value<String?> toLocationId,
      Value<String?> contractRef,
      required DateTime movedAt,
      Value<String?> createdBy,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$InventoryMovementsTableUpdateCompanionBuilder =
    InventoryMovementsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String?> assetId,
      Value<String?> consumableId,
      Value<String> kind,
      Value<double> quantity,
      Value<String?> fromLocationId,
      Value<String?> toLocationId,
      Value<String?> contractRef,
      Value<DateTime> movedAt,
      Value<String?> createdBy,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$InventoryMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consumableId => $composableBuilder(
    column: $table.consumableId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromLocationId => $composableBuilder(
    column: $table.fromLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toLocationId => $composableBuilder(
    column: $table.toLocationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractRef => $composableBuilder(
    column: $table.contractRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get movedAt => $composableBuilder(
    column: $table.movedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consumableId => $composableBuilder(
    column: $table.consumableId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromLocationId => $composableBuilder(
    column: $table.fromLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toLocationId => $composableBuilder(
    column: $table.toLocationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractRef => $composableBuilder(
    column: $table.contractRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get movedAt => $composableBuilder(
    column: $table.movedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get consumableId => $composableBuilder(
    column: $table.consumableId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get fromLocationId => $composableBuilder(
    column: $table.fromLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toLocationId => $composableBuilder(
    column: $table.toLocationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contractRef => $composableBuilder(
    column: $table.contractRef,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get movedAt =>
      $composableBuilder(column: $table.movedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$InventoryMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryMovementsTable,
          InventoryMovement,
          $$InventoryMovementsTableFilterComposer,
          $$InventoryMovementsTableOrderingComposer,
          $$InventoryMovementsTableAnnotationComposer,
          $$InventoryMovementsTableCreateCompanionBuilder,
          $$InventoryMovementsTableUpdateCompanionBuilder,
          (
            InventoryMovement,
            BaseReferences<
              _$AppDatabase,
              $InventoryMovementsTable,
              InventoryMovement
            >,
          ),
          InventoryMovement,
          PrefetchHooks Function()
        > {
  $$InventoryMovementsTableTableManager(
    _$AppDatabase db,
    $InventoryMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryMovementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<String?> consumableId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> fromLocationId = const Value.absent(),
                Value<String?> toLocationId = const Value.absent(),
                Value<String?> contractRef = const Value.absent(),
                Value<DateTime> movedAt = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryMovementsCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                assetId: assetId,
                consumableId: consumableId,
                kind: kind,
                quantity: quantity,
                fromLocationId: fromLocationId,
                toLocationId: toLocationId,
                contractRef: contractRef,
                movedAt: movedAt,
                createdBy: createdBy,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> assetId = const Value.absent(),
                Value<String?> consumableId = const Value.absent(),
                required String kind,
                Value<double> quantity = const Value.absent(),
                Value<String?> fromLocationId = const Value.absent(),
                Value<String?> toLocationId = const Value.absent(),
                Value<String?> contractRef = const Value.absent(),
                required DateTime movedAt,
                Value<String?> createdBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryMovementsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                assetId: assetId,
                consumableId: consumableId,
                kind: kind,
                quantity: quantity,
                fromLocationId: fromLocationId,
                toLocationId: toLocationId,
                contractRef: contractRef,
                movedAt: movedAt,
                createdBy: createdBy,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InventoryMovementsTable, InventoryMovement>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InventoryMovementsTable,
                    InventoryMovement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryMovementsTable,
      InventoryMovement,
      $$InventoryMovementsTableFilterComposer,
      $$InventoryMovementsTableOrderingComposer,
      $$InventoryMovementsTableAnnotationComposer,
      $$InventoryMovementsTableCreateCompanionBuilder,
      $$InventoryMovementsTableUpdateCompanionBuilder,
      (
        InventoryMovement,
        BaseReferences<
          _$AppDatabase,
          $InventoryMovementsTable,
          InventoryMovement
        >,
      ),
      InventoryMovement,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> idNumber,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> idNumber,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idNumber => $composableBuilder(
    column: $table.idNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get idNumber =>
      $composableBuilder(column: $table.idNumber, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> idNumber = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                idNumber: idNumber,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> idNumber = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                idNumber: idNumber,
                phone: phone,
                email: email,
                address: address,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, Customer>(table),
                  BaseReferences<_$AppDatabase, $CustomersTable, Customer>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$RentalContractsTableCreateCompanionBuilder =
    RentalContractsCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String contractNumber,
      required String customerId,
      Value<String> status,
      Value<DateTime?> startAt,
      Value<DateTime?> dueAt,
      Value<DateTime?> returnedAt,
      Value<double> deposit,
      Value<String?> notes,
      Value<String?> createdBy,
      Value<int> rowid,
    });
typedef $$RentalContractsTableUpdateCompanionBuilder =
    RentalContractsCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> contractNumber,
      Value<String> customerId,
      Value<String> status,
      Value<DateTime?> startAt,
      Value<DateTime?> dueAt,
      Value<DateTime?> returnedAt,
      Value<double> deposit,
      Value<String?> notes,
      Value<String?> createdBy,
      Value<int> rowid,
    });

class $$RentalContractsTableFilterComposer
    extends Composer<_$AppDatabase, $RentalContractsTable> {
  $$RentalContractsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractNumber => $composableBuilder(
    column: $table.contractNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RentalContractsTableOrderingComposer
    extends Composer<_$AppDatabase, $RentalContractsTable> {
  $$RentalContractsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractNumber => $composableBuilder(
    column: $table.contractNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RentalContractsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RentalContractsTable> {
  $$RentalContractsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get contractNumber => $composableBuilder(
    column: $table.contractNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);
}

class $$RentalContractsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RentalContractsTable,
          RentalContract,
          $$RentalContractsTableFilterComposer,
          $$RentalContractsTableOrderingComposer,
          $$RentalContractsTableAnnotationComposer,
          $$RentalContractsTableCreateCompanionBuilder,
          $$RentalContractsTableUpdateCompanionBuilder,
          (
            RentalContract,
            BaseReferences<
              _$AppDatabase,
              $RentalContractsTable,
              RentalContract
            >,
          ),
          RentalContract,
          PrefetchHooks Function()
        > {
  $$RentalContractsTableTableManager(
    _$AppDatabase db,
    $RentalContractsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RentalContractsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RentalContractsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RentalContractsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> contractNumber = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<double> deposit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RentalContractsCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                contractNumber: contractNumber,
                customerId: customerId,
                status: status,
                startAt: startAt,
                dueAt: dueAt,
                returnedAt: returnedAt,
                deposit: deposit,
                notes: notes,
                createdBy: createdBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String contractNumber,
                required String customerId,
                Value<String> status = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<double> deposit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RentalContractsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                contractNumber: contractNumber,
                customerId: customerId,
                status: status,
                startAt: startAt,
                dueAt: dueAt,
                returnedAt: returnedAt,
                deposit: deposit,
                notes: notes,
                createdBy: createdBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RentalContractsTable, RentalContract>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RentalContractsTable,
                    RentalContract
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RentalContractsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RentalContractsTable,
      RentalContract,
      $$RentalContractsTableFilterComposer,
      $$RentalContractsTableOrderingComposer,
      $$RentalContractsTableAnnotationComposer,
      $$RentalContractsTableCreateCompanionBuilder,
      $$RentalContractsTableUpdateCompanionBuilder,
      (
        RentalContract,
        BaseReferences<_$AppDatabase, $RentalContractsTable, RentalContract>,
      ),
      RentalContract,
      PrefetchHooks Function()
    >;
typedef $$RentalLinesTableCreateCompanionBuilder =
    RentalLinesCompanion Function({
      required String id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String contractId,
      required String assetId,
      required String toolModelId,
      Value<String> rateKind,
      Value<double> rate,
      Value<double> periods,
      Value<double> amount,
      Value<DateTime?> deliveredAt,
      Value<DateTime?> returnedAt,
      Value<String?> conditionOut,
      Value<String?> conditionIn,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$RentalLinesTableUpdateCompanionBuilder =
    RentalLinesCompanion Function({
      Value<String> id,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> contractId,
      Value<String> assetId,
      Value<String> toolModelId,
      Value<String> rateKind,
      Value<double> rate,
      Value<double> periods,
      Value<double> amount,
      Value<DateTime?> deliveredAt,
      Value<DateTime?> returnedAt,
      Value<String?> conditionOut,
      Value<String?> conditionIn,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$RentalLinesTableFilterComposer
    extends Composer<_$AppDatabase, $RentalLinesTable> {
  $$RentalLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractId => $composableBuilder(
    column: $table.contractId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rateKind => $composableBuilder(
    column: $table.rateKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get periods => $composableBuilder(
    column: $table.periods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionOut => $composableBuilder(
    column: $table.conditionOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionIn => $composableBuilder(
    column: $table.conditionIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RentalLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RentalLinesTable> {
  $$RentalLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractId => $composableBuilder(
    column: $table.contractId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateKind => $composableBuilder(
    column: $table.rateKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get periods => $composableBuilder(
    column: $table.periods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionOut => $composableBuilder(
    column: $table.conditionOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionIn => $composableBuilder(
    column: $table.conditionIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RentalLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RentalLinesTable> {
  $$RentalLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get contractId => $composableBuilder(
    column: $table.contractId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get toolModelId => $composableBuilder(
    column: $table.toolModelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rateKind =>
      $composableBuilder(column: $table.rateKind, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<double> get periods =>
      $composableBuilder(column: $table.periods, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionOut => $composableBuilder(
    column: $table.conditionOut,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conditionIn => $composableBuilder(
    column: $table.conditionIn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$RentalLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RentalLinesTable,
          RentalLine,
          $$RentalLinesTableFilterComposer,
          $$RentalLinesTableOrderingComposer,
          $$RentalLinesTableAnnotationComposer,
          $$RentalLinesTableCreateCompanionBuilder,
          $$RentalLinesTableUpdateCompanionBuilder,
          (
            RentalLine,
            BaseReferences<_$AppDatabase, $RentalLinesTable, RentalLine>,
          ),
          RentalLine,
          PrefetchHooks Function()
        > {
  $$RentalLinesTableTableManager(_$AppDatabase db, $RentalLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RentalLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RentalLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RentalLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> contractId = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<String> toolModelId = const Value.absent(),
                Value<String> rateKind = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> periods = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<String?> conditionOut = const Value.absent(),
                Value<String?> conditionIn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RentalLinesCompanion(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                contractId: contractId,
                assetId: assetId,
                toolModelId: toolModelId,
                rateKind: rateKind,
                rate: rate,
                periods: periods,
                amount: amount,
                deliveredAt: deliveredAt,
                returnedAt: returnedAt,
                conditionOut: conditionOut,
                conditionIn: conditionIn,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String contractId,
                required String assetId,
                required String toolModelId,
                Value<String> rateKind = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<double> periods = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<String?> conditionOut = const Value.absent(),
                Value<String?> conditionIn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RentalLinesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                contractId: contractId,
                assetId: assetId,
                toolModelId: toolModelId,
                rateKind: rateKind,
                rate: rate,
                periods: periods,
                amount: amount,
                deliveredAt: deliveredAt,
                returnedAt: returnedAt,
                conditionOut: conditionOut,
                conditionIn: conditionIn,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RentalLinesTable, RentalLine>(table),
                  BaseReferences<_$AppDatabase, $RentalLinesTable, RentalLine>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RentalLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RentalLinesTable,
      RentalLine,
      $$RentalLinesTableFilterComposer,
      $$RentalLinesTableOrderingComposer,
      $$RentalLinesTableAnnotationComposer,
      $$RentalLinesTableCreateCompanionBuilder,
      $$RentalLinesTableUpdateCompanionBuilder,
      (
        RentalLine,
        BaseReferences<_$AppDatabase, $RentalLinesTable, RentalLine>,
      ),
      RentalLine,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> seq,
      required String tableRef,
      required String rowId,
      required String op,
      required String payload,
      Value<DateTime> queuedAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> seq,
      Value<String> tableRef,
      Value<String> rowId,
      Value<String> op,
      Value<String> payload,
      Value<DateTime> queuedAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableRef => $composableBuilder(
    column: $table.tableRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableRef => $composableBuilder(
    column: $table.tableRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get tableRef =>
      $composableBuilder(column: $table.tableRef, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> tableRef = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
              }) => SyncQueueCompanion(
                seq: seq,
                tableRef: tableRef,
                rowId: rowId,
                op: op,
                payload: payload,
                queuedAt: queuedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String tableRef,
                required String rowId,
                required String op,
                required String payload,
                Value<DateTime> queuedAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                seq: seq,
                tableRef: tableRef,
                rowId: rowId,
                op: op,
                payload: payload,
                queuedAt: queuedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueData>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncStateData>(table),
                  BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$CanonicalsTableTableManager get canonicals =>
      $$CanonicalsTableTableManager(_db, _db.canonicals);
  $$ToolModelsTableTableManager get toolModels =>
      $$ToolModelsTableTableManager(_db, _db.toolModels);
  $$CanonicalAttributesTableTableManager get canonicalAttributes =>
      $$CanonicalAttributesTableTableManager(_db, _db.canonicalAttributes);
  $$ToolModelAttributesTableTableManager get toolModelAttributes =>
      $$ToolModelAttributesTableTableManager(_db, _db.toolModelAttributes);
  $$ToolModelCategoriesTableTableManager get toolModelCategories =>
      $$ToolModelCategoriesTableTableManager(_db, _db.toolModelCategories);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$ConsumablesTableTableManager get consumables =>
      $$ConsumablesTableTableManager(_db, _db.consumables);
  $$ToolModelConsumablesTableTableManager get toolModelConsumables =>
      $$ToolModelConsumablesTableTableManager(_db, _db.toolModelConsumables);
  $$InventoryMovementsTableTableManager get inventoryMovements =>
      $$InventoryMovementsTableTableManager(_db, _db.inventoryMovements);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$RentalContractsTableTableManager get rentalContracts =>
      $$RentalContractsTableTableManager(_db, _db.rentalContracts);
  $$RentalLinesTableTableManager get rentalLines =>
      $$RentalLinesTableTableManager(_db, _db.rentalLines);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}

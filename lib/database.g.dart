// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorGardenDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$GardenDatabaseBuilder databaseBuilder(String name) =>
      _$GardenDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$GardenDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$GardenDatabaseBuilder(null);
}

class _$GardenDatabaseBuilder {
  _$GardenDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$GardenDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$GardenDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<GardenDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$GardenDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$GardenDatabase extends GardenDatabase {
  _$GardenDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PlantTypeDao? _plantTypeDaoInstance;

  PlantDao? _plantDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PlantType` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Plant` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `plant_type` INTEGER NOT NULL, `planted_date` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PlantTypeDao get plantTypeDao {
    return _plantTypeDaoInstance ??= _$PlantTypeDao(database, changeListener);
  }

  @override
  PlantDao get plantDao {
    return _plantDaoInstance ??= _$PlantDao(database, changeListener);
  }
}

class _$PlantTypeDao extends PlantTypeDao {
  _$PlantTypeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _plantTypeInsertionAdapter = InsertionAdapter(
            database,
            'PlantType',
            (PlantType item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PlantType> _plantTypeInsertionAdapter;

  @override
  Future<List<PlantType>> findAllPlantTypes() async {
    return _queryAdapter.queryList('SELECT * FROM PlantType',
        mapper: (Map<String, Object?> row) =>
            PlantType(row['id'] as int, row['name'] as String));
  }

  @override
  Future<PlantType?> findPlantTypeById(int id) async {
    return _queryAdapter.query('SELECT * FROM PlantType WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            PlantType(row['id'] as int, row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertPlantType(PlantType plantType) async {
    await _plantTypeInsertionAdapter.insert(
        plantType, OnConflictStrategy.abort);
  }
}

class _$PlantDao extends PlantDao {
  _$PlantDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _plantInsertionAdapter = InsertionAdapter(
            database,
            'Plant',
            (Plant item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'plant_type': item.plant_type,
                  'planted_date': item.planted_date
                }),
        _plantUpdateAdapter = UpdateAdapter(
            database,
            'Plant',
            ['id'],
            (Plant item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'plant_type': item.plant_type,
                  'planted_date': item.planted_date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Plant> _plantInsertionAdapter;

  final UpdateAdapter<Plant> _plantUpdateAdapter;

  @override
  Future<List<Plant>> findAllPlants() async {
    return _queryAdapter.queryList('SELECT * FROM Plant',
        mapper: (Map<String, Object?> row) => Plant(
            row['id'] as int?,
            row['plant_type'] as int,
            row['name'] as String,
            row['planted_date'] as int));
  }

  @override
  Future<Plant?> findPlantById(int id) async {
    return _queryAdapter.query('SELECT * FROM Plant WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Plant(
            row['id'] as int?,
            row['plant_type'] as int,
            row['name'] as String,
            row['planted_date'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Plant>> findAllPlantsByName(String nameFilter) async {
    return _queryAdapter.queryList('SELECT * FROM Plant WHERE name LIKE ?1',
        mapper: (Map<String, Object?> row) => Plant(
            row['id'] as int?,
            row['plant_type'] as int,
            row['name'] as String,
            row['planted_date'] as int),
        arguments: [nameFilter]);
  }

  @override
  Future<void> insertPlant(Plant plant) async {
    await _plantInsertionAdapter.insert(plant, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePlant(Plant plant) async {
    await _plantUpdateAdapter.update(plant, OnConflictStrategy.replace);
  }
}

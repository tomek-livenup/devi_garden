
// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/plant_type_dao.dart';
import 'dao/plant_dao.dart';
import 'entity/plant_type.dart';
import 'entity/plant.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [PlantType, Plant])
abstract class GardenDatabase extends FloorDatabase {
  PlantTypeDao get plantTypeDao;
  PlantDao get plantDao;
}

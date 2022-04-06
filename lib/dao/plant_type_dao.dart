import 'package:floor/floor.dart';

import "package:devi_garden/entity/plant_type.dart";

@dao
abstract class PlantTypeDao {
  @Query('SELECT * FROM PlantType')
  Future<List<PlantType>> findAllPlantTypes();

  @Query('SELECT * FROM PlantType WHERE id = :id')
  Future<PlantType?> findPlantTypeById(int id);

  @insert
  Future<void> insertPlantType(PlantType plantType);
}

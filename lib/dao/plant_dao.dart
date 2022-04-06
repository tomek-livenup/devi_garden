import 'package:floor/floor.dart';

import "package:devi_garden/entity/plant.dart";

@dao
abstract class PlantDao {
  @Query('SELECT * FROM Plant')
  Future<List<Plant>> findAllPlants();

  @Query('SELECT * FROM Plant WHERE id = :id')
  Future<Plant?> findPlantById(int id);

  @Query('SELECT * FROM Plant WHERE name LIKE :nameFilter')
  Future<List<Plant>> findAllPlantsByName(String nameFilter);

  @insert
  Future<void> insertPlant(Plant plant);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePlant(Plant plant);
}

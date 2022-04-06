import "package:devi_garden/entity/plant.dart";
import "package:devi_garden/database.dart";
import "package:devi_garden/cubits/plant_types.dart";
import "package:devi_garden/cubits/plants.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

loadPlantTypes(context) async {
  BlocProvider.of<PlantTypesCubit>(context).loading();
  final database =
      await $FloorGardenDatabase.databaseBuilder('garden_database.db').build();
  final planTypes = await database.plantTypeDao.findAllPlantTypes();
  BlocProvider.of<PlantTypesCubit>(context).success(planTypes);
}

addOrUpdatePlant(context, Plant plant) async {
  final database =
      await $FloorGardenDatabase.databaseBuilder('garden_database.db').build();
  final plantDao = database.plantDao;
  if (plant.id == null) {
    plantDao.insertPlant(plant);
  } else {
    plantDao.updatePlant(plant);
  }
}

loadPlants(context, {String? nameFilter}) async {
  BlocProvider.of<PlantsCubit>(context).loading();
  final database =
      await $FloorGardenDatabase.databaseBuilder('garden_database.db').build();
  print(nameFilter);
  final plants = nameFilter is String
      ? await database.plantDao.findAllPlantsByName(nameFilter)
      : await database.plantDao.findAllPlants();
  BlocProvider.of<PlantsCubit>(context).success(plants);
}

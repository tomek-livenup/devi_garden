import 'package:floor/floor.dart';

@entity
class PlantType{
  @primaryKey
  final int id;

  final String name;

  PlantType(this.id, this.name);
}

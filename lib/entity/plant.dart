import 'package:floor/floor.dart';

@entity
class Plant{
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final int plant_type;
  final int planted_date;

  Plant(this.id, this.plant_type, this.name, this.planted_date);
}

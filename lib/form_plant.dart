import 'package:flutter/material.dart';
import "package:devi_garden/entity/plant_type.dart";
import "package:devi_garden/entity/plant.dart";
import "package:devi_garden/database_helpers.dart";
import "package:devi_garden/cubits/plant_types.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
// import 'package:collection/collection.dart';

class PlantForm extends StatefulWidget {
  PlantForm({Key? key, Plant? this.plant}) : super(key: key);

  Plant? plant;

  @override
  PlantFormState createState() {
    return PlantFormState();
  }
}

class PlantFormState extends State<PlantForm> {
  final _formKey = GlobalKey<FormState>();
  final formTitle = 'Add/Edit Plant';

  String name = '';
  DateTime selectedDate = DateTime.now();
  int plantTypeId = 1;

  @override
  initState() {
    super.initState();
    if (widget.plant is Plant) {
      name = widget.plant?.name ?? name;
      plantTypeId = widget.plant?.plant_type ?? plantTypeId;
      selectedDate = widget.plant?.planted_date is int
          ? DateTime.fromMicrosecondsSinceEpoch(widget.plant?.planted_date ?? 0)
          : DateTime.now();
    } else {
      name = '';
      selectedDate = DateTime.now();
      plantTypeId = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPlantTypes(context);

    return Form(
      key: _formKey,
      child: Center(
        child: Column(children: <Widget>[
          Text(formTitle),
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(hintText: "Set Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (newValue) {
              name = newValue;
            },
          ),
          BlocConsumer<PlantTypesCubit, PlantTypesState>(
            listener: (BuildContext context, PlantTypesState state) {},
            builder: (BuildContext context, PlantTypesState state) {
              List<PlantType?> plantTypes = [];
              if (state is PlantTypesLoadedState) {
                plantTypes = state.props[0];
                // plantTypeId = 1;
              }
              return DropdownButtonFormField(
                value: plantTypeId,
                decoration: const InputDecoration(hintText: "Set Plant Type"),
                items: (plantTypes
                    .map<DropdownMenuItem>(
                      (choice) => DropdownMenuItem(
                        value: choice?.id,
                        child: Text(choice?.name ?? ''),
                      ),
                    )
                    .toList()),
                onChanged: (newValue) {
                  if (newValue is int) {
                    plantTypeId = newValue;
                  }
                },
              );
            },
          ),
          DateTimePicker(
            dateMask: 'dd/MM/yyyy',
            dateLabelText: 'Planted on',
            firstDate: DateTime(2000),
            lastDate: DateTime(2023),
            initialValue: selectedDate.toString(),
            onChanged: (date) {
              setState(() {
                selectedDate = DateTime.parse(date);
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                if (plantTypeId is int) {
                  int plantTypeId2 = plantTypeId;
                  print(_formKey.currentState);
                  print(selectedDate);
                  Plant plant = Plant(widget.plant?.id, plantTypeId2, name,
                      selectedDate.microsecondsSinceEpoch);
                  await addOrUpdatePlant(context, plant);
                  loadPlants(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:devi_garden/entity/plant_type.dart";
import "package:devi_garden/entity/plant.dart";
import "package:devi_garden/database.dart";
import "package:devi_garden/database_helpers.dart";
import "package:devi_garden/form_plant.dart";
import "package:devi_garden/cubits/plant_types.dart";
import "package:devi_garden/cubits/plants.dart";
import 'package:intl/intl.dart';
import 'dart:math';

var database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database =
      await $FloorGardenDatabase.databaseBuilder('garden_database.db').build();
  final plantTypeDao = database.plantTypeDao;
  final result = await plantTypeDao.findPlantTypeById(1);
  if (result is PlantType) {
    // print('Database is not empty');
    // final result = await database.plantTypeDao.findAllPlantTypes();
    // print(result);
  } else {
    const plantTypes = [
      'alpines',
      'aquatic',
      'bulbs',
      'succulents',
      'carnivorous',
      'climbers',
      'ferns',
      'grasses',
      'threes'
    ];
    plantTypes.asMap().forEach((index, plantType) {
      plantTypeDao.insertPlantType(PlantType(index + 1, plantType));
    });
  }

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final database;

  const MyApp(this.database);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlantTypesCubit>(
          create: (BuildContext context) => PlantTypesCubit(),
        ),
        BlocProvider<PlantsCubit>(
          create: (BuildContext context) => PlantsCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Garden',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Garden'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Pagination {
  static int getPagesNumber({required List items, required int limit}) {
    return (items.length / limit).round();
  }

  static List getPageItems(
      {required List items, required int page, required int limit}) {
    return items.sublist((page - 1) * limit, min(page * limit, items.length));
  }

  static bool hasNext(
      {required List items, required int page, required int limit}) {
    return items.length >= page;
  }

  static bool hasPrev(
      {required List items, required int page, required int limit}) {
    return page > 1;
  }

  static String getPagesStatus(
      {required List items, required int page, required int limit}) {
    return items.isNotEmpty
        ? "${((page - 1) * limit) + 1} to ${min(page * limit, items.length)} from ${items.length}"
        : "0";
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  int _page = 1;
  int _limit = 10;

  @override
  void initState() {
    super.initState();

    // TextEditingController.addListener(_printLatestValue);
  }

  @override
  Widget build(BuildContext context) {
    loadPlants(context);
    loadPlantTypes(context);

    return BlocConsumer<PlantsCubit, PlantsState>(
      listener: (BuildContext context, PlantsState state) {},
      builder: (BuildContext context, PlantsState state) {
        var items;
        String pagesStatus = '';
        if (state.props.isNotEmpty && state is PlantsLoadedState) {
          items = state.props[0];
          items = items.reversed.toList();
          pagesStatus = Pagination.getPagesStatus(
              items: items, page: _page, limit: _limit);
          items =
              Pagination.getPageItems(items: items, page: _page, limit: _limit);
        } else {
          items = null;
          pagesStatus = '';
        }

        var dateFormat = DateFormat('dd/MM/yyyy');

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title + "     (${pagesStatus})"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: true,
                    child: TextField(
                      controller: editingController,
                      onChanged: (value) async {
                        await loadPlants(context, nameFilter: "%$value%");
                        setState(() async {
                          _page = 1;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: state is PlantsLoadingState,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 50.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Visibility(
                            visible: state is PlantsLoadedState,
                            child: items != null && items.length > 0
                                ? ListView.builder(
                                    itemCount: items.length,
                                    shrinkWrap: true,
                                    // padding: EdgeInsets.all(15.0),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String name = items[index].name;
                                      String leading = name.substring(0, 1) +
                                          (name.length > 1
                                              ? name.substring(
                                                  name.length - 1, name.length)
                                              : '');
                                      ListTile tile = ListTile(
                                        shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                        ),
                                        leading: Text(
                                          leading,
                                          style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.green,
                                          ),
                                        ),
                                        title: TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                            textStyle: MaterialStateProperty
                                                .all<TextStyle>(
                                              const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          child: Text("${items[index].name}"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FormPage(
                                                    plant: items[index]),
                                              ),
                                            );
                                          },
                                        ),
                                        subtitle: Center(
                                          child: BlocConsumer<PlantTypesCubit,
                                                  PlantTypesState>(
                                              listener: (BuildContext context,
                                                  PlantTypesState state) {},
                                              builder: (BuildContext context,
                                                  PlantTypesState state) {
                                                List plantTypes = [];
                                                if (state
                                                    is PlantTypesLoadedState) {
                                                  plantTypes = state.props[0];
                                                  PlantType plantType =
                                                      plantTypes
                                                          .where((plantType) =>
                                                              plantType.id ==
                                                              items[index]
                                                                  .plant_type)
                                                          .toList()[0];
                                                  return Row(children: [
                                                    const Icon(
                                                      IconData(0xe1b6,
                                                          fontFamily:
                                                              'MaterialIcons'),
                                                    ),
                                                    Text(
                                                      dateFormat.format(
                                                        DateTime
                                                            .fromMicrosecondsSinceEpoch(
                                                                items[index]
                                                                    .planted_date),
                                                      ),
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const Text(' '),
                                                    const Icon(
                                                      IconData(0xf6f2,
                                                          fontFamily:
                                                              'MaterialIcons'),
                                                    ),
                                                    Text(
                                                      plantType.name,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ]);
                                                } else {
                                                  return const Text('');
                                                }
                                              }),
                                        ),
                                        // trailing: const Text(''),
                                      );
                                      return tile;
                                    },
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(36.0),
                                    child: Text(
                                      'Nothing to show.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormPage(plant: null),
                            ),
                          );
                        },
                        child: const Text('+ Add plant'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            if (Pagination.hasPrev(
                              items: items,
                              page: _page,
                              limit: _limit,
                            )) {
                              _page = _page - 1;
                            }
                          });
                        },
                        child: const Text('Prev page'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            if (Pagination.hasNext(
                              items: items,
                              page: _page,
                              limit: _limit,
                            )) {
                              _page = _page + 1;
                            }
                          });
                        },
                        child: const Text('Next page'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FormPage extends StatefulWidget {
  FormPage({Key? key, this.title = '', Plant? this.plant}) : super(key: key);

  String title;
  Plant? plant;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    widget.title = widget.plant is Plant ? 'Update plant' : 'Add plant';
    loadPlants(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[PlantForm(plant: widget.plant)],
          ),
        ),
      ),
    );
  }
}

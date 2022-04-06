import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlantTypesState extends Equatable {
  PlantTypesState();
}

class PlantTypesInitialState extends PlantTypesState {
  @override
  List<Object> get props => [];
}

class PlantTypesLoadingState extends PlantTypesState {
  @override
  List<Object> get props => [];
}

class PlantTypesLoadedState extends PlantTypesState {
  List data;
  PlantTypesLoadedState(this.data);

  @override
  // List<Object> get props => [data];
  List get props => [data];
}

class PlantTypesErrorState extends PlantTypesState {
  final List<Object> errors;
  PlantTypesErrorState(this.errors);

  @override
  List<Object> get props => errors;
}

class PlantTypesCubit extends Cubit<PlantTypesState> {
  PlantTypesCubit() : super(PlantTypesInitialState());

  void loading() => emit(PlantTypesInitialState());
  void success(data) => emit(PlantTypesLoadedState(data));
  void errors(errors) => emit(PlantTypesErrorState(errors));
}

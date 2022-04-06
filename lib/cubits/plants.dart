import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlantsState extends Equatable {
  PlantsState();
}

class PlantsInitialState extends PlantsState {
  @override
  List<Object> get props => [];
}

class PlantsLoadingState extends PlantsState {
  @override
  List<Object> get props => [];
}

class PlantsLoadedState extends PlantsState {
  List data;
  PlantsLoadedState(this.data);

  @override
  // List<Object> get props => [data];
  List get props => [data];
}

class PlantsErrorState extends PlantsState {
  final List<Object> errors;
  PlantsErrorState(this.errors);

  @override
  List<Object> get props => errors;
}

class PlantsCubit extends Cubit<PlantsState> {
  PlantsCubit() : super(PlantsInitialState());

  void loading() => emit(PlantsInitialState());
  void success(data) => emit(PlantsLoadedState(data));
  void errors(errors) => emit(PlantsErrorState(errors));
}

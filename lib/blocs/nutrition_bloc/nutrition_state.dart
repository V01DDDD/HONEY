import 'package:equatable/equatable.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionLoaded extends NutritionState {
  final List foods;

  const NutritionLoaded(this.foods);

  @override
  List<Object> get props => [foods];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object> get props => [message];
}

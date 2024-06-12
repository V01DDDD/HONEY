import 'package:equatable/equatable.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object> get props => [];
}

class SearchNutrition extends NutritionEvent {
  final String query;

  const SearchNutrition(this.query);

  @override
  List<Object> get props => [query];
}

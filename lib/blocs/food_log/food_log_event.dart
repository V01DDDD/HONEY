import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class AddFood extends FoodEvent {
  final String name;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double sugar;
  final String mealType;

  const AddFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.sugar,
    required this.mealType,
  });

  @override
  List<Object> get props => [name, calories, protein, carbohydrates, fat, sugar, mealType];
}

class DeleteFood extends FoodEvent {
  final int index;

  const DeleteFood(this.index);

  @override
  List<Object> get props => [index];
}

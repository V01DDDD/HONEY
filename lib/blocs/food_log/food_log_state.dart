import 'package:equatable/equatable.dart';

class FoodState extends Equatable {
  final List<FoodItem> foodItems;

  const FoodState({required this.foodItems});

  @override
  List<Object> get props => [foodItems];
}

class FoodItem extends Equatable {
  final String name;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double sugar;
  final String mealType; // Add meal type

  const FoodItem({
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

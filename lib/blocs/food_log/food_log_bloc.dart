import 'package:firebase_auth_youtube/blocs/food_log/food_log_event.dart';
import 'package:firebase_auth_youtube/blocs/food_log/food_log_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodLogBloc extends Bloc<FoodEvent, FoodState> {
  FoodLogBloc() : super(const FoodState(foodItems: [])) {
    on<AddFood>((event, emit) {
      final newFoodItem = FoodItem(
        name: event.name,
        calories: event.calories,
        protein: event.protein,
        carbohydrates: event.carbohydrates,
        fat: event.fat,
        sugar: event.sugar,
        mealType: event.mealType,
      );

      final updatedFoodItems = List<FoodItem>.from(state.foodItems)..add(newFoodItem);

      emit(FoodState(foodItems: updatedFoodItems));
    });

    on<DeleteFood>((event, emit) {
      final updatedFoodItems = List<FoodItem>.from(state.foodItems)..removeAt(event.index);
      emit(FoodState(foodItems: updatedFoodItems));
    });
  }
}
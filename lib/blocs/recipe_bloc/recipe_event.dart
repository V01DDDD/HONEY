import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class FetchRecipes extends RecipeEvent {
  final int number;
  final String includeTags;
  final String excludeTags;

  const FetchRecipes({this.number = 3, this.includeTags = '', this.excludeTags = ''});

  @override
  List<Object> get props => [number, includeTags, excludeTags];
}

class RefreshRecipes extends RecipeEvent {}

class FetchRecipeDetails extends RecipeEvent {
  final String recipeId;

  const FetchRecipeDetails(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

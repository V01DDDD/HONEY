import 'package:equatable/equatable.dart';
import 'package:firebase_auth_youtube/models/recipe_model.dart';


abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoadInProgress extends RecipeState {}

class RecipeLoadSuccess extends RecipeState {
  final List<Recipe> recipes;

  const RecipeLoadSuccess(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeLoadFailure extends RecipeState {
  final String error;

  const RecipeLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class RecipeDetailsLoadInProgress extends RecipeState {}

class RecipeDetailsLoadSuccess extends RecipeState {
  final Recipe recipe;

  const RecipeDetailsLoadSuccess(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RecipeDetailsLoadFailure extends RecipeState {
  final String error;

  const RecipeDetailsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

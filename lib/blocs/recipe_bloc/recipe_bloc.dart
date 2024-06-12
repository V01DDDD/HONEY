import 'package:bloc/bloc.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/api_service.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final SpoonacularService apiService;

  RecipeBloc({required this.apiService}) : super(RecipeInitial()) {
    on<FetchRecipes>((event, emit) async {
      emit(RecipeLoadInProgress());
      try {
        final recipes = await apiService.fetchRandomRecipes(
          number: event.number,
          includeTags: event.includeTags.isNotEmpty ? event.includeTags : '',
          excludeTags: event.excludeTags.isNotEmpty ? event.excludeTags : '',
        );
        emit(RecipeLoadSuccess(recipes));
      } catch (e) {
        emit(RecipeLoadFailure(e.toString()));
      }
    });

    on<RefreshRecipes>((event, emit) async {
      try {
        final recipes = await apiService.fetchRandomRecipes();
        emit(RecipeLoadSuccess(recipes));
      } catch (e) {
        emit(RecipeLoadFailure(e.toString()));
      }
    });

    on<FetchRecipeDetails>((event, emit) async {
      emit(RecipeDetailsLoadInProgress());
      try {
          final recipe = await apiService.fetchRecipeDetails(event.recipeId);
          final nutrition = await apiService.fetchRecipeNutrition(event.recipeId);
          final ingredients = await apiService.fetchRecipeIngredients(event.recipeId);
          emit(RecipeDetailsLoadSuccess(
            recipe.copyWith(
              calories: nutrition.calories,
              protein: nutrition.protein,
              fat: nutrition.fat,
              carbohydrates: nutrition.carbohydrates,
              sugar: nutrition.sugar,
              ingredients: ingredients.map((ingredient) => '${ingredient.amount} ${ingredient.unit} ${ingredient.name}').toList(),
            ),
          ));
      } catch (e) {
          emit(RecipeDetailsLoadFailure(e.toString()));
      }
    });
  }
}

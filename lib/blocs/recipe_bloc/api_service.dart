import 'dart:convert';
import 'package:firebase_auth_youtube/const/api_keys.dart';
import 'package:firebase_auth_youtube/models/ingredient_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth_youtube/models/recipe_model.dart';

class SpoonacularService {
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  String buildQueryString(Map<String, String?> params) {
  return params.entries
      .where((entry) => entry.value != null && entry.value!.isNotEmpty)
      .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value!)}')
      .join('&');
}

Future<List<Recipe>> fetchRandomRecipes({int number = 4, String includeTags = '', String excludeTags = ''}) async {
    final String queryString = buildQueryString({
      'number': number.toString(),
      'tags': includeTags,
      'excludeIngredients': excludeTags,
      'apiKey': ApiKeys.spoonacularApiKey,
    });

    final String url = '$_baseUrl/random?$queryString';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> recipesData = data['recipes'];
      if (recipesData.isEmpty) {
        throw Exception('No recipes found');
      }
      final List<Recipe> recipes = recipesData.map((recipeData) => Recipe.fromJson(recipeData)).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Recipe> fetchRecipeDetails(String recipeId) async {
    final String url = '$_baseUrl/$recipeId/information?includeNutrition=true&apiKey=${ApiKeys.spoonacularApiKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  Future<List<Ingredient>> fetchRecipeIngredients(String recipeId) async {
    final String url = '$_baseUrl/$recipeId/ingredientWidget.json?apiKey=${ApiKeys.spoonacularApiKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> ingredientsData = data['ingredients'];
        if (ingredientsData.isEmpty) {
            throw Exception('No ingredients found');
        }
        final List<Ingredient> ingredients = ingredientsData.map((ingredientData) => Ingredient.fromJson(ingredientData)).toList();
        return ingredients;
    } else {
        throw Exception('Failed to load ingredients');
    }
}

  Future<Recipe> fetchRecipeNutrition(String recipeId) async {
    final String url = '$_baseUrl/$recipeId/nutritionWidget.json?apiKey=${ApiKeys.spoonacularApiKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Failed to load nutrition data');
    }
  }
}

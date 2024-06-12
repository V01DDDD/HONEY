import 'dart:math';

import 'package:firebase_auth_youtube/blocs/recipe_bloc/api_service.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/recipe_event.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/recipe_state.dart';
import 'package:firebase_auth_youtube/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const RecipePage());
}

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => RecipeBloc(apiService: SpoonacularService()),
        child: const RecipeListPage(),
      ),
    );
  }
}

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipes',
          style: TextStyle(
            color: Color.fromARGB(255, 39, 122, 4)
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeInitial) {
            context.read<RecipeBloc>().add(const FetchRecipes(number: 4));
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RecipeBloc>().add(RefreshRecipes());
              },
              child: ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];
                  return RecipeCard(recipe: recipe);
                },
              ),
            );
          } else if (state is RecipeLoadFailure) {
            return Center(child: Text('Failed to load recipes: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int starRating;

  RecipeCard({Key? key, required this.recipe})
      : starRating = Random().nextInt(3) + 3,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(recipeId: recipe.id.toString()),
          ));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 140,
                height: 140,
                child: CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < starRating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final String recipeId;

  const RecipeDetailsPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(apiService: SpoonacularService())..add(FetchRecipeDetails(recipeId)),
      child: Scaffold(
        body: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeDetailsLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeDetailsLoadSuccess) {
              final recipe = state.recipe;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0, // Reduced height
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30.0), // Smooth edges all around
                          ),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30.0), // Smooth edges all around
                          ),
                          child: CachedNetworkImage(
                            imageUrl: recipe.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < 4 ? Icons.star : Icons.star_border,
                                color: Colors.yellow,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nutritional Information:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNutritionalInfo('Calories', '${recipe.calories} kcal'),
                              const VerticalDivider(color: Colors.green),
                              _buildNutritionalInfo('Protein', '${recipe.protein} g'),
                              const VerticalDivider(color: Colors.green),
                              _buildNutritionalInfo('Fat', '${recipe.fat} g'),
                              const VerticalDivider(color: Colors.green),
                              _buildNutritionalInfo('Carbs', '${recipe.carbohydrates} g'),
                              const VerticalDivider(color: Colors.green),
                              _buildNutritionalInfo('Sugar', '${recipe.sugar} g'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '\nIngredients:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...recipe.ingredients.map((ingredient) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              ingredient,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )).toList(),
                          const SizedBox(height: 16),
                          const Text(
                            '\nInstructions:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            recipe.instructions,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is RecipeDetailsLoadFailure) {
              return Center(child: Text('Failed to load recipe details: ${state.error}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildNutritionalInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

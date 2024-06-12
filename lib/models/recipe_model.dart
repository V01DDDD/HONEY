class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final String calories;
  final String protein;
  final String fat;
  final String carbohydrates;
  final String sugar;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.sugar,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? imageUrl,
    List<String>? ingredients,
    String? instructions,
    String? calories,
    String? protein,
    String? fat,
    String? carbohydrates,
    String? sugar,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      sugar: sugar ?? this.sugar,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final nutrients = json['nutrients'] as List<dynamic>?; // Changed to nullable
    return Recipe(
      id: json['id']?.toString() ?? 'Unknown',
      title: json['title'] ?? 'Unknown',
      imageUrl: json['image'] ?? '',
      ingredients: (json['extendedIngredients'] as List<dynamic>?)
          ?.map((ingredient) => ingredient['originalString'] as String?)
          .where((ingredient) => ingredient != null)
          .map((ingredient) => ingredient!)
          .toList() ?? [],
      instructions: json['instructions'] ?? 'No instructions provided',
      calories: nutrients?.firstWhere((n) => n['name'] == 'Calories')['amount'].toString() ?? '0', // Added null check
      protein: nutrients?.firstWhere((n) => n['name'] == 'Protein')['amount'].toString() ?? '0', // Added null check
      fat: nutrients?.firstWhere((n) => n['name'] == 'Fat')['amount'].toString() ?? '0', // Added null check
      carbohydrates: nutrients?.firstWhere((n) => n['name'] == 'Carbohydrates')['amount'].toString() ?? '0', // Added null check
      sugar: nutrients?.firstWhere((n) => n['name'] == 'Sugar')['amount'].toString() ?? '0', // Added null check
    );
  }
}

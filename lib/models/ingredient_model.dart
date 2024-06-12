class Ingredient {
  final String name;
  final double amount;
  final String unit;
  final String image;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? 'Unknown',
      amount: (json['amount']['metric']['value'] as num).toDouble(),
      unit: json['amount']['metric']['unit'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

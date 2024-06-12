// ignore_for_file: unused_local_variable

class TdeeCalculator {
  final int weight;
  final int height;
  final int age;
  final String gender;
  final double bodyFatPercentage;

  TdeeCalculator({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.bodyFatPercentage,
  });

  double calculateBMR() {
    // Katch-McArdle formula for BMR
    return 370 + (21.6 * (weight * (1 - (bodyFatPercentage / 100))));
  }

  Map<String, double> calculateTDEE() {
    final bmr = calculateBMR();
    return {
      'Basal Metabolic Rate': bmr,
      'Sedentary': bmr * 1.2,
      'Light Exercise': bmr * 1.375,
      'Moderate Exercise': bmr * 1.55,
      'Heavy Exercise': bmr * 1.725,
      'Athlete': bmr * 1.9,
    };
  }

  
  double calculateBMI() {
    return weight / ((height / 100) * (height / 100));
  }

  String classifyBMI(double bmi) {
    if ( weight / ((height / 100) * (height / 100)) <= 18.5) {
      return 'Underweight';
    } else if (weight / ((height / 100) * (height / 100)) <= 24.99) {
      return 'Normal Weight';
    } else if (weight / ((height / 100) * (height / 100)) <= 29.99) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Map<String, double> calculateIdealWeight() {
  const double maleHamwiWeightConstant = 50.0;
  const double femaleHamwiWeightConstant = 45.5;
  const double devineWeightConstant = 50.0;
  const double maleRobinsonWeightConstant = 52.0;
  const double femaleRobinsonWeightConstant = 49.0;
  const double maleMillerWeightConstant = 56.2;
  const double femaleMillerWeightConstant = 53.1;

  if (gender.toLowerCase() != 'male' && gender.toLowerCase() != 'female') {
    throw ArgumentError('Invalid gender: $gender');
  }

  // G.J. Hamwi Formula (1964)
  double hamwiWeightConstant = gender.toLowerCase() == 'male' ? maleHamwiWeightConstant : femaleHamwiWeightConstant;
  double hamwiIdealWeight = hamwiWeightConstant + (2.3 * ((height - 152.4) / 2.54));

  // B.J. Devine Formula (1974)
  double devineIdealWeight = gender.toLowerCase() == 'male' ? devineWeightConstant + (2.3 * ((height - 152.4) / 2.54)) : devineWeightConstant - 4.5 + (2.3 * ((height - 152.4) / 2.54));

  // J.D. Robinson Formula (1983)
  double robinsonWeightConstant = gender.toLowerCase() == 'male' ? maleRobinsonWeightConstant : femaleRobinsonWeightConstant;
  double robinsonHeightFactor = gender.toLowerCase() == 'male' ? 1.9 : 1.7;
  double robinsonIdealWeight = robinsonWeightConstant + (robinsonHeightFactor * ((height - 152.4) / 2.54));

  // D.R. Miller Formula (1983)
  double millerWeightConstant = gender.toLowerCase() == 'male' ? maleMillerWeightConstant : femaleMillerWeightConstant;
  double millerHeightFactor = gender.toLowerCase() == 'male' ? 1.41 : 1.36;
  double millerIdealWeight = millerWeightConstant + (millerHeightFactor * ((height - 152.4) / 2.54));

  return {
    'Hamwi': hamwiIdealWeight,
    'Devine': devineIdealWeight,
    'Robinson': robinsonIdealWeight,
    'Miller': millerIdealWeight,
  };
}


}

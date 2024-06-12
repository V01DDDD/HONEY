// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last

import 'package:firebase_auth_youtube/blocs/nutrition_bloc/nutrition_bloc.dart';
import 'package:firebase_auth_youtube/blocs/nutrition_bloc/nutrition_event.dart';
import 'package:firebase_auth_youtube/blocs/nutrition_bloc/nutrition_state.dart';
import 'package:firebase_auth_youtube/screens/pages/nutrition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const NutritionPage());
}

class NutritionDetailPage extends StatelessWidget {
  final Map<String, dynamic> food;

  const NutritionDetailPage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Food Description: ${food['description']}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Macros',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MacroCircularChart(
                          title: 'Calories',
                          value: parseDouble(getNutrientValue('Energy')),
                          unit: 'kcal',
                          color: Colors.orange,
                          remainingValue: 2000, // Assuming 2000 kcal as the daily limit
                        ),
                        MacroCircularChart(
                          title: 'Carbohydrates',
                          value: parseDouble(getNutrientValue('Carbohydrate, by difference')),
                          unit: 'g',
                          color: Colors.cyan,
                          remainingValue: 300, // Assuming 300g as the daily limit
                        ),
                        MacroCircularChart(
                          title: 'Fat',
                          value: parseDouble(getNutrientValue('Total lipid (fat)')),
                          unit: 'g',
                          color: Colors.purple,
                          remainingValue: 70, // Assuming 70g as the daily limit
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MacroCircularChart(
                          title: 'Protein',
                          value: parseDouble(getNutrientValue('Protein')),
                          unit: 'g',
                          color: Colors.blue,
                          remainingValue: 50, // Assuming 50g as the daily limit
                        ),
                        MacroCircularChart(
                          title: 'Sugar',
                          value: parseDouble(getNutrientValue('Total Sugars')),
                          unit: 'g',
                          color: Colors.red,
                          remainingValue: 50, // Assuming 50g as the daily limit
                        ),
                      ],
                    ),
                    // Add more MacroCircularChart widgets for additional nutrients as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getNutrientValue(String nutrientName) {
    final nutrient = food['foodNutrients'].firstWhere(
      (nutrient) => nutrient['nutrientName'] == nutrientName,
      orElse: () => null,
    );
    return nutrient != null ? nutrient['value'].toString() : 'N/A';
  }

  double parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }
}

class MacroCircularChart extends StatelessWidget {
  final String title;
  final double value;
  final String unit; // Add a unit property for displaying units
  final Color color;
  final double remainingValue; // Remaining value to display in the chart

  const MacroCircularChart({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.remainingValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$title:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 120, // Adjust the height as needed
          width: 120, // Adjust the width as needed
          child: SfCircularChart(
            series: <CircularSeries>[
              DoughnutSeries<Map<String, dynamic>, String>(
                dataSource: [
                  {'category': 'Value', 'value': value},
                  {'category': 'Remaining', 'value': remainingValue - value},
                ],
                xValueMapper: (data, _) => data['category'] as String,
                yValueMapper: (data, _) => data['value'] as double,
                pointColorMapper: (data, _) => data['category'] == 'Value' ? color : Colors.grey[300],
                innerRadius: '75%', // Adjust the inner radius for the doughnut chart
                cornerStyle: CornerStyle.bothCurve, // Make the ends rounded
                dataLabelMapper: (data, _) => '', // Hide data labels within the doughnut slices
                dataLabelSettings: DataLabelSettings(
                  isVisible: false, // Hide data labels within the doughnut slices
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${value.toStringAsFixed(1)} $unit',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class NutritionSearchPage extends StatelessWidget {
  const NutritionSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Search'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Search for food',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<NutritionBloc>(context).add(SearchNutrition(controller.text));
              },
              child: const Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<NutritionBloc, NutritionState>(
                builder: (context, state) {
                  if (state is NutritionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NutritionLoaded) {
                    return ListView.builder(
                      itemCount: state.foods.length,
                      itemBuilder: (context, index) {
                        final food = state.foods[index];
                        return FoodItemWidget(food: food);
                      },
                    );
                  } else if (state is NutritionError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('Enter a search term to begin'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodItemWidget extends StatelessWidget {
  final Map<String, dynamic> food;

  const FoodItemWidget({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(food['description']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NutritionDetailPage(food: food),
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }
}

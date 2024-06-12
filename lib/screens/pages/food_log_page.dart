import 'package:firebase_auth_youtube/blocs/food_log/food_log_bloc.dart';
import 'package:firebase_auth_youtube/blocs/food_log/food_log_event.dart';
import 'package:firebase_auth_youtube/blocs/food_log/food_log_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class FoodLoggingPage extends StatefulWidget {
  const FoodLoggingPage({super.key});

  @override
  _FoodLoggingPageState createState() => _FoodLoggingPageState();
}

class _FoodLoggingPageState extends State<FoodLoggingPage> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _fatController = TextEditingController();
  final _sugarController = TextEditingController();
  String _mealType = 'Breakfast';

  void _resetForm() {
    _foodNameController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbohydratesController.clear();
    _fatController.clear();
    _sugarController.clear();
    setState(() {
      _mealType = 'Breakfast';
    });
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbohydratesController.dispose();
    _fatController.dispose();
    _sugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Your Food'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _mealType,
                  decoration: InputDecoration(
                    labelText: 'Meal Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  items: <String>['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _mealType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _foodNameController,
                  decoration: InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the food name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _caloriesController,
                  decoration: InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the calorie content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _proteinController,
                  decoration: InputDecoration(
                    labelText: 'Protein (g)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _carbohydratesController,
                  decoration: InputDecoration(
                    labelText: 'Carbohydrates (g)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatController,
                  decoration: InputDecoration(
                    labelText: 'Fat (g)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sugarController,
                  decoration: InputDecoration(
                    labelText: 'Sugar (g)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<FoodLogBloc>().add(
                        AddFood(
                          name: _foodNameController.text,
                          calories: double.tryParse(_caloriesController.text) ?? 0,
                          protein: double.tryParse(_proteinController.text) ?? 0,
                          carbohydrates: double.tryParse(_carbohydratesController.text) ?? 0,
                          fat: double.tryParse(_fatController.text) ?? 0,
                          sugar: double.tryParse(_sugarController.text) ?? 0,
                          mealType: _mealType,
                        ),
                      );
                      _resetForm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Log Food'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<FoodLogBloc, FoodState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.foodItems.length,
                          itemBuilder: (context, index) {
                            final foodItem = state.foodItems[index];
                            return Dismissible(
                              key: Key(foodItem.name),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                context.read<FoodLogBloc>().add(DeleteFood(index));
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                                child: ListTile(
                                  title: Text('${foodItem.name} (${foodItem.mealType})'),
                                  subtitle: Text(
                                      'Calories: ${foodItem.calories}, Protein: ${foodItem.protein}, Carbs: ${foodItem.carbohydrates}, Fat: ${foodItem.fat}, Sugar: ${foodItem.sugar}'),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 250, // Adjusted height for the chart
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(),
                            title: const ChartTitle(text: 'Nutritional Breakdown'),
                            legend: const Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CartesianSeries<ChartData, String>>[
                              BarSeries<ChartData, String>(
                                dataSource: _generateChartData(state.foodItems),
                                xValueMapper: (ChartData data, _) => data.category,
                                yValueMapper: (ChartData data, _) => data.value,
                                name: 'Nutrition',
                                color: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<ChartData> _generateChartData(List<FoodItem> foodItems) {
    return [
      ChartData('Calories', foodItems.fold(0.0, (sum, item) => sum + item.calories)),
      ChartData('Protein', foodItems.fold(0.0, (sum, item) => sum + item.protein)),
      ChartData('Carbs', foodItems.fold(0.0, (sum, item) => sum + item.carbohydrates)),
      ChartData('Fat', foodItems.fold(0.0, (sum, item) => sum + item.fat)),
      ChartData('Sugar', foodItems.fold(0.0, (sum, item) => sum + item.sugar)),
    ];
  }
}

class ChartData {
  ChartData(this.category, this.value);
  final String category;
  final double value;
}
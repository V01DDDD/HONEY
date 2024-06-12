import 'package:firebase_auth_youtube/blocs/recipe_bloc/api_service.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/recipe_event.dart';
import 'package:firebase_auth_youtube/blocs/recipe_bloc/recipe_state.dart';
import 'package:firebase_auth_youtube/models/recipe_model.dart';
import 'package:firebase_auth_youtube/widgets/recipe_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.teal,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nutrition Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 128, 128, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildCircularChart(
                            'Calories',
                            2500,
                            2000,
                            Colors.orange,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildCircularChart(
                            'Protein',
                            100,
                            80,
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildCircularChart(
                            'Sugar',
                            50,
                            30,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildStatCard('Total Calories', '2500 kcal', Colors.orange),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildStatCard('Total Protein', '100 g', Colors.green),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildStatCard('Total Sugar', '50 g', Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 400, // Adjust this value to fit your content height
              child: DashboardPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularChart(
    String title,
    double total,
    double consumed,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              height: 100,
              child: SfCircularChart(
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: [
                      ChartData('Consumed', consumed),
                      ChartData('Remaining', total - consumed),
                    ],
                    pointColorMapper: (ChartData data, _) => data.x == 'Consumed'
                        ? color
                        : Colors.grey[200]!,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    innerRadius: '70%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Consumed: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: '$consumed',
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' / $total',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(apiService: SpoonacularService())..add(const FetchRecipes()),
      child: Scaffold(
        body: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeLoadSuccess) {
              return _buildRecipeGrid(state.recipes);
            } else if (state is RecipeLoadFailure) {
              return Center(child: Text('Failed to load recipes: ${state.error}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildRecipeGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Set to 3 items per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75, // Adjust aspect ratio if needed
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeDetailWidget(
          imageUrl: recipe.imageUrl,
          title: recipe.title,
        );
      },
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

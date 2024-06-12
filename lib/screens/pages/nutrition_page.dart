// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth_youtube/blocs/nutrition_bloc/nutrition_bloc.dart';
import 'package:firebase_auth_youtube/blocs/nutrition_bloc/nutrition_event.dart';
import 'package:firebase_auth_youtube/blocs/nutrition_bloc/nutrition_state.dart';
import 'package:firebase_auth_youtube/widgets/nutrition_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(NutritionPage());
}

class NutritionPage extends StatelessWidget {
  const NutritionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => NutritionBloc(),
        child: NutritionSearchPage(key: UniqueKey()),
      ),
    );
  }
}

class NutritionSearchPage extends StatelessWidget {
  const NutritionSearchPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Search'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Search for food',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<NutritionBloc>(context).add(SearchNutrition(controller.text));
              },
              // ignore: sort_child_properties_last
              child: const Text(
                'Search',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
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
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NutritionDetailPage(food: food),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                food['description'],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is NutritionError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
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

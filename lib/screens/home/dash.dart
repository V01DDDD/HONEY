import 'package:firebase_auth_youtube/blocs/food_log/food_log_bloc.dart';
import 'package:firebase_auth_youtube/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:firebase_auth_youtube/screens/home/home_page.dart';
import 'package:firebase_auth_youtube/screens/pages/food_log_page.dart';
import 'package:firebase_auth_youtube/screens/pages/nutrition_page.dart';
import 'package:firebase_auth_youtube/screens/pages/tdee_page.dart';
import 'package:firebase_auth_youtube/screens/pages/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static const List<Widget> _pages = <Widget>[
    NutritionPage(),
    TDEE(),
    Home(),
    RecipePage(),
    FoodLoggingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            title: const Text(
              'NUTRIPLAN',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<SignInBloc>().add(const SignOutRequired());
                },
                icon: const Icon(Icons.logout),
                iconSize: 28,
                color: Colors.white,
              ),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF009688), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8.0,
                  ),
                ],
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
      body: BlocProvider<FoodLogBloc>(
        create: (context) => FoodLogBloc(),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          bottomItem(title: "Nutrition", index: 0, icon: Icons.list),
          bottomItem(title: "TDEE", index: 1, icon: Icons.calculate),
          const Icon(Icons.home, size: 0),  // Placeholder for center button
          bottomItem(title: "Recipe", index: 3, icon: Icons.track_changes),
          bottomItem(title: "Food Log", index: 4, icon: Icons.set_meal),
        ],
        color: const Color(0xFF009688),
        buttonBackgroundColor: const Color(0xFF808000),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          _onItemTapped(index);
        },
        letIndexChange: (index) => true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white, // Set fill color to white
          onPressed: () {
            _onItemTapped(2);  // Set to the index of the center button
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)), // Adjust the border radius as needed
            side: BorderSide(color: Color(0xFF808000), width: 2.0), // Olive green border color and width
          ),
          child: const Icon(Icons.home, color: Color(0xFF808000)), // Icon color
        ),
      ),
    );
  }

  Widget bottomItem(
      {required int index, required String title, required IconData icon}) {
    if (index == _selectedIndex) {
      return Icon(
        icon,
        size: 26,
        color: Colors.white,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    }
  }
}



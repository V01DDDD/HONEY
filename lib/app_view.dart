// my_app_view.dart

import 'package:firebase_auth_youtube/repository/profile/user_repository.dart';
import 'package:firebase_auth_youtube/screens/home/dash.dart';
import 'package:firebase_auth_youtube/screens/personal/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth_youtube/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:firebase_auth_youtube/screens/auth/welcome_screen.dart';
import 'package:firebase_auth_youtube/models/user_profile.dart';
import 'package:firebase_auth_youtube/blocs/sign_in_bloc/sign_in_bloc.dart';

class MyAppView extends StatelessWidget {
  MyAppView({Key? key}) : super(key: key);

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth',
      theme: ThemeData(
        fontFamily: 'Lato',
				colorScheme: const ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Color.fromRGBO(0, 128, 128, 1),
          onPrimary: Colors.black,
          secondary: Color.fromRGBO(144, 238, 144, 1),
          onSecondary: Colors.white,
					tertiary: Color.fromRGBO(255, 204, 128, 1),
          error: Colors.red,
					outline: Color(0xFF424242)
        ),
			),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated && state.user != null) {
            return FutureBuilder<UserProfile?>(
              future: _userRepository.getUserProfile(state.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data != null) {
                  // Assuming UserProfile contains a field to indicate if personal info is complete
                  bool personalInfoComplete = snapshot.data!.personalInfoComplete;
                  if (!personalInfoComplete) {
                    // Navigate to PersonalInfoScreen if personal info is incomplete
                    return PersonalInfoScreen(
                      onInfoSubmitted: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Dashboard()),
                        );
                      },
                    );
                  }
                }
                // If personal info is complete or not available, show HomeScreen
                return BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository: context.read<AuthenticationBloc>().userRepository,
                  ),
                  child: const Dashboard(),
                );
              },
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}

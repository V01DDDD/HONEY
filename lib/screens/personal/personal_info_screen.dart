import 'package:firebase_auth_youtube/repository/profile/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_youtube/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalInfoScreen extends StatelessWidget {
  final VoidCallback onInfoSubmitted;

  PersonalInfoScreen({super.key, required this.onInfoSubmitted});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    UserRepository userRepository = UserRepository();
                    FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;

                    if (user != null) {
                      UserProfile userProfile = UserProfile(
                        uid: user.uid,
                        name: _nameController.text,
                        email: _emailController.text, 
                        personalInfoComplete: false,
                      );
                      await userRepository.saveUserProfile(userProfile);
                      onInfoSubmitted();
                    } else {
                      // Handle user not logged in
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

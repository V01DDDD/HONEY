// lib/repositories/user_repository.dart

// ignore_for_file: avoid_print

import 'package:firebase_auth_youtube/models/user_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DataSnapshot snapshot = await _databaseReference.child('users/$uid').once().then((event) => event.snapshot);
      if (snapshot.exists) {
        return UserProfile.fromJson(snapshot.value as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _databaseReference.child('users/${user.uid}').set(userProfile.toJson());
      } else {
        print('Error: Current user not found');
      }
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }
}

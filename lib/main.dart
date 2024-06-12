// ignore_for_file: unused_import

import 'package:firebase_auth_youtube/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'simple_bloc_observer.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: "AIzaSyBaVBUkDS_EFZgDrs9lnpk_LLlBIuf2j54",
      appId: "1:784183670200:android:a25b9bc95ac74ebb030b4d",
      messagingSenderId: "784183670200",
      projectId: "nutriplan-2712c",
      databaseURL: "https://nutriplan-2712c-default-rtdb.firebaseio.com"
    ),
  );
	Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}
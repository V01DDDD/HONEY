// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  NutritionBloc() : super(NutritionInitial()) {
    on<SearchNutrition>(_onSearchNutrition);
  }

  Future<void> _onSearchNutrition(SearchNutrition event, Emitter<NutritionState> emit) async {
    emit(NutritionLoading());
    print('Loading state emitted');
    try {
      const apiKey = 'N50w3S3YkNqOHfjUenLEW7VCeg8WEd051votc3CZ';  // Replace with your USDA API key
      final url = Uri.parse('https://api.nal.usda.gov/fdc/v1/foods/search?api_key=$apiKey&query=${event.query}');
      print('Requesting URL: $url');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response received successfully');
        final data = json.decode(response.body);
        emit(NutritionLoaded(data['foods']));
        print('Loaded state emitted with data: ${data['foods']}');
      } else {
        print('Error: Failed to load nutrition information');
        emit(const NutritionError('Failed to load nutrition information'));
      }
    } catch (e) {
      print('Exception: $e');
      emit(NutritionError(e.toString()));
    }
  }
}
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_youtube/blocs/tdee_bloc/tdee_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tdee_event.dart';
part 'tdee_state.dart';

class TdeeBloc extends Bloc<TdeeEvent, TdeeState> {
  TdeeBloc() : super(TdeeInitial()) {
    on<SubmitTdeeInfo>(_onSubmitTdeeInfo);
    on<TdeeReset>(_onTdeeReset);
  }

  void _onSubmitTdeeInfo(SubmitTdeeInfo event, Emitter<TdeeState> emit) {
    final calculator = TdeeCalculator(
      weight: event.weight,
      height: event.height,
      age: event.age,
      gender: event.gender,
      bodyFatPercentage: event.bodyFatPercentage,
    );

    emit(TdeeResult(calculator));
  }

  void _onTdeeReset(TdeeReset event, Emitter<TdeeState> emit) {
      emit(TdeeInitial());
    }
}

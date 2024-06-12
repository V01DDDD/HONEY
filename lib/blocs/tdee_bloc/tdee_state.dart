part of 'tdee_bloc.dart';

abstract class TdeeState extends Equatable {
  const TdeeState();
  
  @override
  List<Object> get props => [];
}

class TdeeInitial extends TdeeState {}

class TdeeResult extends TdeeState {
  final TdeeCalculator calculator;

  const TdeeResult(this.calculator);

  @override
  List<Object> get props => [calculator];
}

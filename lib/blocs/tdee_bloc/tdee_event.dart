part of 'tdee_bloc.dart';

abstract class TdeeEvent extends Equatable {
  const TdeeEvent();

  @override
  List<Object> get props => [];
}

class SubmitTdeeInfo extends TdeeEvent {
  final int weight;
  final int height;
  final int age;
  final String gender;
  final double bodyFatPercentage;

  const SubmitTdeeInfo({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.bodyFatPercentage,
  });

  @override
  List<Object> get props => [weight, height, age, gender, bodyFatPercentage];
}

class TdeeReset extends TdeeEvent {
  const TdeeReset();
}

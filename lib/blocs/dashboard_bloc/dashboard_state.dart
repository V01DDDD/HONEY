abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final double caloriesTotal;
  final double caloriesConsumed;
  final double proteinTotal;
  final double proteinConsumed;
  final double sugarTotal;
  final double sugarConsumed;

  DashboardLoaded({
    required this.caloriesTotal,
    required this.caloriesConsumed,
    required this.proteinTotal,
    required this.proteinConsumed,
    required this.sugarTotal,
    required this.sugarConsumed,
  });
}

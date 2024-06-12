import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth_youtube/blocs/dashboard_bloc/dashboard_event.dart';
import 'package:firebase_auth_youtube/blocs/dashboard_bloc/dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial());

  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is LoadDashboardData) {
      // Fetch data from backend or any other data source
      // For simplicity, I'll use some hardcoded values
      yield DashboardLoaded(
        caloriesTotal: 2500,
        caloriesConsumed: 2000,
        proteinTotal: 100,
        proteinConsumed: 80,
        sugarTotal: 50,
        sugarConsumed: 30,
      );
    }
  }
}

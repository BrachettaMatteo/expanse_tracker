part of 'expanse_tracker_bloc.dart';

@immutable
abstract class ExpanseTrackerState {}

class ExpanseTrackerInitial extends ExpanseTrackerState {}

class ExpanseTrackerLoaded extends ExpanseTrackerState {
  final List<Cost> lstAllCost;
  ExpanseTrackerLoaded({required this.lstAllCost});
}

class ExpanseTrackerClosed extends ExpanseTrackerState {}

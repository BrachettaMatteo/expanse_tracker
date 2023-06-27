part of 'expanse_tracker_bloc.dart';

@immutable
abstract class ExpanseTrackerEvent {}

class ExpanseTrackerEventInitial extends ExpanseTrackerEvent {}

class ExpanseTrackerEventAddCost extends ExpanseTrackerEvent {
  final Cost costToAdd;
  ExpanseTrackerEventAddCost(this.costToAdd);
}

class ExpanseTrackerEventRemoveCost extends ExpanseTrackerEvent {
  final String idCostToRemove;
  ExpanseTrackerEventRemoveCost(this.idCostToRemove);
}

class ExpanseTrakerEventUpdateCost extends ExpanseTrackerEvent {
  final String idCostToUpdate;
  final Cost newCost;

  ExpanseTrakerEventUpdateCost(this.idCostToUpdate, this.newCost);
}

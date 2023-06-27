import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../Data/Repositories/expanse_traker_repository.dart';
import '../../../Data/db.dart';
import '../../../Domain/Model/cost.dart';

part 'expanse_tracker_event.dart';
part 'expanse_tracker_state.dart';

class ExpanseTrackerBloc
    extends Bloc<ExpanseTrackerEvent, ExpanseTrackerState> {
  ExpanseTrackerBloc() : super(ExpanseTrackerInitial()) {
    ExpanseTrakerRepository db = MyDB();
    on<ExpanseTrackerEventInitial>((event, emit) async {
      await db.initDb();
      final List<Cost> lCosts = await db.getAllCosts();
      emit(ExpanseTrackerLoaded(lstAllCost: lCosts));
    });
    on<ExpanseTrackerEventAddCost>((event, emit) async {
      db.addCost(newCost: event.costToAdd);
      final List<Cost> lCosts = await db.getAllCosts();
      emit(ExpanseTrackerLoaded(lstAllCost: lCosts));
    });
    on<ExpanseTrackerEventRemoveCost>((event, emit) async {
      db.removeCost(idCost: event.idCostToRemove);
      final List<Cost> lCosts = await db.getAllCosts();
      emit(ExpanseTrackerLoaded(lstAllCost: lCosts));
    });
    on<ExpanseTrakerEventUpdateCost>((event, emit) async {
      db.updateCost(
          idCostToUpdate: event.idCostToUpdate, newCost: event.newCost);
      final List<Cost> lCosts = await db.getAllCosts();
      emit(ExpanseTrackerLoaded(lstAllCost: lCosts));
    });
  }
}

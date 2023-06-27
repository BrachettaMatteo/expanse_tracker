import 'package:sqflite/sqflite.dart';

import '../Domain/Model/cost.dart';
import 'Repositories/expanse_traker_repository.dart';

class MyDB implements ExpanseTrakerRepository {
  late final Database db;

  @override
  Future<void> initDb() async {
    final String path = "${await getDatabasesPath()} expanseTracker.db";
    db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE ${ExpanseTrakerRepository.nameTableDB}(
          ${ExpanseTrakerRepository.fieldId} TEXT PRIMARY KEY,
          ${ExpanseTrakerRepository.fieldImport} REAL NOT NULL,
          ${ExpanseTrakerRepository.fieldDescription} TEXT,
          ${ExpanseTrakerRepository.fieldDate} INTEGER NOT NULL
        )
        """);
    });
  }

  @override
  Future<bool> addCost({required Cost newCost}) async {
    final int result =
        await db.insert(ExpanseTrakerRepository.nameTableDB, newCost.toJson());
    return result == 0;
  }

  @override
  Future<List<Cost>> getAllCosts() async {
    final List<Map<String, dynamic>> allElements = await db
        .rawQuery('SELECT * FROM ${ExpanseTrakerRepository.nameTableDB}');

    List<Cost> out = [];
    for (Map<String, dynamic> element in allElements) {
      Cost cost = Cost.fromJson(element);
      out.add(cost);
    }
    return out;
  }

  @override
  Future<bool> removeCost({required String idCost}) async {
    final int result = await db.rawDelete(
        'DELETE FROM ${ExpanseTrakerRepository.nameTableDB} WHERE ${ExpanseTrakerRepository.fieldId} = ?',
        [idCost]);
    return result == 1;
  }

  @override
  Future<bool> updateCost(
      {required String idCostToUpdate, required Cost newCost}) async {
    final int result = await db.rawUpdate('''
    UPDATE ${ExpanseTrakerRepository.nameTableDB} 
    SET  
      ${ExpanseTrakerRepository.fieldImport}= ?,
      ${ExpanseTrakerRepository.fieldDescription} = ?,
      ${ExpanseTrakerRepository.fieldDate}= ?
    WHERE ${ExpanseTrakerRepository.fieldId} = ?
    ''', [
      newCost.import,
      newCost.description,
      newCost.date.millisecondsSinceEpoch,
      newCost.id
    ]);
    return result == 1;
  }

  @override
  Future<void> dispose() => db.close();
}

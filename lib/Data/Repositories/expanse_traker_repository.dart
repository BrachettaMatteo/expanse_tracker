import '../../Domain/Model/cost.dart';

abstract class ExpanseTrakerRepository {
  static String nameTableDB = " ExpandTrakerDB";
  static String fieldId = "id";
  static String fieldImport = "import";
  static String fieldDescription = "description";
  static String fieldDate = "date";

  /// if the db does not exist a new DB will be created
  Future<void> initDb();

  /// get All cost present on DB
  Future<List<Cost>> getAllCosts();

  /// add cost to local DB [newCost] cost to add
  Future<bool> addCost({required Cost newCost});

  /// Remove cost
  /// [idCost] id for remove cost
  ///
  /// Throws an [ArgumentError] if there [idCost] isn't present on db
  Future<bool> removeCost({required String idCost});

  /// Update cost
  /// [idCostToUpdate] id Cost for update
  /// [newCost] new cost for update
  ///
  /// Throws an [ArgumentError] if there [idCostToUpdate] isn't present on db
  Future<bool> updateCost(
      {required String idCostToUpdate, required Cost newCost});

  Future<void> dispose();
}

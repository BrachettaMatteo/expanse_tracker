import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../Data/Repositories/expanse_traker_repository.dart';

class Cost {
  String id;
  double import;
  String? description;
  DateTime date;

  Cost(
      {required this.id,
      required this.import,
      required this.description,
      required this.date});

  factory Cost.create(
          {required double import,
          required String? description,
          required DateTime date}) =>
      Cost(
          id: const Uuid().v4(),
          import: import,
          description: description,
          date: date);
  factory Cost.empty() => Cost(
      id: const Uuid().v4(),
      import: 0.0,
      description: "",
      date: DateTime.now());
  factory Cost.fromJson(Map<String, dynamic> json) {
    return Cost(
      id: json[ExpanseTrakerRepository.fieldId],
      import: json[ExpanseTrakerRepository.fieldImport],
      description: json[ExpanseTrakerRepository.fieldDescription] ?? "",
      date: DateTime.fromMillisecondsSinceEpoch(
          json[ExpanseTrakerRepository.fieldDate]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ExpanseTrakerRepository.fieldId: id,
      ExpanseTrakerRepository.fieldImport: import,
      ExpanseTrakerRepository.fieldDescription: description ?? "",
      ExpanseTrakerRepository.fieldDate: date.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return """
    info Cost:
      id: $id
      import: $import
      date: ${DateFormat("dd MMMM").format(date)}
    """;
  }
}

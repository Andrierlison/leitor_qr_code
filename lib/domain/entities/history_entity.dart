import 'package:intl/intl.dart';

class HistoryEntity {
  final int? id;
  final String name;
  final String dateInsert;
  final bool isFavorite;

  HistoryEntity({
    required this.name,
    required this.dateInsert,
    required this.isFavorite,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateInsert': dateInsert,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  String getDateFormated() {
    try {
      final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
      final String result = formatter.format(DateTime.parse(dateInsert));
      return result;
    } catch (error) {
      return '';
    }
  }
}

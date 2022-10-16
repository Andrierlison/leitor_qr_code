import 'package:leitor_qr_code/domain/entities/history_entity.dart';

abstract class GetHistoryRepository {
  Future<List<HistoryEntity>> call();
}

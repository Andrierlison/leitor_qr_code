// Project imports:
import 'package:leitor_qr_code/domain/entities/history_entity.dart';

abstract class SaveHistoryRepository {
  Future<HistoryEntity> call({required HistoryEntity item});
}

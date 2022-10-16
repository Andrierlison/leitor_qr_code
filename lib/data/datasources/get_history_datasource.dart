import 'package:leitor_qr_code/domain/entities/history_entity.dart';

abstract class GetHistoryDataSource {
  Future<List<HistoryEntity>> call();
}

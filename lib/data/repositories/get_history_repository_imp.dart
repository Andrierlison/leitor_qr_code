// Project imports:
import 'package:leitor_qr_code/data/datasources/get_history_datasource.dart';
import 'package:leitor_qr_code/domain/entities/history_entity.dart';
import 'package:leitor_qr_code/domain/repositories/get_history_repository.dart';

class GetHistoryRepositoryImp implements GetHistoryRepository {
  final GetHistoryDataSource _getHistoryDataSource;
  GetHistoryRepositoryImp(this._getHistoryDataSource);

  @override
  Future<List<HistoryEntity>> call() async {
    return _getHistoryDataSource.call();
  }
}

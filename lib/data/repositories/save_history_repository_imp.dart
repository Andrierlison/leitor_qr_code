import 'package:leitor_qr_code/data/datasources/save_history_datasource.dart';
import 'package:leitor_qr_code/domain/entities/history_entity.dart';
import 'package:leitor_qr_code/domain/repositories/save_history_repository.dart';

class SaveHistoryRepositoryImp implements SaveHistoryRepository {
  final SaveHistoryDataSource _saveHistoryDataSource;
  SaveHistoryRepositoryImp(this._saveHistoryDataSource);

  @override
  Future<HistoryEntity> call({required HistoryEntity item}) async {
    return _saveHistoryDataSource.call(item: item);
  }
}

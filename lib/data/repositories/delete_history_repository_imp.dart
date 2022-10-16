import 'package:leitor_qr_code/data/datasources/delete_history_datasource.dart';
import 'package:leitor_qr_code/domain/repositories/delete_history_repository.dart';

class DeleteHistoryRepositoryImp implements DeleteHistoryRepository {
  final DeleteHistoryDataSource _deleteHistoryDataSource;
  DeleteHistoryRepositoryImp(this._deleteHistoryDataSource);

  @override
  Future<bool> call({required int id}) async {
    return _deleteHistoryDataSource.call(id: id);
  }
}

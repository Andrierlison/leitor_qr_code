// Project imports:
import 'package:leitor_qr_code/domain/repositories/delete_history_repository.dart';
import 'package:leitor_qr_code/domain/usecases/delete_history/delete_history_usecase.dart';

class DeleteHistoryUseCaseImp implements DeleteHistoryUseCase {
  final DeleteHistoryRepository _deleteHistoryRepository;
  DeleteHistoryUseCaseImp(this._deleteHistoryRepository);

  @override
  Future<bool> call({required int id}) {
    return _deleteHistoryRepository.call(id: id);
  }
}

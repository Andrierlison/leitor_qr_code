// Project imports:
import 'package:leitor_qr_code/domain/entities/history_entity.dart';
import 'package:leitor_qr_code/domain/repositories/save_history_repository.dart';
import 'package:leitor_qr_code/domain/usecases/save_history/save_history_usecase.dart';

class SaveHistoryUseCaseImp implements SaveHistoryUseCase {
  final SaveHistoryRepository _saveHistoryRepository;

  SaveHistoryUseCaseImp(this._saveHistoryRepository);

  @override
  Future<HistoryEntity> call({required HistoryEntity item}) async {
    return _saveHistoryRepository.call(item: item);
  }
}

import 'package:leitor_qr_code/domain/entities/history_entity.dart';
import 'package:leitor_qr_code/domain/repositories/get_history_repository.dart';
import 'package:leitor_qr_code/domain/usecases/get_history/get_history_usecase.dart';

class GetHistoryUseCaseImp implements GetHistoryUseCase {
  final GetHistoryRepository _getHistoryRepository;

  GetHistoryUseCaseImp(this._getHistoryRepository);

  @override
  Future<List<HistoryEntity>> call() async {
    return _getHistoryRepository.call();
  }
}

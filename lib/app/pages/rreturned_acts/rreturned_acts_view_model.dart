part of 'rreturned_acts_page.dart';

class RreturnedActsViewModel extends PageViewModel<RreturnedActsState, RreturnedActsStateStatus> {
  final RreturnedActsRepository rreturnedActsRepository;

  RreturnedActsViewModel(
    this.rreturnedActsRepository,
    { required ApiRreturnedAct rreturnedAct }
  ) : super(RreturnedActsState(rreturnedAct: rreturnedAct));

  @override
  RreturnedActsStateStatus get status => state.status;

  void updateRreturnedAct(ApiRreturnedAct rreturnedAct) {
    emit(state.copyWith(status: RreturnedActsStateStatus.rreturnedActUpdated, rreturnedAct: rreturnedAct));
  }

  Future<void> deleteOrderLineScan(ApiRreturnedActLine line) async {
    emit(state.copyWith(status: RreturnedActsStateStatus.inProgress));

    try {
      final rreturnedAct = await rreturnedActsRepository.deleteLineScan(state.rreturnedAct, line);

      updateRreturnedAct(rreturnedAct);

      emit(state.copyWith(
        status: RreturnedActsStateStatus.success,
        message: 'Сканирование успешно удалено'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: RreturnedActsStateStatus.failure, message: e.message));
    }
  }

  Future<void> scan(String code) async {
    try {
      final rreturnedAct = await rreturnedActsRepository.scanLine(state.rreturnedAct, code);

      updateRreturnedAct(rreturnedAct);

      emit(state.copyWith(
        status: RreturnedActsStateStatus.scanSuccess,
        message: 'КМ успешно отсканирован'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: RreturnedActsStateStatus.scanFailure, message: e.message));
    }
  }

  Future<void> tryCompleteScan() async {
    final scannedVol = state.rreturnedAct.lines.where((e) => e.storageScanned != null).fold(0.0, (v, el) => v + el.volume);
    final totalVol = state.rreturnedAct.lines.fold(0.0, (v, el) => v + el.volume);

    if (scannedVol != totalVol) {
      emit(state.copyWith(
        status: RreturnedActsStateStatus.needUserConfirmation,
        message: 'Количество отсканированного не равно количеству в акте. Вы точно хотите завершить?'
      ));

      return;
    }

    await completeScan(true);
  }

  Future<void> completeScan(bool confirmed) async {
    if (!confirmed) return;

    emit(state.copyWith(status: RreturnedActsStateStatus.inProgress));

    try {
      final rreturnedAct = await rreturnedActsRepository.completeScan(state.rreturnedAct);

      updateRreturnedAct(rreturnedAct);

      emit(state.copyWith(
        status: RreturnedActsStateStatus.success,
        message: 'Информация сохранена'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: RreturnedActsStateStatus.failure, message: e.message));
    }
  }
}

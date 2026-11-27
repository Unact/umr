part of 'rreturned_acts_page.dart';

enum RreturnedActsStateStatus {
  initial,
  dataLoaded,
  dataLoadFailure,
  rreturnedActUpdated,
  inProgress,
  success,
  failure,
  scanSuccess,
  scanFailure,
  needUserConfirmation
}

class RreturnedActsState {
  RreturnedActsState({
    this.status = RreturnedActsStateStatus.initial,
    required this.rreturnedAct,
    this.message = '',
    this.sellers = const [],
    this.storages = const []
  });

  final RreturnedActsStateStatus status;
  final ApiRreturnedAct rreturnedAct;
  final String message;
  final List<ApiSeller> sellers;
  final List<ApiStorage> storages;

  RreturnedActsState copyWith({
    RreturnedActsStateStatus? status,
    ApiRreturnedAct? rreturnedAct,
    String? message,
    List<ApiSeller>? sellers,
    List<ApiStorage>? storages
  }) {
    return RreturnedActsState(
      status: status ?? this.status,
      rreturnedAct: rreturnedAct ?? this.rreturnedAct,
      message: message ?? this.message,
      sellers: sellers ?? this.sellers,
      storages: storages ?? this.storages
    );
  }
}

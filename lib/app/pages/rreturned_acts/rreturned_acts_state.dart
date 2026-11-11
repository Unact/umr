part of 'rreturned_acts_page.dart';

enum RreturnedActsStateStatus {
  initial,
  dataLoaded,
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
    this.message = ''
  });

  final RreturnedActsStateStatus status;
  final ApiRreturnedAct rreturnedAct;
  final String message;

  RreturnedActsState copyWith({
    RreturnedActsStateStatus? status,
    ApiRreturnedAct? rreturnedAct,
    String? message
  }) {
    return RreturnedActsState(
      status: status ?? this.status,
      rreturnedAct: rreturnedAct ?? this.rreturnedAct,
      message: message ?? this.message
    );
  }
}

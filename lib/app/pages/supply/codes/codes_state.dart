part of 'codes_page.dart';

enum CodesStateStatus {
  initial,
  dataLoaded,
  inProgress,
  success,
  failure,
  needUserConfirmation
}

class CodesState {
  CodesState({
    this.status = CodesStateStatus.initial,
    required this.supply,
    required this.confirmationCallback,
    this.lineCodes = const [],
    this.finished = false,
    this.message = ''
  });

  final CodesStateStatus status;
  final ApiSupply supply;
  final Function confirmationCallback;
  final List<SupplyLineCode> lineCodes;
  final String message;
  final bool finished;

  bool get allowEdit => !finished && supply.allLineCodes.isEmpty;

  CodesState copyWith({
    CodesStateStatus? status,
    ApiSupply? supply,
    Function? confirmationCallback,
    List<SupplyLineCode>? lineCodes,
    bool? finished,
    String? message
  }) {
    return CodesState(
      status: status ?? this.status,
      supply: supply ?? this.supply,
      confirmationCallback: confirmationCallback ?? this.confirmationCallback,
      lineCodes: lineCodes ?? this.lineCodes,
      finished: finished ?? this.finished,
      message: message ?? this.message
    );
  }
}

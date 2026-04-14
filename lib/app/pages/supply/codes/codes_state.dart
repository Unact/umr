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
    this.lineCodes = const [],
    this.finished = false,
    this.message = ''
  });

  final CodesStateStatus status;
  final ApiSupply supply;
  final List<SupplyLineCode> lineCodes;
  final String message;
  final bool finished;

  bool get fullyScanned => lineCodes.fold(0.0, (prev, e) => prev + e.vol) ==
    supply.lines.fold(0.0, (prev, e) => prev + e.vol);

  bool get allowEdit => !finished && supply.allLineCodes.isEmpty;

  CodesState copyWith({
    CodesStateStatus? status,
    ApiSupply? supply,
    List<SupplyLineCode>? lineCodes,
    bool? finished,
    String? message
  }) {
    return CodesState(
      status: status ?? this.status,
      supply: supply ?? this.supply,
      lineCodes: lineCodes ?? this.lineCodes,
      finished: finished ?? this.finished,
      message: message ?? this.message
    );
  }
}

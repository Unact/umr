part of 'supply_page.dart';

enum SupplyStateStatus {
  initial,
  dataLoaded
}

class SupplyState {
  SupplyState({
    this.status = SupplyStateStatus.initial,
    required this.supply
  });

  final SupplyStateStatus status;
  final ApiSupply supply;

  SupplyState copyWith({
    SupplyStateStatus? status,
    ApiSupply? supply
  }) {
    return SupplyState(
      status: status ?? this.status,
      supply: supply ?? this.supply
    );
  }
}

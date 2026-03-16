part of 'supply_page.dart';

class SupplyViewModel extends PageViewModel<SupplyState, SupplyStateStatus> {
  final SuppliesRepository suppliesRepository;

  SupplyViewModel(this.suppliesRepository, { required ApiSupply supply }) :
    super(SupplyState(supply: supply));

  @override
  SupplyStateStatus get status => state.status;
}

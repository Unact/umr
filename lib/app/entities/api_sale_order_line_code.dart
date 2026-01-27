part of 'entities.dart';

class ApiSaleOrderLineCode extends Equatable {
  final int subid;
  final String code;
  final int vol;
  final bool isTracking;
  final SaleOrderScanType type;
  final String? groupCode;

  const ApiSaleOrderLineCode({
    required this.subid,
    required this.code,
    required this.vol,
    required this.isTracking,
    required this.groupCode,
    required this.type
  });

  factory ApiSaleOrderLineCode.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderLineCode(
      subid: json['subid'],
      code: json['code'],
      vol: json['vol'],
      isTracking: json['isTracking'],
      groupCode: json['groupCode'],
      type: SaleOrderScanType.values[json['type']]
    );
  }

  @override
  List<Object?> get props => [
    subid,
    code,
    vol,
    isTracking,
    groupCode,
    type
  ];
}

part of 'entities.dart';

class ApiInfoScan extends Equatable {
  final String code;
  final String gtin;
  final int vol;
  final bool isTracking;
  final String ownerInn;
  final List<ApiInfoScanSaleOrder> saleOrders;
  final List<ApiInfoScanSaleOrder> saleOrderReturns;
  final String? codeErrorMessage;

  const ApiInfoScan({
    required this.code,
    required this.gtin,
    required this.vol,
    required this.isTracking,
    required this.ownerInn,
    required this.saleOrders,
    required this.saleOrderReturns,
    this.codeErrorMessage,
  });

  factory ApiInfoScan.fromJson(Map<String, dynamic> json) {
    return ApiInfoScan(
      code: json['code'],
      gtin: json['gtin'],
      vol: json['vol'],
      isTracking: json['isTracking'],
      ownerInn: json['ownerInn'],
      saleOrders: json['saleOrders'].map<ApiInfoScanSaleOrder>((e) => ApiInfoScanSaleOrder.fromJson(e)).toList(),
      saleOrderReturns: json['saleOrderReturns']
        .map<ApiInfoScanSaleOrder>((e) => ApiInfoScanSaleOrder.fromJson(e)).toList(),
      codeErrorMessage: json['codeErrorMessage'],
    );
  }

  @override
  List<Object?> get props => [
    code,
    gtin,
    vol,
    isTracking,
    ownerInn,
    saleOrders,
    saleOrderReturns,
    codeErrorMessage
  ];
}

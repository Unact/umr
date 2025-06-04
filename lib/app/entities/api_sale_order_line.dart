part of 'entities.dart';

class ApiSaleOrderLine extends Equatable {
  final int subid;
  final double vol;
  final double rel;
  final String measureName;
  final String goodsName;
  final String gtin;

  const ApiSaleOrderLine({
    required this.subid,
    required this.vol,
    required this.rel,
    required this.measureName,
    required this.goodsName,
    required this.gtin,
  });

  factory ApiSaleOrderLine.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderLine(
      subid: json['subid'],
      vol: Parsing.parseDouble(json['vol'])!,
      rel: Parsing.parseDouble(json['rel'])!,
      measureName: json['measureName'],
      goodsName: json['goodsName'],
      gtin: json['gtin'],
    );
  }

  @override
  List<Object?> get props => [
    subid,
    vol,
    rel,
    measureName,
    goodsName,
    gtin
  ];
}

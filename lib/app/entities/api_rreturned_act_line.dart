part of 'entities.dart';

class ApiRreturnedActLine extends Equatable {
  final int id;
  final double volume;
  final double rel;
  final String goodsName;
  final String gtin;
  final String code;
  final DateTime? storageScanned;

  const ApiRreturnedActLine({
    required this.id,
    required this.volume,
    required this.rel,
    required this.goodsName,
    required this.gtin,
    required this.code,
    this.storageScanned
  });

  factory ApiRreturnedActLine.fromJson(Map<String, dynamic> json) {
    return ApiRreturnedActLine(
      id: json['id'],
      volume: Parsing.parseDouble(json['volume'])!,
      rel: Parsing.parseDouble(json['rel'])!,
      goodsName: json['goodsName'],
      gtin: json['gtin'],
      code: json['code'],
      storageScanned: Parsing.parseDate(json['storageScanned']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    volume,
    rel,
    goodsName,
    gtin,
    code,
    storageScanned
  ];
}

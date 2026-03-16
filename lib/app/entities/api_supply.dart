part of 'entities.dart';

class ApiSupply extends Equatable {
  final int id;
  final String ndoc;
  final String sellerName;
  final bool linked;
  final String? trustLevelName;
  final List<ApiSupplyLine> lines;
  final List<ApiSupplyLineCode> allLineCodes;

  const ApiSupply({
    required this.id,
    required this.ndoc,
    required this.sellerName,
    required this.trustLevelName,
    required this.linked,
    required this.lines,
    required this.allLineCodes,
  });

  factory ApiSupply.fromJson(Map<String, dynamic> json) {
    return ApiSupply(
      id: json['id'],
      ndoc: json['ndoc'],
      sellerName: json['sellerName'],
      trustLevelName: json['trustLevelName'],
      linked: json['linked'],
      lines: json['lines'].map<ApiSupplyLine>((e) => ApiSupplyLine.fromJson(e)).toList(),
      allLineCodes: json['allLineCodes'].map<ApiSupplyLineCode>((e) => ApiSupplyLineCode.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    sellerName,
    trustLevelName,
    linked,
    lines,
    allLineCodes
  ];
}

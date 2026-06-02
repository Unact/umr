part of 'entities.dart';

class ApiSupply extends Equatable {
  final int id;
  final String ndoc;
  final String sellerName;
  final bool linked;
  final DateTime? scanned;
  final String? trustLevelName;
  final List<ApiSupplyLine> lines;

  const ApiSupply({
    required this.id,
    required this.ndoc,
    required this.sellerName,
    required this.trustLevelName,
    this.scanned,
    required this.linked,
    required this.lines,
  });

  factory ApiSupply.fromJson(Map<String, dynamic> json) {
    return ApiSupply(
      id: json['id'],
      ndoc: json['ndoc'],
      sellerName: json['sellerName'],
      trustLevelName: json['trustLevelName'],
      scanned: Parsing.parseDate(json['scanned']),
      linked: json['linked'],
      lines: json['lines'].map<ApiSupplyLine>((e) => ApiSupplyLine.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    sellerName,
    trustLevelName,
    scanned,
    linked,
    lines
  ];
}

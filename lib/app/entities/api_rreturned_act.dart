part of 'entities.dart';

class ApiRreturnedAct extends Equatable {
  final int id;
  final String ndoc;
  final String buyerName;
  final DateTime? storageScanned;
  final List<ApiRreturnedActLine> lines;

  const ApiRreturnedAct({
    required this.id,
    required this.ndoc,
    required this.buyerName,
    this.storageScanned,
    required this.lines,
  });

  factory ApiRreturnedAct.fromJson(Map<String, dynamic> json) {
    return ApiRreturnedAct(
      id: json['id'],
      ndoc: json['ndoc'],
      buyerName: json['buyerName'],
      storageScanned: Parsing.parseDate(json['storageScanned']),
      lines: json['lines'].map<ApiRreturnedActLine>((e) => ApiRreturnedActLine.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    id,
    ndoc,
    buyerName,
    storageScanned,
    lines
  ];
}

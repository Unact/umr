part of 'entities.dart';

class ApiSupplyStorageLineCode extends Equatable {
  final int id;
  final int subid;
  final String code;
  final int vol;

  const ApiSupplyStorageLineCode({
    required this.id,
    required this.subid,
    required this.code,
    required this.vol
  });

  factory ApiSupplyStorageLineCode.fromJson(Map<String, dynamic> json) {
    return ApiSupplyStorageLineCode(
      id: json['id'],
      subid: json['subid'],
      code: json['code'],
      vol: json['vol']
    );
  }

  @override
  List<Object?> get props => [
    id,
    subid,
    code,
    vol
  ];
}

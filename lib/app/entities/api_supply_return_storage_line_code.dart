part of 'entities.dart';

class ApiSupplyReturnStorageLineCode extends Equatable {
  final int id;
  final int subid;
  final String code;
  final int vol;

  const ApiSupplyReturnStorageLineCode({
    required this.id,
    required this.subid,
    required this.code,
    required this.vol,
  });

  factory ApiSupplyReturnStorageLineCode.fromJson(Map<String, dynamic> json) {
    return ApiSupplyReturnStorageLineCode(
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

part of 'entities.dart';

class ApiSaleOrderReturnStorageLineCode extends Equatable {
  final int id;
  final int subid;
  final String code;
  final int vol;

  const ApiSaleOrderReturnStorageLineCode({
    required this.id,
    required this.subid,
    required this.code,
    required this.vol,
  });

  factory ApiSaleOrderReturnStorageLineCode.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderReturnStorageLineCode(
      id: json['id'],
      subid: json['subid'],
      code: json['code'],
      vol: json['vol'],
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

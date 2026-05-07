part of 'entities.dart';

class ApiSaleOrderStorageLineCode extends Equatable {
  final int id;
  final int subid;
  final String code;
  final int vol;
  final bool isTracking;
  final String? groupCode;

  const ApiSaleOrderStorageLineCode({
    required this.id,
    required this.subid,
    required this.code,
    required this.vol,
    required this.isTracking,
    required this.groupCode
  });

  factory ApiSaleOrderStorageLineCode.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderStorageLineCode(
      id: json['id'],
      subid: json['subid'],
      code: json['code'],
      vol: json['vol'],
      isTracking: json['isTracking'],
      groupCode: json['groupCode']
    );
  }

  @override
  List<Object?> get props => [
    id,
    subid,
    code,
    vol,
    isTracking,
    groupCode
  ];
}

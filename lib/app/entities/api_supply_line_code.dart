part of 'entities.dart';

class ApiSupplyLineCode extends Equatable {
  final int subid;
  final String code;
  final int vol;

  const ApiSupplyLineCode({
    required this.subid,
    required this.code,
    required this.vol
  });

  factory ApiSupplyLineCode.fromJson(Map<String, dynamic> json) {
    return ApiSupplyLineCode(
      subid: json['subid'],
      code: json['code'],
      vol: json['vol']
    );
  }

  @override
  List<Object?> get props => [
    subid,
    code,
    vol
  ];
}

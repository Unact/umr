part of 'entities.dart';

class ApiSupplyMarkirovkaCode extends Equatable {
  final String code;
  final int subid;
  final int vol;

  const ApiSupplyMarkirovkaCode({
    required this.code,
    required this.subid,
    required this.vol
  });

  factory ApiSupplyMarkirovkaCode.fromJson(Map<String, dynamic> json) {
    return ApiSupplyMarkirovkaCode(
      code: json['code'],
      subid: json['subid'],
      vol: json['vol']
    );
  }

  @override
  List<Object?> get props => [
    code,
    subid,
    vol
  ];
}

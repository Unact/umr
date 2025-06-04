part of 'entities.dart';

class ApiMarkirovkaCode extends Equatable {
  final String code;
  final String gtin;
  final int vol;

  const ApiMarkirovkaCode({
    required this.code,
    required this.gtin,
    required this.vol
  });

  factory ApiMarkirovkaCode.fromJson(Map<String, dynamic> json) {
    return ApiMarkirovkaCode(
      code: json['code'],
      gtin: json['gtin'],
      vol: json['vol']
    );
  }

  @override
  List<Object?> get props => [
    code,
    gtin,
    vol
  ];
}

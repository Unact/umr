part of 'entities.dart';

class ApiCode extends Equatable {
  final String code;

  const ApiCode({
    required this.code
  });

  factory ApiCode.fromJson(Map<String, dynamic> json) {
    return ApiCode(code: json['code']);
  }

  @override
  List<Object> get props => [
    code
  ];
}

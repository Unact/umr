part of 'entities.dart';

class ApiCode extends Equatable {
  final String code;
  final String requestId;

  const ApiCode({
    required this.code,
    required this.requestId
  });

  factory ApiCode.fromJson(Map<String, dynamic> json) {
    return ApiCode(code: json['code'], requestId: json['requestId']);
  }

  @override
  List<Object> get props => [
    code,
    requestId
  ];
}

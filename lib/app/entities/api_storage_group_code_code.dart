part of 'entities.dart';

class ApiStorageGroupCodeCode extends Equatable {
  final int id;
  final String code;

  const ApiStorageGroupCodeCode({
    required this.id,
    required this.code
  });

  factory ApiStorageGroupCodeCode.fromJson(Map<String, dynamic> json) {
    return ApiStorageGroupCodeCode(
      id: json['id'],
      code: json['code']
    );
  }

  @override
  List<Object?> get props => [
    id,
    code
  ];
}

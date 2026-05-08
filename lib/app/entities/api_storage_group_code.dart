part of 'entities.dart';

class ApiStorageGroupCode extends Equatable {
  final int id;
  final String groupCode;
  final DateTime? packaged;
  final List<ApiStorageGroupCodeCode> codes;

  const ApiStorageGroupCode({
    required this.id,
    required this.groupCode,
    this.packaged,
    required this.codes
  });

  factory ApiStorageGroupCode.fromJson(Map<String, dynamic> json) {
    return ApiStorageGroupCode(
      id: json['id'],
      groupCode: json['groupCode'],
      packaged: Parsing.parseDate(json['packaged']),
      codes: json['codes'].map<ApiStorageGroupCodeCode>((e) => ApiStorageGroupCodeCode.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    id,
    groupCode,
    packaged,
    codes
  ];
}

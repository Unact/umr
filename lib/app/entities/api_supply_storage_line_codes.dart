part of 'entities.dart';

class ApiSupplyStorageLineCodes extends Equatable {
  final List<ApiSupplyStorageLineCode> codes;

  const ApiSupplyStorageLineCodes({
    required this.codes
  });

  factory ApiSupplyStorageLineCodes.fromJson(Map<String, dynamic> json) {
    return ApiSupplyStorageLineCodes(
      codes: json['codes'].map<ApiSupplyStorageLineCode>((e) => ApiSupplyStorageLineCode.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    codes
  ];
}

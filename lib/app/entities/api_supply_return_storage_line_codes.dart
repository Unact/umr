part of 'entities.dart';

class ApiSupplyReturnStorageLineCodes extends Equatable {
  final List<ApiSupplyReturnStorageLineCode> codes;

  const ApiSupplyReturnStorageLineCodes({
    required this.codes
  });

  factory ApiSupplyReturnStorageLineCodes.fromJson(Map<String, dynamic> json) {
    return ApiSupplyReturnStorageLineCodes(
      codes: json['codes']
        .map<ApiSupplyReturnStorageLineCode>((e) => ApiSupplyReturnStorageLineCode.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    codes
  ];
}

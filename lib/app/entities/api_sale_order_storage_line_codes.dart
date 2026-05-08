part of 'entities.dart';

class ApiSaleOrderStorageLineCodes extends Equatable {
  final List<ApiSaleOrderStorageLineCode> codes;

  const ApiSaleOrderStorageLineCodes({
    required this.codes
  });

  factory ApiSaleOrderStorageLineCodes.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderStorageLineCodes(
      codes: json['codes'].map<ApiSaleOrderStorageLineCode>((e) => ApiSaleOrderStorageLineCode.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    codes
  ];
}

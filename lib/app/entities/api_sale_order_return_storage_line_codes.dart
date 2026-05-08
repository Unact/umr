part of 'entities.dart';

class ApiSaleOrderReturnStorageLineCodes extends Equatable {
  final List<ApiSaleOrderReturnStorageLineCode> codes;

  const ApiSaleOrderReturnStorageLineCodes({
    required this.codes
  });

  factory ApiSaleOrderReturnStorageLineCodes.fromJson(Map<String, dynamic> json) {
    return ApiSaleOrderReturnStorageLineCodes(
      codes: json['codes']
        .map<ApiSaleOrderReturnStorageLineCode>((e) => ApiSaleOrderReturnStorageLineCode.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    codes
  ];
}

part of 'entities.dart';

class ApiScanData extends Equatable {
  final List<ApiCode> codes;

  const ApiScanData({
    required this.codes
  });

  factory ApiScanData.fromJson(Map<String, dynamic> json) {
    List<ApiCode> codes = json['codes'].map<ApiCode>((e) => ApiCode.fromJson(e)).toList();

    return ApiScanData(codes: codes);
  }

  @override
  List<Object> get props => [
    codes
  ];
}

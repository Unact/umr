part of 'entities.dart';

class ApiSupplyMarkirovkaCode extends Equatable {
  final String code;
  final List<ApiSupplyMarkirovkaCodeSupgoods> supgoods;
  final List<ApiSupplyLineCodeDetail> details;

  const ApiSupplyMarkirovkaCode({
    required this.code,
    required this.supgoods,
    required this.details
  });

  factory ApiSupplyMarkirovkaCode.fromJson(Map<String, dynamic> json) {
    return ApiSupplyMarkirovkaCode(
      code: json['code'],
      supgoods: json['supgoods']
        .map<ApiSupplyMarkirovkaCodeSupgoods>((e) => ApiSupplyMarkirovkaCodeSupgoods.fromJson(e)).toList(),
      details: json['details'].map<ApiSupplyLineCodeDetail>((e) => ApiSupplyLineCodeDetail.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    code,
    supgoods,
    details
  ];
}

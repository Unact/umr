part of 'entities.dart';

class ApiSupplyMarkirovkaCode extends Equatable {
  final String code;
  final List<ApiSupplyMarkirovkaCodeSupgoods> supgoods;

  const ApiSupplyMarkirovkaCode({
    required this.code,
    required this.supgoods
  });

  factory ApiSupplyMarkirovkaCode.fromJson(Map<String, dynamic> json) {
    return ApiSupplyMarkirovkaCode(
      code: json['code'],
      supgoods: json['supgoods']
        .map<ApiSupplyMarkirovkaCodeSupgoods>((e) => ApiSupplyMarkirovkaCodeSupgoods.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [
    code,
    supgoods
  ];
}

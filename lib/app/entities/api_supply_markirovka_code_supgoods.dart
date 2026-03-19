part of 'entities.dart';

class ApiSupplyMarkirovkaCodeSupgoods extends Equatable {
  final int subid;
  final int vol;

  const ApiSupplyMarkirovkaCodeSupgoods({
    required this.subid,
    required this.vol
  });

  factory ApiSupplyMarkirovkaCodeSupgoods.fromJson(Map<String, dynamic> json) {
    return ApiSupplyMarkirovkaCodeSupgoods(
      subid: json['subid'],
      vol: json['vol']
    );
  }

  @override
  List<Object?> get props => [
    subid,
    vol
  ];
}

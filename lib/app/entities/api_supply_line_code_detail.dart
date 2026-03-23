part of 'entities.dart';

class ApiSupplyLineCodeDetail extends Equatable {
  final String cis;
  final String? parent;

  const ApiSupplyLineCodeDetail({
    required this.cis,
    required this.parent,
  });

  factory ApiSupplyLineCodeDetail.fromJson(Map<String, dynamic> json) {
    return ApiSupplyLineCodeDetail(
      cis: json['cis'],
      parent: json['parent']
    );
  }

  @override
  List<Object?> get props => [
    cis,
    parent
  ];
}

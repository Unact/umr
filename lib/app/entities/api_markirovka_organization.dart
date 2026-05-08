part of 'entities.dart';

class ApiMarkirovkaOrganization extends Equatable {
  final int id;
  final String name;
  final bool isDefault;

  const ApiMarkirovkaOrganization({
    required this.id,
    required this.name,
    required this.isDefault
  });

  factory ApiMarkirovkaOrganization.fromJson(Map<String, dynamic> json) {
    return ApiMarkirovkaOrganization(
      id: json['id'],
      name: json['name'],
      isDefault: json['isDefault']
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    isDefault
  ];
}

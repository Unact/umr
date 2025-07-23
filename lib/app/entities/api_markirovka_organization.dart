part of 'entities.dart';

class ApiMarkirovkaOrganization extends Equatable {
  final int id;
  final String name;

  const ApiMarkirovkaOrganization({
    required this.id,
    required this.name
  });

  factory ApiMarkirovkaOrganization.fromJson(Map<String, dynamic> json) {
    return ApiMarkirovkaOrganization(
      id: json['id'],
      name: json['name']
    );
  }

  @override
  List<Object?> get props => [
    id,
    name
  ];
}

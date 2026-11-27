part of 'entities.dart';

class ApiSeller extends Equatable {
  final int id;
  final String name;

  const ApiSeller({
    required this.id,
    required this.name
  });

  factory ApiSeller.fromJson(Map<String, dynamic> json) {
    return ApiSeller(
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
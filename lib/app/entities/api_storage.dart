part of 'entities.dart';

class ApiStorage extends Equatable {
  final int id;
  final String name;
  final int sellerId;

  const ApiStorage({
    required this.id,
    required this.name,
    required this.sellerId
  });

  factory ApiStorage.fromJson(Map<String, dynamic> json) {
    return ApiStorage(
      id: json['id'],
      name: json['name'],
      sellerId: json['sellerId']
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    sellerId
  ];
}
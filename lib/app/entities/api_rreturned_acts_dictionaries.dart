part of 'entities.dart';

class ApiRreturnedActsDictionaries extends Equatable {
  final List<ApiSeller> sellers;
  final List<ApiStorage> storages;

  const ApiRreturnedActsDictionaries({
    required this.sellers,
    required this.storages
  });

  factory ApiRreturnedActsDictionaries.fromJson(Map<String, dynamic> json) {
    return ApiRreturnedActsDictionaries(
      sellers: json['sellers'].map<ApiSeller>((e) => ApiSeller.fromJson(e)).toList(),
      storages: json['storages'].map<ApiStorage>((e) => ApiStorage.fromJson(e)).toList()
    );
  }

  @override
  List<Object?> get props => [
    sellers,
    storages
  ];
}

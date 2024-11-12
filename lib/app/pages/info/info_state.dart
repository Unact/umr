part of 'info_page.dart';

enum InfoStateStatus {
  initial
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial
  });

  final InfoStateStatus status;

  InfoState copyWith({
    InfoStateStatus? status,
  }) {
    return InfoState(
      status: status ?? this.status
    );
  }
}

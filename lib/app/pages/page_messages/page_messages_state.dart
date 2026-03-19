part of 'page_messages_page.dart';

enum PageMessagesStateStatus {
  initial,
  dataLoaded
}

class PageMessagesState {
  PageMessagesState({
    this.status = PageMessagesStateStatus.initial,
    this.pageMessages = const []
  });

  final PageMessagesStateStatus status;
  final List<PageMessagesInfo> pageMessages;

  PageMessagesState copyWith({
    PageMessagesStateStatus? status,
    List<PageMessagesInfo>? pageMessages,
  }) {
    return PageMessagesState(
      status: status ?? this.status,
      pageMessages: pageMessages ?? this.pageMessages
    );
  }
}

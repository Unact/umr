part of 'page_messages_page.dart';

class PageMessagesViewModel extends PageViewModel<PageMessagesState, PageMessagesStateStatus> {
  final AppRepository appRepository;

  PageMessagesViewModel(
    this.appRepository
  ) : super(PageMessagesState());

  @override
  PageMessagesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    emit(state.copyWith(pageMessages: appRepository.getPageMessagesInfo().reversed.toList()));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '/app/repositories/app_repository.dart';

class PageHelpers {
  static void showMessage(BuildContext context, String message, Color color) {
    RepositoryProvider.of<AppRepository>(context).addPageMessagesInfo(message: message, date: DateTime.now());

    toastification.dismissAll(delayForAnimation: false);
    toastification.show(
      context: context,
      backgroundColor: color,
      foregroundColor: Colors.white,
      description: Text(message),
      showIcon: false,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      dismissDirection: DismissDirection.down,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}

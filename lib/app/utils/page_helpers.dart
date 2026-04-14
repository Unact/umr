import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '/app/constants/strings.dart';
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

  static Future<void> showConfirmationDialog(
    BuildContext context,
    Function(bool) confirmationCallback,
    String message
  ) async {
    bool result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: SingleChildScrollView(child: ListBody(children: <Widget>[Text(message)])),
        actions: <Widget>[
          TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(false)),
          TextButton(child: const Text('Подтверждаю'), onPressed: () => Navigator.of(context).pop(true))
        ],
      )
    ) ?? false;

    confirmationCallback(result);
  }
}

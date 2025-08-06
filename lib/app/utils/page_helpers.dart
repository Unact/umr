import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class PageHelpers {
  static void showMessage(BuildContext context, String message, Color color) {
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

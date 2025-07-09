import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class PageHelpers {
  static void showMessage(BuildContext context, String message, Color color) {
    toastification.show(
      context: context,
      backgroundColor: color,
      foregroundColor: Colors.white,
      title: Text(message),
      showIcon: false,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      dismissDirection: DismissDirection.down,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}

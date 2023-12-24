import 'package:flutter/material.dart';
import 'package:hafiz_app/core/app_export.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog(
      {BuildContext? context, isCancellable = false}) async {
    if (!isProgressVisible &&
        NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
          barrierDismissible: isCancellable,
          context: NavigatorService.navigatorKey.currentState!.overlay!.context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            );
          });
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Navigator.pop(
          NavigatorService.navigatorKey.currentState!.overlay!.context);
    }
    isProgressVisible = false;
  }
}

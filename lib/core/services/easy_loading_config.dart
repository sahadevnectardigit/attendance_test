import 'package:flutter_easyloading/flutter_easyloading.dart';

/// Global EasyLoading config
void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..toastPosition = EasyLoadingToastPosition.center
    ..dismissOnTap = false
    ..displayDuration = const Duration(seconds: 2);
}
import 'package:flutter/foundation.dart';

/// Provider to manage navbar index
class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
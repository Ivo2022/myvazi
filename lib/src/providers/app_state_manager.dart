import 'package:flutter/foundation.dart';

class AppStateManagerProvider extends ChangeNotifier {
  int _selectedScreenIndex = 0;

  int get selectedScreenIndex => _selectedScreenIndex;

  void setSelectedScreenIndex(int index) {
    _selectedScreenIndex = index;

    notifyListeners();
  }
}

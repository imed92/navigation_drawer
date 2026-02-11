import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  String _title = 'Accueil';

  String get title => _title;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void resetTitle() {
    _title = 'Accueil';
    notifyListeners();
  }
}

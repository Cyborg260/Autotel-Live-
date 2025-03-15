import 'package:flutter/cupertino.dart';

class DateTimePickerViewModel with ChangeNotifier {
  setDateTime() {
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

class providerVariables with ChangeNotifier {
  int selecteditem = 0;
  bool pinisrequired = false;
  bool otpisrequired = false;
  bool phoneisrequired = false;
  bool isLoading = false;
  String errorMessage = '';
  int OTPDigitnum = 6;

  void setOTPDigitnum(int newvalue) {
    OTPDigitnum = newvalue;
    notifyListeners();
  }

  void seterrorMessage(String newvalue) {
    errorMessage = newvalue;
    notifyListeners();
  }

  void ChangebottomAppBarindexto(int newvalue) {
    selecteditem = newvalue;
    notifyListeners();
  }

  void setpinrequired(bool newvalue) {
    pinisrequired = newvalue;
    notifyListeners();
  }

  void setotprequired(bool newvalue) {
    otpisrequired = newvalue;
    notifyListeners();
  }

  void setphonerequired(bool newvalue) {
    phoneisrequired = newvalue;
    notifyListeners();
  }

  void setisLoading(bool newvalue) {
    isLoading = newvalue;
    notifyListeners();
  }
}

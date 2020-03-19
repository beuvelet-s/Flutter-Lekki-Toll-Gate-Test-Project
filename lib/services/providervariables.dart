import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class providerVariables with ChangeNotifier {
  int selecteditem = 0;
  bool pinisrequired = false;
  bool otpisrequired = false;
  bool phoneisrequired = false;
  bool isLoading = false;
  bool successfulltransaction = false;
  String errorMessage = '';
  int OTPDigitnum = 6;
  double fees = 0;
  double amountpaid = 0;
  String transactionid = '';

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void settransactionid(String newvalue) {
    transactionid = newvalue;
    notifyListeners();
  }

  void setfees(double newvalue) {
    fees = newvalue;
    notifyListeners();
  }

  void setamountpaid(double newvalue) {
    amountpaid = newvalue;
    notifyListeners();
  }

  void setsuccessfulltransaction(bool newvalue) {
    successfulltransaction = newvalue;
    notifyListeners();
  }

  void setselecteditem(int newvalue) {
    selecteditem = newvalue;
    notifyListeners();
  }

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

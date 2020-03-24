import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class providerVariables with ChangeNotifier {
  int selecteditem = 0;
  bool pinisrequired = false;
  bool otpisrequired = false;
  bool phoneisrequired = false;
  bool isLoading = false;
  bool successfulltransaction = false;
  bool successfullpassagepayment = false;
  String errorMessage = '';
  int OTPDigitnum = 6;
  int passagefee = 200;
  double fees = 0;
  double amountpaid = 0;
  String transactionid = '';
  String keydecryptQR = '';
  String barcodedecrypted = '...';
  String userId;
  String immatriculation = "AGL707DZ";
  String vehicle_type = "PRADO";

  PageController pageController = PageController(
//    initialPage: selecteditem,
    keepPage: true,
  );

  void setuserId(String newvalue) {
    userId = newvalue;
    notifyListeners();
  }

  void setbarcodedecrypted(String newvalue) {
    barcodedecrypted = newvalue;
    notifyListeners();
  }

  void setkeydecryptQR(String newvalue) {
    keydecryptQR = newvalue;
    notifyListeners();
  }

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

  void setsuccessfullpassagepayment(bool newvalue) {
    successfullpassagepayment = newvalue;
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

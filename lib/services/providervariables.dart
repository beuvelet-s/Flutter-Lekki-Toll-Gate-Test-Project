import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/models/vehicle_model.dart';

class providerVariables with ChangeNotifier {
  int selecteditem;
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
  Map<String, int> tariffs = {
//    "Class M": 50,
//    "Class I": 120,
//    "Class II": 150,
//    "Class IIA": 80,
//    "Class III": 250,
//    "Class IV": 350
  };
  double height_textfield_cardnum = 35.0;
  double height_textfield_expiry = 35.0;
  double height_textfield_cvv = 35.0;

  double Screenwidth = 0.0;
  double Screenheight = 0.0;
  List<VehicleModel> vehicle_global_object = [];
  PageController pageController = PageController(
//    initialPage: selecteditem,
    keepPage: true,
  );

  void setheight_textfield_cardnum(double newvalue) {
    this.height_textfield_cardnum = newvalue;
  }

  void setheight_textfield_expiry(double newvalue) {
    this.height_textfield_expiry = newvalue;
  }

  void setheight_textfield_cvv(double newvalue) {
    this.height_textfield_cvv = newvalue;
  }

  void addVehicle_global_object(VehicleModel car) {
    this.vehicle_global_object.add(car);
  }

  void clearVehicle_image() {
    this.vehicle_global_object.clear();
  }

  void setScreenSize(BuildContext context) {
    this.Screenwidth = MediaQuery.of(context).size.width;
    this.Screenheight = MediaQuery.of(context).size.height;
  }

  void addtariffs(String k, int v) {
    tariffs[k] = v;
    notifyListeners();
  }

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

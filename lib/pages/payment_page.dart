import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/circularwidget.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/pin_entry_text_custom.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/showOtpFields.dart';
import 'package:flutter_app_paul_test/models/chargeobjectmodel.dart';
import 'package:flutter_app_paul_test/models/successresponseobjectmodel.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/input_formatters.dart';
import 'package:flutter_app_paul_test/services/payment_card.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
//  final GlobalKey bottomNavigationKey;
//  PaymentPage({Key key, this.bottomNavigationKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _errorMessage;
  bool _isLoading;
  var _paymentCard = PaymentCard();
  final TextEditingController _cardnumcontrol = TextEditingController();
  final TextEditingController _cardnumcontrolAmount = TextEditingController();
  final FocusNode _sourceFocus = FocusNode();
  final FocusNode _cardFocus = FocusNode();
  final FocusNode _expiryFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _pinFocus = FocusNode();
  final FocusNode _payFocus = FocusNode();
  final _formKeypay = new GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  var _sourceofFund = 'Debit Card';
  FirebaseUser currentuser;
  String userId;
  bool _autoValidate = false;
  String _reference = '';
  List<bool> isSelected = [false, true, false];
  List<int> isSelectedValue = [4, 6, 8];
  FocusNode focusNodeButton1 = FocusNode();
  FocusNode focusNodeButton2 = FocusNode();
  FocusNode focusNodeButton3 = FocusNode();
  List<FocusNode> focusToggle;
  int _nbdigitOPT = 6;
  bool _redrawotpfield = false;
  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(_cardnumcontrol.text);
    String cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _paymentCard.type = 'Others';
    _cardnumcontrol.addListener(_getCardTypeFrmNumber);
    getThingsonStartUp().then((result) {
      print('initialisation de userID');
    });
  }

  Future<void> getThingsonStartUp() async {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    currentuser = await auth.getCurrentUser();
    userId = currentuser.uid;
  }

  Future<Map> Checkpendingcharge(String reference) async {
    final Map<String, String> _headerData = {
      "Content-Type": "application/json",
      'Authorization': Authorization
    };
    final String _url = 'https://api.paystack.co/charge/$reference';
    String _message = '';
    String _success = '';
    Map _result = {};
    await http.get(Uri.parse(_url), headers: _headerData).then((result) {
      if (result.statusCode == 200) {
        var _jsonbody = json.decode(result.body);
        bool status = _jsonbody['status'];
        _success = _jsonbody['data']['status'];
        if (status == true && _success == "success") {
          _result = {
            'success': true,
            'response': _jsonbody,
            'message': 'Payment successfull'
          };
        } else {
          print('Checkpendingcharge returns : false');
          _message = _jsonbody['message'];
          _result = {
            'success': false,
            'responsebody': _jsonbody,
            'message': _message
          };
        }
      }
    }).catchError((e) {
      print("Error in Checkpendingcharge : $e");
    });
    return _result;
  }

  @override
  Widget build(BuildContext context) {
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    String _cardtypeselected;
    String _amount = '';
    String transactionid = '';
    int fees = 0;
    int amountpaid = 0;
    int _balance;
    double _Screenwidth = MediaQuery.of(context).size.width;
    double _Screenheight = MediaQuery.of(context).size.height;
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);
    String _otp = '';
    focusToggle = [focusNodeButton1, focusNodeButton2, focusNodeButton3];
    Future<dynamic> ManagePaystackResponse(jsonbody) async {
      String _message = '';
      String _displaytext = '';
      String _url = '';
      String _ussdcode = '';

      _globalvariables.setisLoading(false);
      var _result;
      bool status = jsonbody['status'];
      if (status == true) {
        switch (jsonbody['data']['status']) {
          case "pending":
            {
              print('pending');
              _message = 'pending';
              _reference = jsonbody['data']['reference'];
              Timer(Duration(seconds: 10), () async {
                print("Yeah, this line is printed after 10 seconds");
                _result = await Checkpendingcharge(_reference);
              });
              // action to take: call Check pending charge at least 10 seconds
              // after getting this status
            }
            break;
          case "send_pin":
            {
//              action to take:
//              show data.display_text to user with input for PIN
//              call Submit PIN with reference and PIN
              _reference = jsonbody['data']['reference'];
              _globalvariables.setpinrequired(true);
            }
            break;
          case "success":
            {
//              action to take:
//              show data transaction an possibility to copy details in database
//              credit funds into wallet
              _result = successresponse.fromJson(jsonbody);
              _globalvariables.setpinrequired(false);
              print('${_result.data.amount}');
              var ref = db.collection("transactions");
              await ref.add({
                "userid": userId,
                "transaction_data": _result.toJson()
              }).then((docref) {
                print(
                    "transaction added with transaction ID = ${docref.documentID}");
                _globalvariables.setsuccessfulltransaction(true);
                _globalvariables.settransactionid(docref.documentID);
                _globalvariables.setfees(_result.data.fees / 100);
                _globalvariables.setamountpaid(_result.data.amount / 100);
              }).catchError((err) => print('Error: $err'));
            }
            break;
          case "send_phone":
            {
//              action to take:
//              show data.display_text to user with input for Phone
//              call Submit Phone with reference and phone
              _reference = jsonbody['data']['reference'];
              _message = jsonbody['data']['status'];
              _displaytext = jsonbody['data']['display_text'];
            }
            break;
          case "send_birthday":
            {
//              action to take:
//              show data.display_text to user with input for Birthday
//              call Submit Birthday with reference and birthday
              _reference = jsonbody['data']['reference'];
              _message = jsonbody['data']['status'];
              _displaytext = jsonbody['data']['display_text'];
            }
            break;
          case "send_otp":
            {
              // action to take:
              //show data.display_text to user with input for OTP
              //call Submit OTP with reference and otp
              _reference = jsonbody['data']['reference'];
              _message = jsonbody['data']['status'];
              _displaytext = jsonbody['data']['display_text'];
              _globalvariables.setotprequired(true);
            }
            break;
          case "open_url":
            {
              _url = jsonbody['data']['url'];
            }
//action to take: open data.url in user’s browser.
//You can specify an optional url to which we should redirect the user after
// the attempt is complete by adding redirect_to=[url] as a GET query parameter.
// call Check pending charge at least 5 seconds after user closes browser page or after
// 5 minutes, whichever comes first.
            break;
          case "pay_offline":
            {
              _ussdcode = jsonbody['data']['ussd_code'];
// action to take: promt data.ussd_code as a phone string to user
// User needs to dial the provided USSD code to complete the transaction offline
            }
            break;
          case "failed":
            {
              _message = jsonbody['data']['message'];
              if (jsonbody['data']['message'] == "Incorrect PIN") {
                _reference = jsonbody['data']['reference'];
                _globalvariables.setpinrequired(true);
              }
            }
            break;
          case "false":
            {
              print('debug your logic');
              _message = 'debug your logic';
// action to take: no remedy, start a new charge after showing data.message to user
            }
            break;
          case "timeout":
            {
              print('timeout');
              _message = 'timeout';
// action to take: no remedy, you may start a new charge after showing data.message to user
            }
            break;
        }
      }
      return _result;
    }

    Future<Map> sendPIN(String reference) async {
      final Map<String, String> _headerData = {
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': Authorization
      };
      final Map<String, String> _bodyData = {
        "pin": _paymentCard.pin,
        'reference': reference
      };
      final String _url = 'https://api.paystack.co/charge/submit_pin';
      String _message = '';
      String _success = '';
      Map _result = {};
      await http
          .post(Uri.parse(_url),
              headers: _headerData,
              body: _bodyData,
              encoding: Encoding.getByName("utf-8"))
          .then((result) {
        if (result.statusCode == 200 || result.statusCode == 400) {
          var _jsonbody = json.decode(result.body);
          bool status = _jsonbody['status'];
          _success = _jsonbody['data']['status'];
          if (status == true && _success == "success") {
            _result = {
              'success': true,
              'response': _jsonbody,
              'message': 'Payment successfull'
            };
          } else {
            if (status == true && _success != "success") {
              print('sendPIN returns : ${_jsonbody['data']['status']}');
              _message = _jsonbody['data']['status'];
              _result = {
                'success': false,
                'responsebody': _jsonbody,
                'message': _message
              };
              ManagePaystackResponse(_jsonbody);
            } else {
              print('sendPIN returns : false');
              _message = _jsonbody['data']['message'];
              _result = {
                'success': false,
                'responsebody': _jsonbody,
                'message': _message
              };
            }
          }
          ;
        }
        ;
      }).catchError((e) {
        print("Error in sendPIN : $e");
        setState(() {
          _errorMessage = e;
        });
      });
      return _result;
    }

    Future<Map> sendOTP(otp, reference) async {
      final Map<String, String> _headerData = {
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': Authorization
      };
      // This will trigger UI to rebuild with PIN input TextField

      final Map<String, String> _bodyData = {
        "otp": otp,
        'reference': reference
      };
      final String _url = 'https://api.paystack.co/charge/submit_otp';
      String _message = '';
      String _success = '';
      Map _result = {};
      await http
          .post(Uri.parse(_url),
              headers: _headerData,
              body: _bodyData,
              encoding: Encoding.getByName("utf-8"))
          .then((result) {
        if (result.statusCode == 200) {
          var _jsonbody = json.decode(result.body);
          bool status = _jsonbody['status'];
          _success = _jsonbody['data']['status'];
          if (status == true && _success == "success") {
            _result = {
              'success': true,
              'response': _jsonbody,
              'message': 'Payment successfull'
            };
          } else {
            if (status == true && _success != "success") {
              print('sendOTP returns : ${_jsonbody['data']['status']}');
              _message = _jsonbody['data']['status'];
              _result = {
                'success': false,
                'responsebody': _jsonbody,
                'message': _message
              };
              ManagePaystackResponse(_jsonbody);
            } else {
              print('sendOTP returns : false');
              _message = _jsonbody['data']['message'];
              _result = {
                'success': false,
                'responsebody': _jsonbody,
                'message': _message
              };
            }
          }
          ;
        }
        ;
      }).catchError((e) {
//      setState(() {
//        _errorMessage = e;
//      });
        print("Error in sendOTP : $e");
      });
      return _result;
    }

    Future<dynamic> PaywithPaystack(url, headerData, bodydata) async {
      var bodyjson = json.encode(bodydata);
      var _result;
      await http
          .post(Uri.parse(url),
              headers: headerData,
              body: bodyjson,
              encoding: Encoding.getByName("utf-8"))
          .then((result) async {
        if (result.statusCode == 200) {
          var jsonbody = json.decode(result.body);
          await ManagePaystackResponse(jsonbody).then((result) {
            _result = result;
          });
        } else {}
      }).catchError((e) {
        setState(() {
          _errorMessage = e;
        });
        print('Error $e');
      });
      return _result;
    }

    Future<dynamic> Charge() async {
//Payment Charge using http POST request
      final String url = 'https://api.paystack.co/charge';
      String _tollid = '';
      String _email = '';
      String _name = '';
//      String p = 'Bearer $vAuthToken';

      final Map<String, String> headerData = {
        "Content-Type": "application/json",
        'Authorization': Authorization
      };
      await db
          .collection("users")
          .where('userid', isEqualTo: userId)
          .getDocuments()
          .then((result) async {
        _email = result.documents[0].data['email'];
        _tollid = result.documents[0].data['tollid'];
        _name = result.documents[0].data['name'];

        //Construct the Charge Object to be sent to paystack
        CustomFields customfields1 = CustomFields();
        customfields1.value = _tollid;
        customfields1.displayName = 'tollID';
        customfields1.variableName = 'tollid';

        CustomFields customfields2 = CustomFields();
        customfields2.value = _name;
        customfields2.displayName = 'Name';
        customfields2.variableName = 'name';

        CardObject card1 = CardObject();
        card1.number = _paymentCard.number;
        card1.cvv = _paymentCard.cvv;
        card1.expiryMonth = _paymentCard.month;
        card1.expiryYear = _paymentCard.year;

        List<CustomFields> listcustomfield = List<CustomFields>();
        listcustomfield.add(customfields1);
        listcustomfield.add(customfields2);

        Metadata metadata1 = Metadata();
        metadata1.customFields = listcustomfield;

        Charge_object bodydata = Charge_object();
        bodydata.email = _email;
        bodydata.amount = _amount;
        bodydata.card = card1;
        bodydata.metadata = metadata1;
        // bodydata.pin = _paymentCard.pin;
        await PaywithPaystack(url, headerData, bodydata.toJson())
            .then((resultpaystack) {
          return resultpaystack;
        }).catchError((e) {
          setState(() {
            _errorMessage = e;
          });
          print('Error in Charge object : $e');
        });
      }).catchError((e) {
        setState(() {
          _errorMessage = e;
        });
        print('Error in Charge object : $e');
      });
    }

    _fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }

    // Check if form is valid before perform Payment
    bool FormvalidatedPay() {
      final form = _formKeypay.currentState;
      if (form.validate()) {
        form.save();
        return true;
      } else {
        setState(() {
          _autoValidate = true;
        });
        return false;
      }
    }

    // Perform login or signup
    Future<bool> validateAndSubmitPay() async {
      _errorMessage = "";
      bool _validated = false;
      if (FormvalidatedPay()) {
        String userId;
        try {
          print('Form Valid!');
          _validated = true;
        } catch (e) {
          print('Error: $e');
          setState(() {
            _errorMessage = e.message;
          });
        }
      }
      return _validated;
    }

    String validateFundingSource(String value) {
      if (value != 'Debit_Card')
        return 'Funding Source should be : Debit_Card';
      else
        return null;
    }

    String validateCardNumber(String value) {
      Pattern pattern = r'\\b[0-9]{4}\\s[0-9]{4}\\s[0-9]{4}\\s[0-9]{4}\\b';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Card Number';
      else
        return null;
    }

    String validateExpiryDate(String value) {
//  Expiry Date are of 10 digit only
      if (value.length != 4)
        return 'Expiry Card must be of 4 digit';
      else
        return null;
    }

    String validateCVV(String value) {
// Phone number are of 10 digit only
      if (value.length != 3)
        return 'CVV must be 3 digit';
      else {
        return null;
      }
    }

    String validateAmount(String value) {
      if (int.parse(value) <= 100000)
        return 'Amount must be more than 1000.00';
      else {
        return null;
      }
    }

    String validatePIN(String value) {
      if (value.length != 4)
        return 'PIN should be of 4 digits';
      else {
        return null;
      }
    }

    Widget showExplanation() {
      return Padding(
        padding: EdgeInsets.fromLTRB(34.0, 10.0, 0.0, 0.0),
        child: Container(
            child: new Text('Fund Your Wallet',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))),
      );
    }

    Widget showFundingSourceInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(54, 0, 0, 0),
            child:
                Text('Select Funding Source', style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0.0),
            child: DropdownButtonFormField<String>(
              value: _sourceofFund,
              items: [
                DropdownMenuItem(
                    value: "Debit Card", child: Text("Debit Card")),
                DropdownMenuItem(
                    value: "Bank Account", child: Text("Bank Account"))
              ],
              onChanged: (String newValue) {
                print("value : $newValue");
                setState(() {
                  _sourceofFund = newValue;
                });
              },
              decoration: new InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Color(0xFFE8E8E8),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                labelText: 'Funding Source',
                alignLabelWithHint: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFD97A00), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ),
        ],
      );
    }

    Widget showCardNumberInput() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(54, 20, 0, 0),
            child: Text('Enter Card Number', style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 1.0, 50.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _cardFocus,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _cardFocus, _expiryFocus);
              },
              autofocus: true,
              decoration: new InputDecoration(
                filled: true,
                fillColor: Color(0xFFE8E8E8),
                icon: CardUtils.getCardIcon(_paymentCard.type),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                labelText: 'Debit Card Number',
                hintText: '#### #### #### ####',
                alignLabelWithHint: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFD97A00), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              controller: _cardnumcontrol,
              validator: CardUtils.validateCardNum,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter(),
              ],
              onSaved: (String value) {
                print('onSaved = $value');
                print('Num controller has = ${_cardnumcontrol.text}');
                _paymentCard.number = CardUtils.getCleanedNumber(value);
              },
            ),
          ),
        ],
      );
    }

    Widget showExpiryDateInput() {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 15.0, 10.0, 0.0),
          child: new TextFormField(
            controller: _expiryController,
            maxLines: 1,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            focusNode: _expiryFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _expiryFocus, _cvvFocus);
            },
            autofocus: true,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Color(0xFFE8E8E8),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              labelText: 'Expiry Date',
              hintText: 'MM/YY',
              alignLabelWithHint: false,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFFD97A00), width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            validator: CardUtils.validateDate,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              new LengthLimitingTextInputFormatter(4),
              new CardMonthInputFormatter()
            ],
            onSaved: (value) {
              List<String> expiryDate = CardUtils.getExpiryDate(value);
              _paymentCard.month = expiryDate[0];
              _paymentCard.year = expiryDate[1];
            },
          ),
        ),
      );
    }

    Widget showCVVInput() {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 50.0, 0.0),
          child: new TextFormField(
            controller: _cvvController,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            focusNode: _cvvFocus,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _cvvFocus, _amountFocus);
            },
            autofocus: true,
            decoration: new InputDecoration(
                filled: true,
                fillColor: Color(0xFFE8E8E8),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                labelText: 'CVV',
                alignLabelWithHint: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFD97A00), width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            validator: CardUtils.validateCVV,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              new LengthLimitingTextInputFormatter(3),
            ],
            onSaved: (value) {
              _paymentCard.cvv = value;
            },
          ),
        ),
      );
    }

    Widget showAmountInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          focusNode: _amountFocus,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _amountFocus, _pinFocus);
          },
          autofocus: true,
          decoration: new InputDecoration(
            filled: true,
            fillColor: Color(0xFFE8E8E8),
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            labelText: 'Enter Amount',
            hintText: '######.##',
            alignLabelWithHint: false,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFD97A00), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          controller: _cardnumcontrolAmount,
          validator: CardUtils.validateAmount,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(8),
            CurrencyPtBrInputFormatter()
          ],
          onSaved: (value) {
            _amount = CardUtils.getCleanedNumber(value);
          },
        ),
      );
    }

//    Widget showPINInput() {
//      return Padding(
//        padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
//        child: new TextFormField(
//          controller: _pinController,
//          maxLines: 1,
//          keyboardType: TextInputType.number,
//          textInputAction: TextInputAction.done,
//          focusNode: _pinFocus,
//          onFieldSubmitted: (value) {
//            _pinFocus.unfocus();
//          },
//          autofocus: true,
//          obscureText: true,
//          decoration: new InputDecoration(
//            filled: true,
//            fillColor: Color(0xFFE8E8E8),
//            contentPadding:
//                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//            labelText: 'Enter PIN',
//            alignLabelWithHint: false,
//            enabledBorder: OutlineInputBorder(
//              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//              borderRadius: BorderRadius.circular(8.0),
//            ),
//            focusedBorder: OutlineInputBorder(
//              borderSide:
//                  const BorderSide(color: Color(0xFFD97A00), width: 2.0),
//              borderRadius: BorderRadius.circular(8.0),
//            ),
//            labelStyle: TextStyle(
//                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//          ),
//          validator: validatePIN,
//          inputFormatters: [
//            MaskTextInputFormatter(
//                mask: '####', filter: {"#": RegExp(r'[0-9]')})
//          ],
////          onSaved: (value) => _PIN = value.trim(),
//          onSaved: (value) {
//            _paymentCard.pin = value;
//          },
//        ),
//      );
//    }

    Widget showPAYButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 5.0),
          child: SizedBox(
            height: 56.0,
            child: RaisedButton(
              focusNode: _payFocus,
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(33.0),
              ),
              color: Color(0xFFD97A00),
              child: Text('PAY',
                  style: new TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onPressed: () async {
                if (await validateAndSubmitPay() == true) {
//                  _globalvariables.setisLoading(true);
                  var _result = await Charge();
                  if (_result['success'] == false) {
                    // This will trigger UI to rebuild with PIN input TextField
                    print('PAyment has failed');
                  }
                  print('result Paystack = $_result');
                  // TODO increase Fund wallet
                  Navigator.pushNamed(context, '/home');
                }
                _globalvariables.setisLoading(false);
              },
            ),
          ));
    }

    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return new Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    Widget _showForm(BuildContext context) {
      return Stack(children: <Widget>[
        Container(
            child: new Form(
          key: _formKeypay,
          autovalidate: _autoValidate,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 15),
              showExplanation(),
              SizedBox(height: 20),
              showFundingSourceInput(),
              showCardNumberInput(),
              Row(children: [showExpiryDateInput(), showCVVInput()]),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Container(height: 6.0, color: Color(0xFFDCDCDC)),
              ),
              showAmountInput(),
//              showPINInput(),
              showPAYButton(),
              showErrorMessage(),
            ],
          ),
        )),
        _globalvariables.pinisrequired == true
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                    width: _Screenwidth,
                    height: _Screenheight,
                    color: Colors.black.withOpacity(0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Enter PIN:',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                PinEntryTextFieldCustom(
                                  isTextObscure: true,
                                  showFieldAsBox: true,
                                  onSubmit: (String pin) async {
                                    _paymentCard.pin = pin;
                                    var _result = await sendPIN(_reference);
                                    if (_result['success'] == false ||
                                        _result['success'] == null) {
                                      setState(() {
                                        _errorMessage = _result['message'];
                                      });
                                      print(
                                          'PAyment has failed : $_errorMessage');
                                      _globalvariables.setpinrequired(false);
                                      ManagePaystackResponse(
                                          _result['responsebody']);
                                    } else {
                                      print('result Paystack = $_result');
                                      _globalvariables.setpinrequired(false);
                                      // TODO increase Fund wallet
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    }
                                  }, // end onSubmit
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    _errorMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                        height: 1.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ],
                            ), // end Padding()
                          ),
                        ])))
            : Container(),
        _globalvariables.otpisrequired == true
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: _Screenwidth,
                  height: _Screenheight,
                  color: Colors.black.withOpacity(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ToggleButtons(
                        color: Colors.greenAccent,
                        selectedColor: Colors.amberAccent,
                        fillColor: Colors.white70,
                        splashColor: MAIN_COLOR,
                        highlightColor: MAIN_COLOR,
                        borderColor: Colors.black12,
                        borderWidth: 3,
                        selectedBorderColor: MAIN_COLOR,
                        renderBorder: true,
//                                  borderRadius: BorderRadius.only(
//                                      topLeft: Radius.circular(25),
//                                      bottomRight: Radius.circular(25)),disabledColor: Colors.blueGrey,
                        disabledBorderColor: Colors.blueGrey,
                        focusColor: Colors.red,
                        focusNodes: focusToggle,
                        children: <Widget>[
                          Text('4',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black)),
                          Text('6',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black)),
                          Text('8',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black))
                        ],
                        isSelected: isSelected,
                        onPressed: (int index) {
//                          setState(() {
                          for (int indexBtn = 0;
                              indexBtn < isSelected.length;
                              indexBtn++) {
                            if (indexBtn == index) {
                              isSelected[indexBtn] = true;
                            } else {
                              isSelected[indexBtn] = false;
                            }
                          }
//                          });
                          print('Isselected = $index');
                          print(' value = ${isSelectedValue[index]}');
                          _nbdigitOPT = isSelectedValue[index];
                          setState(() {
                            _redrawotpfield = !_redrawotpfield;
                          });
                          _globalvariables.setOTPDigitnum(_nbdigitOPT);
//                          _globalvariables.setotprequired(false);
//                          _globalvariables.setotprequired(true);
//                         _globalvariables.setotprequired(true);
//                          _globalvariables.setotprequired(false);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Enter OTP:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      PinEntryTextFieldCustom(
                        fields: _globalvariables.OTPDigitnum,
                        isTextObscure: true,
                        showFieldAsBox: false,
                        onSubmit: (String otp) async {
                          var _otp = otp;
                          var _result = await sendOTP(_otp, _reference);
                          if (_result['success'] == false ||
                              _result['success'] == null) {
                            print('PAyment has failed due to $_result');
                            _globalvariables.errorMessage = _result['message'];
                            // TODO Display message
                          }
//        _globalVariables.setotprequired(false);
                          print('result Paystack = $_result');
                          // TODO increase Fund wallet
//                          Navigator.pushReplacementNamed(context, '/home');
                        }, // end onSubmit
                      )
                    ],
                  ), // end Padding()
                ),
              )
            : Container(),
        _globalvariables.successfulltransaction == true
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          '\nTransaction Successfull\n\n Ref: ${_globalvariables.transactionid}',
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              height: 1.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFFD97A00),
                          size: 140,
                        ),
                        Text(
                          "The Amount of ${_globalvariables.amountpaid - _globalvariables.fees} has been added to your Wallet - Fees = ${_globalvariables.fees}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              height: 1.0,
                              fontWeight: FontWeight.bold),
                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text(
//                            "If you want to check detailled of this transaction please click Here",
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                fontSize: 20.0,
//                                color: Colors.black,
//                                height: 1.0,
//                                fontWeight: FontWeight.bold),
//                          ),
//                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(00.0, 40.0, 00.0, 5.0),
                          child: SizedBox(
                            height: 66.0,
                            width: 190,
                            child: RaisedButton(
                              elevation: 5.0,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(33.0),
                              ),
                              color: Color(0xFFD97A00),
                              disabledColor: Colors.grey,
                              child: new Text('OK',
                                  style: new TextStyle(
                                      fontSize: 23.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                _globalvariables
                                    .setsuccessfulltransaction(false);
                                // increase balance;
                                db
                                    .collection('users')
                                    .where('userid', isEqualTo: userId)
                                    .getDocuments()
                                    .then((querySnapshot) {
                                  querySnapshot.documents
                                      .forEach((documentSnapshot) {
                                    documentSnapshot.reference.updateData({
                                      "balance": FieldValue.increment(
                                          _globalvariables.amountpaid -
                                              _globalvariables.fees)
                                    });
                                  });
                                  _errorMessage = "Payment Successfull";
                                }).catchError((e) {
                                  print("update user balamce in users: $e");
                                  _errorMessage = e;
                                });
//                                var userRef = await db
//                                    .collection('users')
//                                    .where('userid', isEqualTo: userId)
//                                    .snapshots()
//                                    .first
//                                    .updateData((doc) {});
//                                print('Snapshot = $userRef');
                                // Atomically increment the balance by the amount charged - Fees.
//                                userRef.map((doc) {doc.data.documents[0].data['name']({"balance": FieldValue.increment(XX)});
                              },
                            ),
                          ),
                        ),
                      ]),
                ),
              )
            : Container(), // end Container()
      ]);
    }

    return new Scaffold(
        body: GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Stack(
        children: <Widget>[
          _showForm(context),
          showCircularProgress(_globalvariables.isLoading),
        ],
      ),
    ));
  }
}

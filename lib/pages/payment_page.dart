import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_paul_test/models/chargeobjectmodel.dart';
import 'package:flutter_app_paul_test/pages/account_created_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/input_formatters.dart';
import 'package:flutter_app_paul_test/services/payment_card.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _errorMessage;
  bool _isLoading;
  var _paymentCard = PaymentCard();
  final TextEditingController _cardnumcontrol = TextEditingController();
  final TextEditingController _cardnumcontrolAmount = TextEditingController();

  final _formKeypay = new GlobalKey<FormState>();
  var _sourceofFund = 'Debit Card';
  FirebaseUser currentuser;
  String userId;
  bool _autoValidate = false;

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

  Future<String> PaywithPaystack(url, headerData, bodydata) async {
    var bodyjson = json.encode(bodydata);
    await http
        .post(Uri.parse(url),
            headers: headerData,
            body: bodyjson,
            encoding: Encoding.getByName("utf-8"))
        .then((result) {
      if (result.statusCode == 200) {
        return (result.body);
      } else {
        return result.statusCode;
      }
    }).catchError((e) => print('Error $e'));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _pass = TextEditingController();
    final TextEditingController _confirmPass = TextEditingController();
    final Firestore db = Provider.of<Firestore>(context, listen: false);

    String _cardtypeselected;

//    String _cardnumber = '';
//    String _expiryDate = '';
//    String _cvv = '';
    String _amount = '';
//    String _PIN = '';

    Future<String> Charge() async {
//Payment Charge using http POST request
      final String url = 'https://api.paystack.co/charge';
      String _tollid = '';
      String _email = '';
      String _name = '';
//      String p = 'Bearer $vAuthToken';
      String Authorization =
          'Bearer sk_test_fd4de30832bc5641ba1ef6467f93cdc3e6d68b9b';

      final Map<String, String> headerData = {
        "Content-Type": "application/json",
        'Authorization': Authorization
      };
      await db
          .collection("users")
          .where('userid', isEqualTo: userId)
          .getDocuments()
          .then((result) {
        _email = result.documents[0].data['email'];
        _tollid = result.documents[0].data['tollid'];
        _name = result.documents[0].data['name'];

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
        bodydata.pin = _paymentCard.pin;
        var resultpaystack =
            PaywithPaystack(url, headerData, bodydata.toJson());
        return resultpaystack;
      }).catchError((e) {
        print('Error in Charge object : $e');
      });
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
        _isLoading = true;
        try {
//          userId = await auth.signInWithEmailAndPassword(_email, _password);
          print('Form Valid!');
          _isLoading = false;
          _validated = true;
        } catch (e) {
          print('Error: $e');
          _isLoading = false;
          setState(() {
            _errorMessage = e.message;
          });

//        _formKey.currentState.reset();
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

//  void resetForm() {
//    _formKeypay.currentState.reset();
//    _errorMessage = "";
//  }
//
//  void toggleFormMode() {
//    resetForm();
//  }

    Widget _showCircularProgress() {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
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
      //  onPressed: () {});
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
            padding: const EdgeInsets.fromLTRB(50.0, 1.0, 50.0, 0.0),
            child: DropdownButtonFormField<String>(
//              maxLines: 1,
//              keyboardType: TextInputType.text,
//              autofocus: false,
              value: _sourceofFund,
              items: [
                DropdownMenuItem(
                    value: "Debit Card", child: Text("Debit Card")),
                DropdownMenuItem(
                    value: "Bank Account", child: Text("Bank Account"))
              ],
//              CardType.map((String type) {
//                return DropdownMenuItem<String>(value: type, child: Text(type));
//              }).toList(),
              onChanged: (String newValue) {
                print("value : $newValue");
                setState(() {
                  _sourceofFund = newValue;
                });
              },
              decoration: new InputDecoration(
                filled: true,
                fillColor: Color(0xFFE8E8E8),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                labelText: 'Debit Card',
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
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
              ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
//              validator: validateFundingSource,
//        inputFormatters: [
//          BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
//        ],
//              onSaved: (value) => _sourceofFund = value.trim(),
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
              autofocus: false,
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
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
              ),
              controller: _cardnumcontrol,
              validator: CardUtils.validateCardNum,
//              validator: validateCardNumber,
//              inputFormatters: [
//                BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
//              ],
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter(),
//                MaskTextInputFormatter(
//                    mask: '####-####-####-####',
//                    filter: {"#": RegExp(r'[0-9]')})
              ],
              onSaved: (String value) {
                print('onSaved = $value');
                print('Num controller has = ${_cardnumcontrol.text}');
                _paymentCard.number = CardUtils.getCleanedNumber(value);
              },

//              onSaved: (value) => _cardnumber = value.trim(),
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
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
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
//            validator: validateExpiryDate,
//            inputFormatters: [
//              BlacklistingTextInputFormatter(new RegExp(r"\s  \b|\b\s"))
//            ],
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              new LengthLimitingTextInputFormatter(4),
              new CardMonthInputFormatter()
//              MaskTextInputFormatter(
//                  mask: '##/##', filter: {"#": RegExp(r"^\d{2}\/\d{2}$")})
            ],
            onSaved: (value) {
              List<String> expiryDate = CardUtils.getExpiryDate(value);
              _paymentCard.month = expiryDate[0];
              _paymentCard.year = expiryDate[1];
            },
//            onSaved: (value) => _expiryDate = value.trim(),
          ),
        ),
      );
    }

    Widget showCVVInput() {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 50.0, 0.0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
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
                  color: Colors.grey),
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
            ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
//            validator: validateCVV,
            validator: CardUtils.validateCVV,
//            inputFormatters: [
//              BlacklistingTextInputFormatter(new RegExp(r"\s  \b|\b\s"))
//            ],
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              new LengthLimitingTextInputFormatter(3),
//              MaskTextInputFormatter(
//                  mask: '###', filter: {"#": RegExp(r'[0-9]')})
            ],
            onSaved: (value) {
              _paymentCard.cvv = value;
            },
//            onSaved: (value) => _cvv = value.trim(),
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
          autofocus: false,
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
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
          ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          controller: _cardnumcontrolAmount,
//          validator: validateAmount,
          validator: CardUtils.validateAmount,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(8),
            CurrencyPtBrInputFormatter()
          ],
//          inputFormatters: [
//            BlacklistingTextInputFormatter(new RegExp(r"\s  \b|\b\s"))
//          ],
          onSaved: (value) {
            _amount = CardUtils.getCleanedNumber(value);
          },
//          onSaved: (value) {
//            _amount = Paymvalue;
//          },
////          onSaved: (value) => _amount = value,
        ),
      );
    }

    Widget showPINInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
        child: new TextFormField(
          controller: _pass,
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
            filled: true,
            fillColor: Color(0xFFE8E8E8),
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            labelText: 'Enter PIN',
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
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          ),
          ),
//        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
//        validator: validatePIN,
          validator: validatePIN,
//          inputFormatters: [
//            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
//          ],
          inputFormatters: [
            MaskTextInputFormatter(
                mask: '####', filter: {"#": RegExp(r'[0-9]')})
          ],
//          onSaved: (value) => _PIN = value.trim(),
          onSaved: (value) {
            _paymentCard.pin = value;
          },
        ),
      );
    }

    Widget showPAYButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 5.0),
          child: SizedBox(
            height: 66.0,
            child: RaisedButton(
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
//                FocusScope.of(context).unfocus();
                if (await validateAndSubmitPay() == true) {
                  var result = await Charge();
                  print('result Paystack = $result');
                  Navigator.pushNamed(context, '/home');
                }
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
      return new Container(
          child: new Form(
        key: _formKeypay,
        autovalidate: _autoValidate,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 20),
            showExplanation(),
            SizedBox(height: 25),
            showFundingSourceInput(),
            showCardNumberInput(),
            Row(children: [showExpiryDateInput(), showCVVInput()]),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(height: 6.0, color: Color(0xFFDCDCDC)),
            ),
            showAmountInput(),
            showPINInput(),
            showPAYButton(),
            showErrorMessage(),
          ],
        ),
      ));
    }

    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Flutter login demo'),
//        ),
        body: Stack(
      children: <Widget>[
        _showForm(context),
        _showCircularProgress(),
      ],
    ));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/pin_entry_text_custom.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_paul_test/pages/payment_page.dart';

class showOtpFields extends StatefulWidget {
  int nbdigitOPT;
  String reference;
  showOtpFields(this.nbdigitOPT, this.reference);
  @override
  _showOtpFieldsState createState() => _showOtpFieldsState();
}

class _showOtpFieldsState extends State<showOtpFields> {
  get http => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerVariables _globalVariables =
        Provider.of<providerVariables>(context, listen: true);

//    _globalVariables.setotprequired(true);
  }
}

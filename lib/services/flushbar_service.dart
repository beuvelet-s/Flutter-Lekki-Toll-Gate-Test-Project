import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

normalflushbar({BuildContext context, message, duration}) {
  Flushbar(
    icon: new Icon(Icons.info, color: Colors.white, size: 35),
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    messageText: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            right: 0,
            top: -50,
            child: Container(
                height: 50,
                width: 50,
                child: Center(child: Image.asset('assets/logoLCCLekki.png')))),
      ],
      overflow: Overflow.visible,
    ),
    duration: Duration(seconds: duration),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.GROUNDED,
  )..show(context);
}

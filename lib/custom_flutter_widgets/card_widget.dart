import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final String name;
  final String cardnum;
  final String expiry;
  final String cvv;
  final String pathimage;

  const CardWidget(
      {Key key,
      @required this.name,
      @required this.cardnum,
      @required this.expiry,
      @required this.cvv,
      @required this.pathimage});

  @override
  Widget build(BuildContext context) {
    final providerVariables _providerVariables =
        Provider.of<providerVariables>(context, listen: true);

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          alignment: Alignment(-1, -1),
          height: _providerVariables.Screenheight / 3,
          child: Center(child: Image.asset(pathimage)),
        ),
        Positioned(
          top: _providerVariables.Screenheight / 3 * 0.88,
          left: 25,
          child: _buildName(
              _providerVariables.Screenwidth, _providerVariables.Screenheight),
        ),
        Positioned(
          top: _providerVariables.Screenheight / 3 * 0.77,
          left: 140,
          child: _buildExpiry(
              _providerVariables.Screenwidth, _providerVariables.Screenheight),
        ),
        Positioned(
          top: _providerVariables.Screenheight / 3 * 0.55,
          left: 25,
          child: _buildCardNumber(
              _providerVariables.Screenwidth, _providerVariables.Screenheight),
        )
      ],
    );
  }

//  _buildTitle() => Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                'D E B I T',
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 11,
//                    fontWeight: FontWeight.w200),
//              ),
//            ],
//          ),
//          customYMargin(35),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                '$amount',
//                style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 27,
//                    fontFamily: 'Roboto',
//                    fontWeight: FontWeight.w400),
//              ),
//            ],
//          ),
//          customYMargin(40),
//        ],
//      );

  _buildName(screenwidth, screenheight) => SizedBox(
        width: screenwidth * 0.58,
        height: screenheight * 0.05,
        child: AutoSizeText(
          '$name',
          maxLines: 1,
          style: TextStyle(
              fontFamily: "OPTIKorinnaExtraBoldAgency",
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      );

  _buildExpiry(screenwidth, screenheight) => SizedBox(
        width: screenwidth * 0.55,
        height: screenheight * 0.05,
        child: AutoSizeText(
          '$expiry',
          maxLines: 1,
          style: TextStyle(
              fontFamily: "OPTIKorinnaExtraBoldAgency",
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
      );
  _buildCardNumber(screenwidth, screenheight) => SizedBox(
        width: screenwidth * 0.58,
        height: screenheight * 0.05,
        child: AutoSizeText(
          '$cardnum',
          maxLines: 1,
          style: TextStyle(
              fontFamily: "OPTIKorinnaExtraBoldAgency",
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600),
        ),
      );
}

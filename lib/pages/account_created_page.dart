import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';

class AccountCreatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Account created successfully',
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
                "Verify your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    height: 1.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "A Link to verify account has been sent to your email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    height: 1.0,
                    fontWeight: FontWeight.bold),
              ),
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
                      child: new Text('Sign In',
                          style: new TextStyle(
                              fontSize: 23.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
//                        Navigator.pushNamed(context, '/login');
                        Navigator.of(context).pop();
                      },
                    ),
                  )),
            ]),
      ),
    );
  }
}

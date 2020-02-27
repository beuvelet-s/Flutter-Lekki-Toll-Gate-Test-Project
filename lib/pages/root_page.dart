import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/account_created_page.dart';
import 'package:flutter_app_paul_test/pages/login_page.dart';
import 'package:flutter_app_paul_test/services/auth_provider.dar.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:provider/provider.dart';

//enum AuthStatus {
//  NOT_DETERMINED,
//  NOT_LOGGED_IN,
//  LOGGED_IN,
//}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<FirebaseUser>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if ((snapshot.hasData && snapshot.data.isEmailVerified)) {
            //&& (auth.isEmailVerified() == true
//            FirebaseUser user = snapshot.data;
            return HomePage();
            //           return HomePage();
          } else {
            // logged in using other providers
            return LoginPage();
          }
        }
        return buildWaitingScreen();
      },
    );
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

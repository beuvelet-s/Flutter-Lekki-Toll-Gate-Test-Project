import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/account_created_page.dart';
import 'package:flutter_app_paul_test/pages/addvehicle_page.dart';
import 'package:flutter_app_paul_test/pages/forgotpassword_page.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:flutter_app_paul_test/pages/login_page.dart';
import 'package:flutter_app_paul_test/pages/payment_page.dart';
import 'package:flutter_app_paul_test/pages/profile_page.dart';
import 'package:flutter_app_paul_test/pages/root_page.dart';
import 'package:flutter_app_paul_test/pages/signup_page.dart';
import 'package:flutter_app_paul_test/pages/splashscreen_page.dart';
import 'package:flutter_app_paul_test/pages/userprofile_page.dart';
import 'package:flutter_app_paul_test/services/picture_scanner.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
//          Provider<AuthService>(
//            create: (_) => AuthServiceAdapter(),
//            dispose: (_, AuthService authService) => authService.dispose(),
//          ),
          Provider<AuthService>(
            create: (_) => AuthService(),
//            dispose: (_, AuthService authService) => authService.dispose(),
          ),
          Provider<Firestore>(create: (_) => Firestore.instance
//            dispose: (_, AuthService authService) => authService.dispose(),
              ),
          ChangeNotifierProvider<providerVariables>(
            create: (_) => providerVariables(),
          )
        ],
        child: MaterialApp(
          title: 'LCC Lekki App',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => SplashScreen(),
            '/root': (context) => RootPage(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/login': (context) => LoginPage(),
            '/accountcreated': (context) => AccountCreatedPage(),
            '/home': (context) => HomePage(),
            '/pay': (context) => PaymentPage(),
            '/signup': (context) => SignupPage(),
            '/forgotpassword': (context) => ForgotPasswordPage(),
            '/addvehicle': (context) => AddVehicle(),
            '/PictureScanner': (context) => PictureScanner(),
            '/profile': (context) => UserProfilePage()
          },
          theme: new ThemeData(
//              appBarTheme: AppBarTheme(
//                  elevation: 0, // This removes the shadow from all App Bars.
//                  backgroundColor: Colors.transparent,
//                  bottomOpacity: 0.0),
            primarySwatch: Colors.blue,
            accentColor: MAIN_COLOR,
//            inputDecorationTheme: InputDecorationTheme(
//              labelStyle: TextStyle(color: MAIN_COLOR, fontSize: 24.0),
//            ),
          ),
//        home: SplashScreen()
        ));
  }
}

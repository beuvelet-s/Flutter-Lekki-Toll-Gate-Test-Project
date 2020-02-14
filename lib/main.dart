import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/splashscreen_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen()
        // new RootPage(auth: new Auth()));
        );
  }
}

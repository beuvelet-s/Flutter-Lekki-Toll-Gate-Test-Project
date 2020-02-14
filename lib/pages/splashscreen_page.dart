import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/root_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';

//void main() => runApp(HeroApp());
//
//class HeroApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Transition Demo',
//      home: SplashScreen(),
//    );
//  }
//}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Main Screen'),
//      ),
      body: GestureDetector(
        child: Hero(
          tag: 'imageHero',
          child: Center(child: Image.asset('assets/logoLCCLekki.png')),
          //Image.network('https://picsum.photos/250?image=9',
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return RootPage(auth: new Auth());
          }));
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.asset('assets/logoLCCLekki.png'),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

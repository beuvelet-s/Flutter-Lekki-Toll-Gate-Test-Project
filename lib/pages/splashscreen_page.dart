import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/circularwidget.dart';
import 'package:flutter_app_paul_test/pages/root_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/animatedMaterialPageRoute.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:provider/provider.dart';

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
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: true);

    return Scaffold(
//      appBar: AppBar(
//        title: Text('Main Screen'),
//      ),
      body: Stack(children: <Widget>[
        GestureDetector(
            child: Hero(
              tag: 'imageHero',
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                final Hero toHero = toHeroContext.widget;
                return RotationTransition(
                  turns: animation,
                  child: toHero.child,
                );
              },
              child: Center(child: Image.asset('assets/logoLCCLekki.png')),
              //Image.network('https://picsum.photos/250?image=9',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/root');
              _globalvariables.setisLoading(true);
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (_) => RootPage(),
//              ),
//            );
//                AnimatedMaterialPageRoute(
//                page: RootPage(
//                    auth: new Auth(),
//                  ),
//                ),
            }),
        _globalvariables.isLoading ? showCircularProgress(true) : Container(),
      ]),
    );
  }
}

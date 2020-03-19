import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/circularwidget.dart';
import 'package:flutter_app_paul_test/pages/root_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/custom_flutter_widgets/animatedMaterialPageRoute.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:provider/provider.dart';

// #docregion ShakeCurve
import 'dart:math';

// #enddocregion ShakeCurve
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

//void main() => runApp(LogoApp());

// #docregion diff
class AnimatedLogo extends AnimatedWidget {
  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          child: Image.asset('assets/logoLCCLekki.png'),
        ),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    // #docregion AnimationController, tweens
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // #enddocregion AnimationController, tweens
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
// #enddocregion diff

// Extra code used only in the tutorial explanations. It is not used by the app.

class UsedInTutorialTextOnly extends _LogoAppState {
  UsedInTutorialTextOnly() {
    // ignore: unused_local_variable
    var animation, sizeAnimation, opacityAnimation, tween, colorTween;

    // #docregion CurvedAnimation
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // #enddocregion CurvedAnimation

    // #docregion tweens
    sizeAnimation = Tween<double>(begin: 0, end: 300).animate(controller);
    opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(controller);
    // #enddocregion tweens

    // #docregion tween
    tween = Tween<double>(begin: -200, end: 0);
    // #enddocregion tween

    // #docregion colorTween
    colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54);
    // #enddocregion colorTween
  }

  usedInTutorialOnly1() {
    // #docregion IntTween
    AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
    // #enddocregion IntTween
    return alpha;
  }

  usedInTutorialOnly2() {
    // #docregion IntTween-curve
    AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
    // #enddocregion IntTween-curve
    return alpha;
  }
}

// #docregion ShakeCurve
class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}

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
//              child: Center(child: Image.asset('assets/logoLCCLekki.png')),
              child: LogoApp(),
              //Image.network('https://picsum.photos/250?image=9',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/root');
//              _globalvariables.setisLoading(true);
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

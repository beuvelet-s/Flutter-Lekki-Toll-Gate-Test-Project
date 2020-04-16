import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/dashboard_page.dart';
import 'package:flutter_app_paul_test/pages/payment_page.dart';
import 'package:flutter_app_paul_test/pages/profile_page.dart';
import 'package:flutter_app_paul_test/pages/qrcodescanning_page.dart';
import 'package:flutter_app_paul_test/pages/userprofile_page.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
//import 'package:liquid_swipe/Constants/Helpers.dart';
//import 'package:liquid_swipe/liquid_swipe.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../my_flutter_app_icons.dart';

class HomePage extends StatefulWidget {
//  int selectedIndex;
//  HomePage(this.selectedIndex);

//  setindex(int newindex) {
//    this.selectedIndex = newindex;
//  }
//  var keyLiquid = new GlobalKey<LiquidSwipeState>();

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentuser;
  String userId;
  String user_name;
  GlobalKey bottomNavigationKey = GlobalKey();
//  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getThingsonStartUp().then((result) {
      print('initialisation de userID');
    });
  }

  Future<void> getThingsonStartUp() async {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);
    currentuser = await auth.getCurrentUser();
    userId = currentuser.uid;
    _globalvariables.setuserId(userId);
    user_name = currentuser.displayName;
    normalflushbar(
        context: context,
        message: 'Welcome Back ${user_name.split(" ")[0]} !',
        duration: 3);
    // Load tariffs
    await db.collection('tariffs').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) async {
        _globalvariables.addtariffs(documentSnapshot.data['vehicle_class'],
            documentSnapshot.data['toll_tariff']);
      });
    }).catchError((e) {
      print("error trying to read secret db: $e");
      _globalvariables.seterrorMessage(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final providerVariables _globalVariables =
        Provider.of<providerVariables>(context, listen: true);

//    PageController pageController = PageController(
//      initialPage: _globalVariables.selecteditem,
//      keepPage: true,
//    );

    Widget buildPageView() {
      return PageView(
        key: bottomNavigationKey,
        controller: _globalVariables.pageController,
        onPageChanged: (index) {
          //         pageChanged(index);
          _globalVariables.setselecteditem(index);
        },
        children: <Widget>[
          PaymentPage(),
          DashboardPage(),
          QRCodePage(),
          UserProfilePage(),
          UserProfilePage2(),
        ],
        pageSnapping: true,
        physics: BouncingScrollPhysics(),
      );
    }

//
//    final List<Container> _Pages = [
//      Container(child: DashboardPage()),
////  MessagePage();
//      Container(child: PaymentPage()),
//      Container(child: QRCodePage()),
////  UserPAge(),
//    ];

    void signOut() async {
      try {
        await auth.signOut();
        Navigator.pushNamed(context, '/login');
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
                height: 65,
                width: 65,
                child: Image.asset('assets/logoLCCLekki.png')),
          ),
          leading: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.sort, size: 40, color: Color(0xFFD97A00)),
            ),
          ),
//        expandedHeight: 400,
//        floating: true,
//        pinned: true,
//        snap: true,
          actions: <Widget>[
            FlatButton(
                hoverColor: Color(0xFFD97A00),
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.black)),
                onPressed: signOut)
          ]),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBackgroundColor: Color(0xFFEBD8BF),
          selectedItemIconColor: Colors.black,
          selectedItemLabelColor: Colors.black,
          selectedItemBorderColor: Color(0xFFEBD8BF),
        ),
        selectedIndex: _globalVariables.selecteditem,
        onSelectTab: (index) {
//          setState(() {
//          _globalVariables.clearVehicle_image();
          _globalVariables.setselecteditem(index);
          _globalVariables.pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
          );
//          // modify liquid_swipe object internal properties
//          widget.keyLiquid.currentState.nextPageIndex = index;
//          widget.keyLiquid.currentState.slidePercentHor = 1;
//            _Pages[index];
//          });
        },
//            (index) {
//          setState(() {
//            _selectedIndex = index;
//          })
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          FFNavigationBarItem(
            iconData: Icons.credit_card,
            label: 'Fund',
          ),
          FFNavigationBarItem(
            iconData: MyCustomIcon.qrcode,
            label: 'PAY',
          ),
          FFNavigationBarItem(
            iconData: Icons.account_circle,
            label: 'User',
          ),
          FFNavigationBarItem(
            iconData: Icons.message,
            label: 'Settings',
          )
        ],
      ),
      body: Stack(children: <Widget>[
        buildPageView(),
//        _Pages[_globalVariables.selecteditem],
//        LiquidSwipe(
//          key: widget.keyLiquid,
//          pages: _Pages,
////          initialPage: _globalVariables.selecteditem,
//          fullTransitionValue: 300,
//          enableLoop: true,
//          enableSlideIcon: true,
//          waveType: WaveType.circularReveal,
//          currentUpdateTypeCallback: (item) {
//            print('item = $item');
//            print(
//                'globalVariables.selecteditem ici = ${_globalVariables.selecteditem}');
//            if (item != _globalVariables.selecteditem) {
//              print('item = $item');
//            }
//          },
//          onPageChangeCallback: (pagenum) {
////            setState(() {
//            _globalVariables.setselecteditem(pagenum);
//            print('pagenum = $pagenum');
//
////              _globalVariables.selecteditem = pagenum;
////            });
//          },
//        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 5.0,
            color: Color(0xFFEBD8BF),
          ),
        )
      ]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/dashboard_page.dart';
import 'package:flutter_app_paul_test/pages/payment_page.dart';
import 'package:flutter_app_paul_test/pages/qrcodescanning_page.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';

import '../my_flutter_app_icons.dart';

class HomePage extends StatefulWidget {
//  int selectedIndex;
//  HomePage(this.selectedIndex);

//  setindex(int newindex) {
//    this.selectedIndex = newindex;
//  }

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentuser;
  String userId;
  String user_name;
//  static GlobalKey _bottomNavigationKey =
//      new GlobalKey(debugLabel: 'btm_app_bar');

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
    currentuser = await auth.getCurrentUser();
    userId = currentuser.uid;
    user_name = currentuser.displayName;
    normalflushbar(
        context: context,
        message: 'Welcome Back ${user_name.split(" ")[0]} !',
        duration: 3);
  }

  @override
  Widget build(BuildContext context) {
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final providerVariables _indexbottomAppBar =
        Provider.of<providerVariables>(context, listen: true);

    final List<Widget> _Pages = [
      DashboardPage(),
//  MessagePage();
      PaymentPage(),
      QRCodePage(),
//  UserPAge(),
    ];

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
//        key: _bottomNavigationKey,
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBackgroundColor: Color(0xFFEBD8BF),
          selectedItemIconColor: Colors.black,
          selectedItemLabelColor: Colors.black,
          selectedItemBorderColor: Color(0xFFEBD8BF),
        ),
        selectedIndex: _indexbottomAppBar.selecteditem,
        onSelectTab: (index) {
          setState(() {
            _indexbottomAppBar.selecteditem = index;
          });
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
            iconData: Icons.message,
            label: 'Settings',
          ),
          FFNavigationBarItem(
            iconData: Icons.account_circle,
            label: 'User',
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        _Pages[_indexbottomAppBar.selecteditem],
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

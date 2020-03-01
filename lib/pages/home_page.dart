import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/login_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_paul_test/models/todo.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
//  HomePage({Key key, this.currentuser, this.userId}) : super(key: key);
//
//  final FirebaseUser currentuser;

//      {Key key, this.auth, this.userId, this.logoutCallback, this.currentuser})
//      : super(key: key);
//  final BaseAuth auth;
//  final VoidCallback logoutCallback;
//  final String userId;
//  final FirebaseUser currentuser;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentuser;
  String userId;
  String user_name;

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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
//    final AuthService current =
//        Provider.of<CurrentUser>(context, listen: false);

    void signOut() async {
      try {
        await auth.signOut();
        Navigator.pushNamed(context, '/login');
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBackgroundColor: Color(0xFFEBD8BF),
          selectedItemIconColor: Colors.black,
          selectedItemLabelColor: Colors.black,
          selectedItemBorderColor: Color(0xFFEBD8BF),
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          print('index = $index');
          setState(() {
            selectedIndex = index;
            if (selectedIndex == 1) {
              print("tab 1");
            }
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          FFNavigationBarItem(
            iconData: Icons.message,
            label: 'Message',
          ),
          FFNavigationBarItem(
            iconData: Icons.settings,
            label: 'Settings',
          ),
          FFNavigationBarItem(
            iconData: Icons.account_circle,
            label: 'User',
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          WillPopScope(
            // ignore: missing_return
            onWillPop: () async {
              Future.value(false);
            },
            child: SafeArea(
              child: Material(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
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
                            child: Icon(Icons.sort,
                                size: 40, color: Color(0xFFD97A00)),
                          ),
                        ),
                        expandedHeight: 400,
                        floating: true,
                        pinned: true,
                        snap: true,
                        elevation: 50,
                        backgroundColor: Colors.white,
                        actions: <Widget>[
                          FlatButton(
                              hoverColor: Color(0xFFD97A00),
                              child: new Text('Logout',
                                  style: new TextStyle(
                                      fontSize: 17.0, color: Colors.black)),
                              onPressed: signOut)
                        ],
                        flexibleSpace: StreamBuilder(
                            stream: db
                                .collection('users')
                                .where('userid', isEqualTo: userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Text("Loading...");
                              return FlexibleSpaceBar(
                                background: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 60),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 20, 0, 0),
                                        child: Text(
                                            // Find Name in Firebase Auth current user Object
                                            'Hello ${snapshot.data.documents[0].data['name']}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 0, 0, 0),
                                        child: Text('Good morning.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(height: 30),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 0, 12, 0),
                                        child: Container(
                                          height: 100,
                                          color: Color(0xFFEBD8BF),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        12.0, 8, 0, 0),
                                                    child: Text(
                                                        'Toll ID: ${snapshot.data.documents[0].data['tollid']}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        12.0, 8, 0, 0),
                                                    child: Text(
                                                        'Your Wallet balance',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        12.0, 8, 0, 0),
                                                    child: Text(
                                                        'N${NumberFormat("#,###.#").format(snapshot.data.documents[0].data['balance']).toString()}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 23,
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 30, 0),
                                                    child: Text('',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 30, 0),
                                                    child: Text(
                                                        'Number of vehicles: ${snapshot.data.documents[0].data['nbofvehicles'].toString()}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 30, 0),
                                                    child: RaisedButton(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  12.0)),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context, '/pay');
                                                      },
                                                      child: Text('Fund Wallet',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                          height: 6.0,
                                          color: Color(0xFFEBD8BF)),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                              height: 100,
                                              width: 100,
                                              color: Color(0xFFEBD8BF),
                                              child: Image.asset(
                                                  'assets/addremovevehicle.PNG')),
                                          Container(
                                              height: 100,
                                              width: 100,
                                              color: Color(0xFFEBD8BF),
                                              child: Image.asset(
                                                  'assets/requesttolldevice.PNG')),
                                          Container(
                                              height: 100,
                                              width: 100,
                                              color: Color(0xFFEBD8BF),
                                              child: Image.asset(
                                                  'assets/viewpassage.PNG')),
                                        ],
                                      )
                                    ]),
                              );
                            })
//                    MySliverAppBar(),
                        ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 6.0, color: Color(0xFFDCDCDC)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                            child: Text(
                              'My Vehicles',
                            ),
                          )
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: db.collection('vehicles').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return SliverList(
                              delegate: new SliverChildListDelegate(
                                snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(document['type'] +
                                            ' - ' +
                                            document['immatriculation']),
                                        Text(document['category'] +
                                            ': ' +
                                            document['costperpassage']
                                                .toString() +
                                            '/passage'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return SliverToBoxAdapter(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text('Error: ${snapshot.error}')));
                          } else
                            return SliverToBoxAdapter(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text('Loading....')));
                        }),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 6.0, color: Color(0xFFDCDCDC)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
                            child: Text(
                              'My Recent Passages',
                            ),
                          )
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: db.collection('passages').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return SliverToBoxAdapter(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text('Error: ${snapshot.error}')));
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SliverToBoxAdapter(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text('Loading....')));
                            default:
                              return SliverList(
                                delegate: new SliverChildListDelegate(
                                  snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24, 0, 0, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(document['type'] +
                                              ' - ' +
                                              document['immatriculation'] +
                                              ' - ' +
                                              DateFormat('dd/MM/yy h:mma')
                                                  .format(
                                                      document['date'].toDate())
                                                  .toString()),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 5.0,
              color: Color(0xFFEBD8BF),
            ),
          )
        ],
      ),
    );
  }
}

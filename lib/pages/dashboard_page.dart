import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:flutter_app_paul_test/pages/login_page.dart';
import 'package:flutter_app_paul_test/pages/payment_page.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_paul_test/models/todo.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:flutter_app_paul_test/models/vehicle_model.dart';
import 'addvehicle_page.dart';

class DashboardPage extends StatefulWidget {
//  final GlobalKey bottomNavigationKey;
//  DashboardPage({Key key, this.bottomNavigationKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  FirebaseUser currentuser;
  String userId;
  String user_name;
  var _theList = ["1", "2", "3"];
  int _vehiclenb = 0;

  @override
  void initState() {
    super.initState();
    getThingsonStartUp().then((result) {
      print('initialisation de userID');
    });
  }

  Future<void> getThingsonStartUp() async {}

  @override
  Widget build(BuildContext context) {
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final providerVariables _providerVariables =
        Provider.of<providerVariables>(context, listen: true);
    userId = _providerVariables.userId;
//    auth.getCurrentUser().then((currentuser) {
//      userId = currentuser.uid;
//      print("userId = $userId");
//      user_name = currentuser.displayName;
//    });

    void signOut() async {
      try {
        await auth.signOut();
        Navigator.pushNamed(context, '/login');
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
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
//                        centerTitle: true,
//                        title: Padding(
//                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                          child: Container(
//                              height: 65,
//                              width: 65,
//                              child: Image.asset('assets/logoLCCLekki.png')),
//                        ),
//                        leading: Container(
//                          child: Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Icon(Icons.sort,
//                                size: 40, color: Color(0xFFD97A00)),
//                          ),
//                        ),
                          expandedHeight: 320,
                          floating: false,
                          pinned: false,
                          snap: false,
                          elevation: 0,
                          backgroundColor: Colors.white,
//                        actions: <Widget>[
//                          FlatButton(
//                              hoverColor: Color(0xFFD97A00),
//                              child: new Text('Logout',
//                                  style: new TextStyle(
//                                      fontSize: 17.0, color: Colors.black)),
//                              onPressed: signOut)
//                        ],
                          flexibleSpace: StreamBuilder(
                              stream: db
                                  .collection('users')
                                  .where('userid', isEqualTo: userId)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return FlexibleSpaceBar(
                                    background: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
//                                      SizedBox(height: 60),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12.0, 10, 0, 0),
                                            child: Text(
                                                // Find Name in Firebase Auth current user Object
                                                'Hello ${snapshot.data.documents[0].data['name']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12.0, 0, 0, 0),
                                            child: Text('Good morning.',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12.0, 0, 12, 0),
                                            child: Container(
                                              height: 100,
                                              color: Color(0xFFEBD8BF),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                12.0, 8, 0, 0),
                                                        child: Text(
                                                            'Toll ID: ${snapshot.data.documents[0].data['tollid']}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                12.0, 8, 0, 0),
                                                        child: Text(
                                                            'Your Wallet balance',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                12.0, 8, 0, 0),
                                                        child: Text(
                                                            '\u20A6 ${NumberFormat("###,###.##").format(snapshot.data.documents[0].data['balance']).toString()}',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontSize: 23,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 8, 30, 0),
                                                        child: Text('',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 8, 30, 0),
                                                        child: Text(
                                                            'Number of vehicles: ${_vehiclenb.toString()}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 30, 0),
                                                        child: RaisedButton(
                                                          color: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      12.0)),
                                                          onPressed: () {
                                                            _providerVariables
                                                                .setselecteditem(
                                                                    1);
                                                            _providerVariables
                                                                .pageController
                                                                .animateToPage(
                                                              1,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      400),
                                                              curve: Curves
                                                                  .fastOutSlowIn,
                                                            );
//                                                          _providerVariables
//                                                              .ChangebottomAppBarindexto(
//                                                                  1);
//                                                        Navigator.pushNamed(
//                                                            context, '/home');
                                                          },
                                                          child: Text(
                                                              'Fund Wallet',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
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
                                              GestureDetector(
                                                onTap: () {
                                                  VehicleModel vehicle_object =
                                                      new VehicleModel(
                                                          nvis_color: "",
                                                          nvis_cartype: "",
                                                          nvis_status: "",
                                                          category: "Class I",
                                                          immatriculation: "",
                                                          userId: "",
                                                          filePath: "",
                                                          picture_file_url: "",
                                                          update: false);
                                                  Navigator.pushNamed(
                                                      context, '/addvehicle',
                                                      arguments:
                                                          vehicle_object);
                                                },
                                                child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    color: Color(0xFFEBD8BF),
                                                    child: Image.asset(
                                                        'assets/addremovevehicle.PNG')),
                                              ),
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
                                } else {
                                  return Text("Loading...");
                                }
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
                          stream: db
                              .collection('vehicles')
                              .where('userId', isEqualTo: userId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              _vehiclenb = snapshot.data.documents.length;
                              return SliverList(
                                delegate: SliverChildListDelegate(
                                  snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                    return Dismissible(
                                        key: new ObjectKey(document),
                                        background: new Container(
                                          color: Colors.red,
                                          child: Align(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  " Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ),
                                        secondaryBackground: new Container(
                                          color: Colors.green,
                                          child: Align(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  " Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
//                                        onDismissed:
//                                            (DismissDirection direction) {},
                                        confirmDismiss: (direction) async {
                                          bool _res;
                                          if (direction ==
                                              DismissDirection.startToEnd) {
                                            _res = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "Are you sure you want to delete $document?"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          // Delete the item from DB etc..
                                                          setState(() {
                                                            db
                                                                .collection(
                                                                    'vehicles')
                                                                .document(document
                                                                    .documentID)
                                                                .delete();
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            // Navigate to edit page;
                                            VehicleModel vehicle_object =
                                                new VehicleModel(
                                                    nvis_color: document
                                                        .data["nvis_color"],
                                                    nvis_cartype: document
                                                        .data["nvis_cartype"],
                                                    nvis_status: document
                                                        .data["nvis_status"],
                                                    category: document
                                                        .data["category"],
                                                    immatriculation:
                                                        document.data[
                                                            "immatriculation"],
                                                    userId:
                                                        document.data["userId"],
                                                    filePath: document
                                                        .data["picture_file"],
                                                    picture_file_url:
                                                        document.data[
                                                            "picture_file_url"],
                                                    update: true);

                                            if (vehicle_object.filePath != "") {
                                              final FirebaseStorage _storage =
                                                  FirebaseStorage(
                                                      storageBucket:
                                                          'gs://paultestlogin.appspot.com');
                                              String filePath =
                                                  vehicle_object.filePath;
                                              final ref = _storage
                                                  .ref()
                                                  .child(filePath);
// no need of the file extension, the name will do fine.
                                              vehicle_object
                                                  .setVehicleurlfilePath(
                                                      await ref
                                                          .getDownloadURL());
//      var _downloadTask = _storage.ref().child(filePath).writeToFile(filePath);
                                            }
                                            Navigator.pushNamed(
                                                context, '/addvehicle',
                                                arguments: vehicle_object);
                                          }
                                          return _res;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 0, 0, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  document
                                                              .data[
                                                          'nvis_cartype'] +
                                                      '  ' +
                                                      document
                                                          .data['nvis_color'] +
                                                      ' - ' +
                                                      document
                                                              .data[
                                                          'immatriculation'] +
                                                      ' - ' +
                                                      document
                                                          .data['category'] +
                                                      ': ' +
                                                      (_providerVariables
                                                                  .tariffs[
                                                              document.data[
                                                                  'category']])
                                                          .toString() +
                                                      " N/pass",
                                                  style:
                                                      TextStyle(fontSize: 15))
                                            ],
                                          ),
                                        ));
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
                          stream: db
                              .collection('passages')
                              .where('userId', isEqualTo: userId)
                              .orderBy('date', descending: true)
                              .snapshots(),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
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
                                                    .format(document['date']
                                                        .toDate())
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
          ],
        ),
      ),
    );
  }
}

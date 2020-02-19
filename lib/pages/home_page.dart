import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_paul_test/models/todo.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key, this.auth, this.userId, this.logoutCallback, this.currentuser})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final FirebaseUser currentuser;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  List<Todo> _todoList;
  List<Vehicle> _vehicleList;
  int selectedIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

//  final FirebaseDatabase _database = FirebaseDatabase.instance;
//  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//  final _textEditingController = TextEditingController();
//  StreamSubscription<Event> _onVehicleAddedSubscription;
//  StreamSubscription<Event> _onVehicleChangedSubscription;
//
//  Query _vehicleQuery;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

//    _vehicleList = new List();
//    _vehicleQuery = _database
//        .reference()
//        .child("vehicles")
//        .orderByChild("userid")
//        .equalTo(widget.userId);
//    _onVehicleAddedSubscription =
//        _vehicleQuery.onChildAdded.listen(onEntryAdded);
//    _onVehicleChangedSubscription =
//        _vehicleQuery.onChildChanged.listen(onEntryChanged);

//    _todoList = new List();
//    _todoQuery = _database
//        .reference()
//        .child("todo")
//        .orderByChild("userId")
//        .equalTo(widget.userId);
//    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
//    _onTodoChangedSubscription =
//        _todoQuery.onChildChanged.listen(onEntryChanged);
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
//  void dispose() {
//    _onVehicleAddedSubscription.cancel();
//    _onVehicleChangedSubscription.cancel();
//    super.dispose();
//  }

//  onEntryChanged(Event event) {
//    var oldEntry = _vehicleList.singleWhere((entry) {
//      return entry.key == event.snapshot.key;
//    });
//
//    setState(() {
//      _vehicleList[_vehicleList.indexOf(oldEntry)] =
//          Vehicle.fromSnapshot(event.snapshot);
//    });
//  }

//  onEntryChanged(Event event) {
//    var oldEntry = _todoList.singleWhere((entry) {
//      return entry.key == event.snapshot.key;
//    });
//
//    setState(() {
//      _todoList[_todoList.indexOf(oldEntry)] =
//          Todo.fromSnapshot(event.snapshot);
//    });
//  }

//  onEntryAdded(Event event) {
//    setState(() {
//      _vehicleList.add(Vehicle.fromSnapshot(event.snapshot));
//    });
//  }

//  onEntryAdded(Event event) {
//    setState(() {
//      _todoList.add(Todo.fromSnapshot(event.snapshot));
//    });
//  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

//  addNewTodo(String todoItem) {
//    if (todoItem.length > 0) {
//      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
//      _database.reference().child("todo").push().set(todo.toJson());
//    }
//  }
//
//  updateVehicle(Vehicle vehicle) {
//    //Toggle completed
////    vehicle.completed = !vehicle.completed;
//    if (vehicle != null) {
//      _database
//          .reference()
//          .child("vehicles")
//          .child(vehicle.key)
//          .set(vehicle.toJson());
//    }
//  }
//
//  deleteTodo(String todoId, int index) {
//    _database.reference().child("todo").child(todoId).remove().then((_) {
//      print("Delete $todoId successful");
//      setState(() {
//        _todoList.removeAt(index);
//      });
//    });
//  }
//
//  showAddTodoDialog(BuildContext context) async {
//    _textEditingController.clear();
//    await showDialog<String>(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            content: new Row(
//              children: <Widget>[
//                new Expanded(
//                    child: new TextField(
//                  controller: _textEditingController,
//                  autofocus: true,
//                  decoration: new InputDecoration(
//                    labelText: 'Add new todo',
//                  ),
//                ))
//              ],
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                  child: const Text('Cancel'),
//                  onPressed: () {
//                    Navigator.pop(context);
//                  }),
//              new FlatButton(
//                  child: const Text('Save'),
//                  onPressed: () {
//                    addNewTodo(_textEditingController.text.toString());
//                    Navigator.pop(context);
//                  })
//            ],
//          );
//        });
//  }
//
//  Widget showvehicleList() {
//    if (_vehicleList.length > 0) {
//      return ListView.builder(
//          shrinkWrap: true,
//          itemCount: _vehicleList.length,
//          itemBuilder: (BuildContext context, int index) {
//            String key = _vehicleList[index].key;
//            String category = _vehicleList[index].category;
//            int costperpassage = _vehicleList[index].costperpassage;
//            String immatriculation = _vehicleList[index].immatriculation;
//            String type = _vehicleList[index].type;
//            String userid = _vehicleList[index].userid;
//
//            return Dismissible(
//              key: Key(key),
//              background: Container(color: Colors.red),
//              onDismissed: (direction) async {
//                deleteTodo(key, index);
//              },
//              child: ListTile(
//                title: Text(
//                  'subject',
//                  style: TextStyle(fontSize: 20.0),
//                ),
//                trailing: IconButton(
//                    icon: (true) //completed
//                        ? Icon(
//                            Icons.done_outline,
//                            color: Colors.green,
//                            size: 20.0,
//                          )
//                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
//                    onPressed: () {
//                      updateVehicle(_vehicleList[index]);
//                    }),
//              ),
//            );
//          });
//    } else {
//      return Center(
//          child: Text(
//        "Welcome. Your list is empty",
//        textAlign: TextAlign.center,
//        style: TextStyle(fontSize: 30.0),
//      ));
//    }
//  }

//  Widget showTodoList() {
//    if (_todoList.length > 0) {
//      return ListView.builder(
//          shrinkWrap: true,
//          itemCount: _todoList.length,
//          itemBuilder: (BuildContext context, int index) {
//            String todoId = _todoList[index].key;
//            String subject = _todoList[index].subject;
//            bool completed = _todoList[index].completed;
//            String userId = _todoList[index].userId;
//            return Dismissible(
//              key: Key(todoId),
//              background: Container(color: Colors.red),
//              onDismissed: (direction) async {
//                deleteTodo(todoId, index);
//              },
//              child: ListTile(
//                title: Text(
//                  subject,
//                  style: TextStyle(fontSize: 20.0),
//                ),
//                trailing: IconButton(
//                    icon: (completed)
//                        ? Icon(
//                            Icons.done_outline,
//                            color: Colors.green,
//                            size: 20.0,
//                          )
//                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
//                    onPressed: () {
//                      updateTodo(_todoList[index]);
//                    }),
//              ),
//            );
//          });
//    } else {
//      return Center(
//          child: Text(
//        "Welcome. Your list is empty",
//        textAlign: TextAlign.center,
//        style: TextStyle(fontSize: 30.0),
//      ));
//    }
//  }

  @override
  Widget build(BuildContext context) {
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
          setState(() {
            selectedIndex = index;
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
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 60),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12.0, 20, 0, 0),
                                  child: Text(
                                      // Find Name in Firebase Auth current user Object
                                      'Hello ${widget.currentuser.displayName}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                                  child: Text('Good morning.',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(height: 30),
                                StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('users')
                                        .where('userid',
                                            isEqualTo: widget.userId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return Text("Loading...");
                                      return Padding(
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
                                                      onPressed: () {},
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
                                      );
                                    }),
                                SizedBox(height: 20),
                                Container(
                                    height: 6.0, color: Color(0xFFEBD8BF)),
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
                        )
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
                        stream: Firestore.instance
                            .collection('vehicles')
                            .snapshots(),
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
                        stream: Firestore.instance
                            .collection('passages')
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

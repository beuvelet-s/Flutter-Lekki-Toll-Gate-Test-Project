import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:flutter_app_paul_test/pages/login_page.dart';
import 'package:flutter_app_paul_test/pages/payment_page.dart';
import 'package:flutter_app_paul_test/services/PNetworkImage.dart';
import 'package:flutter_app_paul_test/services/getimageandcrop.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_paul_test/models/todo.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:flutter_app_paul_test/models/vehicle_model.dart';
import 'addvehicle_page.dart';

class UserProfilePage extends StatefulWidget {
//  final GlobalKey bottomNavigationKey;
//  DashboardPage({Key key, this.bottomNavigationKey}) : super(key: key);
  static const String meal =
      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/food%2Fmeal.jpg?alt=media';
  static final String path = "lib/src/pages/profile/profile2.dart";
  static const String burger =
      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/food%2Fburger.jpg?alt=media';
  static const String fishtail =
      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/travel%2Ffishtail.jpg?alt=media';
  static const String kathmandu2 =
      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/travel%2Fkathmandu2.jpg?alt=media';
  static const String breakfast =
      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/food%2Fbreakfast.jpg?alt=media';
  final List<Map> collections = [
    {"title": "Food joint", "image": meal},
    {"title": "Photos", "image": burger},
    {"title": "Travel", "image": fishtail},
    {"title": "Nepal", "image": kathmandu2},
  ];
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://paultestlogin.appspot.com');
  int _NbOfVehicles = 0;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://paultestlogin.appspot.com');
  StorageUploadTask _uploadTask;
  String _Profile_Network_Image =
      "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png";
  @override
  State<StatefulWidget> createState() => new _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  FirebaseUser currentuser;
  String userId;
  String user_name;
  var _theList = ["1", "2", "3"];
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

    Container _buildSectionHeader(BuildContext context) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Collection",
              style: Theme.of(context).textTheme.title,
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                "Create new",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      );
    }

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
                          expandedHeight: 290,
                          floating: false,
                          pinned: false,
                          snap: false,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          flexibleSpace: StreamBuilder(
                              stream: db
                                  .collection('users')
                                  .where('userid', isEqualTo: userId)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshotusers) {
                                if (snapshotusers.hasData) {
                                  widget._Profile_Network_Image = snapshotusers
                                      .data.documents[0].data['user_picture'];

                                  return FlexibleSpaceBar(
                                    background: Stack(children: <Widget>[
                                      Container(
                                          width: double.infinity,
                                          height: 200,
                                          child: Image.asset(
                                              "assets/Lekki-Ikoyi-Link-Bridge.jpg",
//                                              width: double.infinity,
                                              fit: BoxFit.cover)),
                                      Container(
                                        margin: EdgeInsets.only(top: 50.0),
                                        height: 240.0,
                                        child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 40.0,
                                                    left: 40.0,
                                                    right: 40.0,
                                                    bottom: 10.0),
                                                child: Material(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                  elevation: 5.0,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 50.0,
                                                      ),
                                                      Text(
                                                        "${snapshotusers.data.documents[0].data['name']}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .title,
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                          "${snapshotusers.data.documents[0].data['email']}"),
                                                      SizedBox(
                                                        height: 16.0,
                                                      ),
                                                      Container(
                                                        height: 40.0,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                  "Vehicles",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                subtitle: Text(
                                                                    "${widget._NbOfVehicles.toString()}"
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20.0)),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                  "\u20A6",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                subtitle: Text(
                                                                    "${NumberFormat("###,###.##").format(snapshotusers.data.documents[0].data['balance']).toString()}"
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20.0)),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                  "CreditCard",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                subtitle: Text(
                                                                    "1"
                                                                        .toUpperCase(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20.0)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Positioned(
                                        top: 20,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                60,
                                        child: new Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(widget
                                                      ._Profile_Network_Image),
                                                  fit: BoxFit
                                                      .cover), // Circle shape
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              // The border you want
                                              border: new Border.all(
                                                width: 2.0,
                                                color: Colors.white,
                                              ),
                                              // The shadow you want
                                              boxShadow: [
                                                new BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 5.0,
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Positioned(
                                        top: 90,
                                        left:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                30,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: new BoxDecoration(
                                            color: Color(0xFFEBD8BF),
                                            shape: BoxShape.circle,
//                                            border: new Border.all(
//                                              width: 2.0,
//                                              color: Colors.black,
//                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await getImage(
                                                      ImageSource.gallery)
                                                  .then((_selectedFile) async {
                                                String filePath =
                                                    'images/${DateTime.now()}.png';
                                                StorageReference
                                                    storageReference = widget
                                                        ._storage
                                                        .ref()
                                                        .child(filePath);
                                                setState(() {
                                                  widget._uploadTask =
                                                      storageReference.putFile(
                                                          _selectedFile);
                                                });
                                                await widget
                                                    ._uploadTask.onComplete
                                                    .then((value) async {
                                                  await storageReference
                                                      .getDownloadURL()
                                                      .then((fileURL) {
                                                    var _uploadedFileURL =
                                                        fileURL;
                                                    snapshotusers.data.documents
                                                        .first.reference
                                                        .updateData({
                                                      "user_picture": fileURL
                                                    }).then((docref) {
                                                      setState(() {
                                                        widget._Profile_Network_Image =
                                                            fileURL;
                                                      });
                                                    }).catchError((err) => print(
                                                            'Error update users profile picture: $err'));
                                                  }).catchError((err) =>
                                                          print('Error: $err'));
                                                  ;
                                                });
                                              });
                                            },
                                            child: new Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
//                                        child: new Container(
//                                          width: 40,
//                                          height: 40,
//                                          decoration: BoxDecoration(
//                                              image: DecorationImage(
//                                                image: AssetImage(
//                                                    'assets/pencil-icon.png'),
//                                                fit: BoxFit.scaleDown,
//                                              ),
//                                              // Circle shape
//                                              shape: BoxShape.circle,
//                                              color: Colors.white,
//                                              // The border you want
//
//                                              // The shadow you want
//                                              boxShadow: [
//                                                new BoxShadow(
//                                                  color: Colors.black
//                                                      .withOpacity(0.2),
//                                                  blurRadius: 5.0,
//                                                ),
//                                              ]),
//                                        ),
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
                            Container(
                              color: Colors.white.withOpacity(0.8),
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "My Vehicles",
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  FlatButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Create new",
                                      style: TextStyle(
                                          color: MAIN_COLOR,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                              widget._NbOfVehicles =
                                  snapshot.data.documents.length;
                              return SliverToBoxAdapter(
                                child: Container(
                                  color: Colors.white.withOpacity(0.7),
                                  height: 200.0,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget._NbOfVehicles,
//                                    itemCount: widget.collections.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String image_path = "";
                                      DocumentSnapshot vehicle =
                                          snapshot.data.documents[index];
                                      final FirebaseStorage _storage =
                                          FirebaseStorage(
                                              storageBucket:
                                                  'gs://paultestlogin.appspot.com');
                                      String picture_file_url =
                                          vehicle.data['picture_file_url'];
                                      var ref = _storage
                                          .ref()
                                          .child(picture_file_url);
// no need of the file extension, the name will do fine.
//                                      ref.getDownloadURL().then((url) {
                                      VehicleModel vehicle_object =
                                          new VehicleModel(
                                              nvis_color:
                                                  vehicle.data["nvis_color"],
                                              nvis_cartype:
                                                  vehicle.data["nvis_cartype"],
                                              nvis_status:
                                                  vehicle.data["nvis_status"],
                                              category:
                                                  vehicle.data["category"],
                                              immatriculation: vehicle
                                                  .data["immatriculation"],
                                              userId: vehicle.data["userId"],
                                              filePath:
                                                  vehicle.data["picture_file"],
                                              picture_file_url: vehicle
                                                  .data["picture_file_url"],
                                              update: false);
//                                        setState(() {
                                      _providerVariables
                                          .addVehicle_global_object(
                                              vehicle_object);
//                                        });
//                                      });
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10.0),
                                        width: 150.0,
                                        height: 200.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: (_providerVariables
                                                            .vehicle_global_object
                                                            .length >
                                                        0)
                                                    ? PNetworkImage(
                                                        _providerVariables
                                                            .vehicle_global_object[
                                                                index]
                                                            .picture_file_url,
                                                        fit: BoxFit.fitHeight)
//                                                Container(
//                                                        child: Image.network(
//                                                        _providerVariables
//                                                                .vehicle_image[
//                                                            index],
//                                                        width: 450,
//                                                        height: 250,
//                                                        fit: BoxFit.fill,
//                                                      ))
                                                    : Stack(children: <Widget>[
                                                        Container(
                                                          child: Image.asset(
                                                            "assets/carfront.png",
                                                            width: 450,
                                                            height: 250,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                      ]),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                                _providerVariables
                                                    .vehicle_global_object[
                                                        index]
                                                    .nvis_cartype,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subhead
                                                    .merge(TextStyle(
                                                        color: Colors
                                                            .grey.shade600)))
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                            return SliverToBoxAdapter(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text('Loading....')));
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

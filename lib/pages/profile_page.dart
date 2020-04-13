//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/services/PNetworkImage.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_ui_challenges/core/presentation/res/assets.dart';
//import 'package:flutter_ui_challenges/src/widgets/network_image.dart';

class UserProfilePage2 extends StatefulWidget {
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
  String avatars =
      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media';

  @override
  _UserProfilePageState2 createState() => _UserProfilePageState2();
}

class _UserProfilePageState2 extends State<UserProfilePage2> {
//  final _formKeypay = new GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();

//    getThingsonStartUp2().then((result) {
//      print('initialisation Profile Data');
//    });
  }

  @override
  Widget build(BuildContext context) {
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: true);
    String userId = _globalvariables.userId;

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

    Container _buildCollectionsRow() {
      return Container(
        color: Colors.white,
        height: 200.0,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.collections.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                width: 150.0,
                height: 200.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: PNetworkImage(
                                widget.collections[index]['image'],
                                fit: BoxFit.cover))),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(widget.collections[index]['title'],
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .merge(TextStyle(color: Colors.grey.shade600)))
                  ],
                ));
          },
        ),
      );
    }

    Container buildHeader(BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 50.0),
        height: 240.0,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      "Stephane BEUVELET",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("UI/UX designer | Foodie | Kathmandu"),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "302",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Posts".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "10.3K",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Followers".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "120",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Following".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  elevation: 5.0,
                  color: Colors.white,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage:
                        ExactAssetImage("assets/Lekki-Ikoyi-Link-Bridge.jpg"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
//            } else {
//              return Container(
//                  child: Text('Loading', style: TextStyle(fontSize: 50)));
//            }
    }

    Widget _buildListItem() {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child:
              PNetworkImage(widget.collections[1]['image'], fit: BoxFit.cover),
        ),
      );
    }

    Widget _mainListBuilder(BuildContext context, int index) {}

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          width: double.infinity,
          height: 200.0,
//              width: MediaQuery.of(context).size.width * 2,
          child: Image.asset("assets/Lekki-Ikoyi-Link-Bridge.jpg",
              width: double.infinity, fit: BoxFit.cover)
//              gradient:
//                  LinearGradient(colors: [MAIN_COLOR, Colors.indigo.shade500]),
//            ),
          ),
      Container(
//            child: new Form(
//              key: _formKeypay,
//              autovalidate: _autoValidate,
        child: ListView(shrinkWrap: true, children: <Widget>[
//            itemCount: 3,
//            itemBuilder: _mainListBuilder,
          buildHeader(context),
          _buildSectionHeader(context),
          _buildCollectionsRow(),
          Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
              child: Text("Most liked posts",
                  style: Theme.of(context).textTheme.title)),
          _buildListItem(),
        ]),
      ),
    ]));
  }
}

//  Future<void> getThingsonStartUp2() async {
//    await db.collection('users').getDocuments().then((querySnapshot) {
//      querySnapshot.documents.forEach((documentSnapshot) async {
//        _globalvariables.addtariffs(documentSnapshot.data['vehicle_class'],
//            documentSnapshot.data['toll_tariff']);
//      });
//    }).catchError((e) {
//      print("error trying to read users db: $e");
//      _globalvariables.seterrorMessage(e);
//    });
//  }

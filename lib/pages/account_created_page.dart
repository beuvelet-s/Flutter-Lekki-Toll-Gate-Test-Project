import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/pages/home_page.dart';
import 'package:flutter_app_paul_test/pages/login_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:provider/provider.dart';

class AccountCreatedPage extends StatelessWidget {
  bool buttonenabled = true;

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    var _onPressed;

    Future<String> generate_tollID(String user_id) async {
      var ref = db.collection("tollidcards");
      String _tollid = '';
      await ref.add({
        "userid": user_id,
        "tollidtime": FieldValue.serverTimestamp(),
        "tollidserial": ''
      }).then((docref) {
        print('docref = $docref');
        ref.document(docref.documentID).get().then((doc) {
          if (doc.exists) {
            _tollid = doc.data['tollidtime'].seconds.toString() +
                doc.data['tollidtime'].nanoseconds.toString().substring(1, 4);
            // Update tollidserial
            ref.document(doc.documentID).updateData({
              "tollidserial": _tollid,
            }).then((docupdate) {
              print("tollidserial = $_tollid");
            }).catchError((err) => print('Error: $err'));
          } else {
            // doc.data() will be undefined in this case
            print("No such document!");
          }
        }).catchError((error) {
          print("Error getting document: $error");
        });
      }).catchError((error) {
        print("Error getting document: $error");
      });
      return _tollid;
    }

    _createUSer() async {
      // create a new user
      try {
        FirebaseUser user = await auth.getCurrentUser();
        String user_id = user.uid;
        String tollid = await generate_tollID(user_id);
        await db.collection("users").document(user_id).setData({
          "userid": user_id,
          "balance": 0,
          "email": user.email,
          "name": user.displayName,
// TODO   "photourl": user.photoUrl;
          "nbofvehicles": 0,
          "tollid": tollid,
        }).then((user) {
          print("tollid = $tollid");
        });
      } catch (err) {
        print(err);
      }
    }

    void _resentVerifyEmail() {
      auth.sendEmailVerification();
    }

    void _showVerifyEmailDialog(FirebaseUser user) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Verify your account"),
            content: new Text(
                "Please verify account in the link sent to your email ${user.email}"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Resent link"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resentVerifyEmail();
                },
              ),
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    _onPressedStatus() async {
      FirebaseUser user = await auth.getCurrentUser();
      await user.reload();
      bool emailverif = await auth.isEmailVerified();
      if (emailverif == true) {
        print("email Verified!");
        _createUSer();
        Navigator.pushNamed(context, '/home');
//        Navigator.of(context).pop();
      } else
        _showVerifyEmailDialog(user);
    }

    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Account created successfully',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    height: 1.0,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.check_circle,
                color: Color(0xFFD97A00),
                size: 140,
              ),
              Text(
                "Verify your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    height: 1.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A Link to verify account has been sent to your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      height: 1.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(00.0, 40.0, 00.0, 5.0),
                  child: SizedBox(
                    height: 66.0,
                    width: 190,
                    child: RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(33.0),
                      ),
                      color: Color(0xFFD97A00),
                      disabledColor: Colors.grey,
                      child: new Text('Dashboard',
                          style: new TextStyle(
                              fontSize: 23.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        _onPressedStatus();
                      },
                    ),
                  )),
            ]),
      ),
    );
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePage createState() => _QRCodePage();
}

class _QRCodePage extends State<QRCodePage> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  String _errorMessage = "";
  FirebaseUser currentuser;
  bool _isLoading = false;
//  String _randomKey = 'Unknown';
//  String _string = "Unknown";
//  String _encrypted = "Unknown";
  String userId;

  @override
  void initState() {
    super.initState();
    getThingsonStartUp().then((result) {});
  }

  Future<void> getThingsonStartUp() async {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    currentuser = await auth.getCurrentUser();
    userId = currentuser.uid;
  }

  // Generation de Code Bar
  Future<String> decryptMessage(String encryptedmessage) async {
    final cryptor = new PlatformStringCryptor();
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);

    //    print("randomKey: $key");
//    final message = "LCC - Passage Gate A1";
//    print('encrypted = $encrypted');
    await db.collection('secrets').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) async {
        var keyQR = documentSnapshot.data['keydecryptQR'];
        await cryptor.decrypt(encryptedmessage, keyQR).then((decrypted) {
          print('decrypted = $decrypted');
          _globalvariables.setbarcodedecrypted(decrypted);
          _globalvariables.setsuccessfullpassagepayment(true);
          return decrypted;
        }).catchError((e) {
          print("error trying to decrypt message: $e");
          _globalvariables.seterrorMessage(e);
        });
      });
    }).catchError((e) {
      print("error trying to read secret db: $e");
      _globalvariables.seterrorMessage(e);
    });
  }

//    final wrongKey =
//        "jIkj0VOLhFpOJSpI7SibjA==:RZ03+kGZ/9Di3PT0a3xUDibD6gmb2RIhTVF+mQfZqy0=";
//    try {
//      await cryptor.decrypt(encrypted, wrongKey);
//    } on MacMismatchException {
//      print("wrongly decrypted");
//    }
//    final salt = "Ee/aHwc6EfEactQ00sm/0A=="; // await cryptor.generateSalt();
//    final password = "a_strong_password%./😋";
//    final generatedKey = await cryptor.generateKeyFromPassword(password, salt);
//    print("salt: $salt, key: $generatedKey");

//    assert(generatedKey == wrongKey);

//    setState(() {
//      _randomKey = key;
//      _string = string1;
//      _encrypted = encrypted1;
//    });

  @override
  Widget build(BuildContext context) {
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('200 Naira / Passage', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Image.asset('assets/CaptureQRcode.PNG'),
// Generation of Encrypted Barcode
//              SizedBox(
//                width: 400,
//                height: 400,
//                child: Image.memory(bytes),
//              ),
                  SizedBox(height: 20),
                  Text('${_globalvariables.barcodedecrypted}'),
//              RaisedButton(onPressed: _scan, child: Text("Scan")),
//              RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
//              RaisedButton(
//                  child: Text("Generate Barcode"),
//                  onPressed: () async {
//                    String _message = 'LCC - Passage Gate A1';
//                    _generateBarCode(_message);
////                    await cryptMessage(_message).then((encryptedmessage) async {
////                      print('encryptedmessage = $encryptedmessage');
////                      _generateBarCode(encryptedmessage);
////                    });
//                  })
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
                              child: Text('PRESS TO PAY',
                                  style: new TextStyle(
                                      fontSize: 23.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
//                              _scan();
                                _scanPhoto();
                              }))),
                ],
              ),
            ),
            _globalvariables.successfullpassagepayment == true
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '\Passage Payment Successfull\n\n ${_globalvariables.barcodedecrypted}',
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
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
                              "The Amount of 200 Naira has been debited from your Wallet \n\n Thank You for using LCC Bridge!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  height: 1.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(00.0, 40.0, 00.0, 5.0),
                              child: SizedBox(
                                height: 66.0,
                                width: 190,
                                child: RaisedButton(
                                  elevation: 5.0,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(33.0),
                                  ),
                                  color: Color(0xFFD97A00),
                                  disabledColor: Colors.grey,
                                  child: new Text('OK',
                                      style: new TextStyle(
                                          fontSize: 23.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    _globalvariables
                                        .setsuccessfullpassagepayment(false);
                                    // increase balance;
                                    db
                                        .collection('users')
                                        .where('userid', isEqualTo: userId)
                                        .getDocuments()
                                        .then((querySnapshot) {
                                      querySnapshot.documents
                                          .forEach((documentSnapshot) {
                                        documentSnapshot.reference.updateData({
                                          "balance": FieldValue.increment(
                                              -_globalvariables.passagefee)
                                        });
                                      });
                                      _errorMessage =
                                          "Passage Payment Successfull";
                                    }).catchError((e) {
                                      print("update user balance in users: $e");
                                      _errorMessage = e;
                                    });
                                    // add passage history
                                    var ref = db.collection("passages");
                                    ref.add({
                                      "date": DateTime.now(),
                                      "immatriculation":
                                          _globalvariables.immatriculation,
                                      "type": _globalvariables.vehicle_type,
                                      "userId": _globalvariables.userId,
                                      "chargedamount":
                                          _globalvariables.passagefee
                                    }).then((docref) {
                                      print(
                                          "passage added with passage ID = ${docref.documentID}");
//                                        _globalvariables.setsuccessfulltransaction(true);
//                                        _globalvariables.settransactionid(docref.documentID);
//                                        _globalvariables.setfees(_result.data.fees / 100);
//                                        _globalvariables.setamountpaid(_result.data.amount / 100);
                                    }).catchError(
                                        (err) => print('Error: $err'));

                                    Map jsonamount = {
                                      "paid": _globalvariables.passagefee
                                    };

                                    var reftransact =
                                        db.collection("transactions");
                                    reftransact.add({
                                      "userid": userId,
                                      "transaction_data": jsonamount,
                                      "transaction_type": 'passage payment'
                                    }).then((docref) {
                                      print(
                                          "transaction added with transaction ID = ${docref.documentID}");
//    _globalvariables.setsuccessfulltransaction(true);
//    _globalvariables.settransactionid(docref.documentID);
//    _globalvariables.setfees(_result.data.fees / 100);
//    _globalvariables.setamountpaid(_result.data.amount / 100);
                                    }).catchError(
                                        (err) => print('Error: $err'));

//                                var userRef = await db
//                                    .collection('users')
//                                    .where('userid', isEqualTo: userId)
//                                    .snapshots()
//                                    .first
//                                    .updateData((doc) {});
//                                print('Snapshot = $userRef');
                                    // Atomically increment the balance by the amount charged - Fees.
//                                userRef.map((doc) {doc.data.documents[0].data['name']({"balance": FieldValue.increment(XX)});
                                  },
                                ),
                              ),
                            ),
                          ]),
                    ),
                  )
                : Container(), // end Container()
          ],
        ),
      ),
    );
  }

  Future<void> _scan() async {
    String barcode = await scanner.scan();
    await decryptMessage(barcode).then((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
  }

  Future _scanPhoto() async {
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);

//    String barcode = await scanner.scanPhoto();
//    setState(() => this.barcode = barcode);
    await scanner.scanPhoto().then((barcode) async {
      await decryptMessage(barcode).then((barcode) async {
        await print('Set barcodeCrypted barcode = $barcode');
      });
    }).catchError((e) {
      print("error trying to decrypt message: $e");
    });
  }

  Future<void> _generateBarCode(String message) async {
    String encrypted = '';
    final cryptor = new PlatformStringCryptor();
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);
    await cryptor.generateRandomKey().then((keydecryptQR) async {
      _globalvariables.setkeydecryptQR(keydecryptQR);
      print('keydecryptQR = $keydecryptQR');
      await db.collection('secrets').getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((documentSnapshot) async {
          await documentSnapshot.reference
              .updateData({"keydecryptQR": keydecryptQR}).then((onValue) async {
            await cryptor
                .encrypt(message, _globalvariables.keydecryptQR)
                .then((encryptedmes) async {
              encrypted = encryptedmes;
              var _errorMessage = "Scan Successfull";
              _globalvariables.seterrorMessage(_errorMessage);
              //    final encryptedmessage = await cryptMessage(message);
              Uint8List result = await scanner.generateBarCode(encrypted);
              this.setState(() => this.bytes = result);
//              return encrypted;
            }).catchError((e) {
              print("trying to encrypt message $e");
              _globalvariables.seterrorMessage(e);
            });
          }).catchError((e) {
            print("trying to update qrkey in firebasee $e");
            _globalvariables.seterrorMessage(e);
          });
        });
      });
    }).catchError((e) {
      print("update user balance in users: $e");
      _globalvariables.seterrorMessage(e);
    });
  }
}

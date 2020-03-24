import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_paul_test/pages/signup_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
import 'package:flutter_app_paul_test/services/picture_scanner.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddVehicle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddVehicle();
//}
}

class _AddVehicle extends State<AddVehicle> {
  File _selectedFile;
  bool _inProcess = false;

  @override
  void initState() {
    super.initState();
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final _formKey = new GlobalKey<FormState>();
    String _immatriculation = '';
    bool _isLoading = false;
//    String _password = '';

    Future readText() async {
      FirebaseVisionImage image = FirebaseVisionImage.fromFile(_selectedFile);
      TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

      VisionText recognizedText = await textRecognizer.processImage(image);
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement word in line.elements) {
            print(word.text);
          }
        }
      }
    }

    // Check if form is valid before perform login or signup
    bool Formvalidated() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    // Perform login or signup
    Future<bool> validateAndSubmit() async {
//      setState(() {
//        _errorMessage = "";
//      });
      bool _validated = false;
      if (Formvalidated()) {
//        FirebaseUser user;
//        String userId;
//        String user_name;
//        setState(() {
//          _isLoading = true;
//        });

        try {
//          user = await auth.signInWithEmailAndPassword(_email, _password);
//          userId = user.uid;
//          user_name = user.displayName;
//          print('Signed in: $user_name');
//          setState(() {
//            _isLoading = false;
//            _validated = true;
//          });
        } catch (e) {
          print('Error: $e');
          setState(() {
//            _isLoading = false;
//            _errorMessage = e.message;
          });

//        _formKey.currentState.reset();

        }
      }
      return _validated;
    }

    void resetForm() {
      _formKey.currentState.reset();
//      _errorMessage = "";
    }

    Widget _showCircularProgress() {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }

//    Widget showErrorMessage() {
//      if (_errorMessage.length > 0 && _errorMessage != null) {
//        return Center(
//          child: new Text(
//            _errorMessage,
//            style: TextStyle(
//                fontSize: 13.0,
//                color: Colors.red,
//                height: 1.0,
//                fontWeight: FontWeight.w300),
//          ),
//        );
//      } else {
//        return new Container(
//          height: 0.0,
//        );
//      }
//    }

    Widget showLogo() {
      return new Hero(
        tag: 'hero',
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset('assets/logoLCCLekki.png'),
            // Image.asset('assets/flutter-icon.png'),
          ),
        ),
      );
    }

    Widget showExplanation() {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Center(
          child: Container(
              child: Column(
            children: <Widget>[
              Text('Add Vehicle',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              Text('Please take picture of your Car front',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ],
          )),
        ),
      );
      //  onPressed: () {});
    }

    Widget getImageWidget() {
      if (_selectedFile != null) {
        return Image.file(
          _selectedFile,
//          width: 250,
          height: 250,
          fit: BoxFit.fill,
        );
      } else {
        return Container(
            child: Image.asset(
          "assets/carfront.png",
          width: 350,
          height: 250,
          fit: BoxFit.cover,
        ));

//          ClipRRect(
//          borderRadius: BorderRadius.all(Radius.circular(20)),
//          child: Container(
//            decoration: BoxDecoration(
//              border: Border.all(
//                color: Color(0xff000000),
//                width: 1,
//              ),
//            ),
//            child: Image.asset(
//              "assets/carfront.png",
//              width: 350,
//              height: 250,
//              fit: BoxFit.cover,
//            ),
//          ),
//        );
      }
    }

    Widget showImmatriculationInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
        child: new TextFormField(
          textAlign: TextAlign.center,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            labelText: 'Immatriculation',
            alignLabelWithHint: false,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFD97A00), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelStyle: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey),
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
          ),
          validator: (value) =>
              value.isEmpty ? 'Immatriculation can\'t be empty' : null,
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
          onSaved: (value) => _immatriculation = value.trim(),
        ),
      );
    }

    Widget DetectTextinPicture() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(80.0, 25.0, 80.0, 5.0),
          child: SizedBox(
            height: 66.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(33.0),
              ),
              color: Color(0xFFD97A00),
              child: new Text('Detect Text',
                  style: new TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onPressed: () async {
//                if (await validateAndSubmit() == true) {
//                  Navigator.pushReplacementNamed(context, '/home');
//                }
                readText();
              },
            ),
          ));
    }

    Widget _showForm() {
      return new Container(
          padding: EdgeInsets.all(10.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                showLogo(),
                showExplanation(),
                getImageWidget(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: SizedBox(
                          height: 66.0,
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                            ),
                            color: Color(0xFFD97A00),
                            child: new Text('Camera',
                                style: new TextStyle(
                                    fontSize: 23.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: SizedBox(
                          height: 66.0,
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                            ),
                            color: Color(0xFFD97A00),
                            child: new Text('Gallery',
                                style: new TextStyle(
                                    fontSize: 23.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ),
                    ]),
                showImmatriculationInput(),
//                showPasswordInput(),
                DetectTextinPicture(),
//                showIforgotmyPassword(),
//                showErrorMessage(),
//                showSecondaryButton(),
              ],
            ),
          ));
    }

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }
}

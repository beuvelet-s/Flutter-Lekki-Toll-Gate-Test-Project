import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_paul_test/pages/signup_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/detector_painters.dart';
import 'package:flutter_app_paul_test/models/vehicle_model.dart';
import 'package:flutter_app_paul_test/services/flushbar_service.dart';
import 'package:flutter_app_paul_test/services/getimageandcrop.dart';
import 'package:flutter_app_paul_test/services/picture_scanner.dart';
import 'package:flutter_app_paul_test/services/providervariables.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddVehicle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddVehicle();
//}
}

class _AddVehicle extends State<AddVehicle> {
  File _selectedFile;
  Size _imageSize;
  List<String> _scanResults = [];
  Detector _currentDetector = Detector.label;
  final ImageLabeler _imageLabeler = FirebaseVision.instance.imageLabeler();
  String _vehicleType = "Class I";
  bool _inProcess = false;
  String _detectedPlate = '';
  bool _detectedPlatehaschanged = false;
  String _errorMessage = '';
  String _Message = '';
  String _VehicleMake = '';
  String _Vehiclecolor = '';
  String _VehicleStatus = '';
  String _VehicleError = '';
  String _errorVehicleStatus = '';
  bool _confirmedVehicleType = false;
  bool _confirmedVehicleMake = false;
  bool _confirmedVehicleStatus = false;
  bool _confirmedVehicleColor = false;
  bool _uploadVehicleimage = false;
  bool _isChecking = false;
  String _buttonToggleChecking = 'Verify';
  File _cropped;
  String _immatriculation = '';
  TextEditingController _VehicleStatusController = new TextEditingController();
  VehicleModel _cartoUpdate;
  String _urlVehicleimage;
  final FocusNode _immatFocus = FocusNode();
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://paultestlogin.appspot.com');
  StorageUploadTask _uploadTask;
  final List<String> imgList = [
    "assets/carfront.png",
    "assets/truckfront.png",
    "assets/bikeback.png",
  ];
  String _uploadedFileURL = "";
  @override
  void initState() {
    super.initState();
    _VehicleStatusController.value = TextEditingValue(text: "");
  }

  String RecognizeVehicleonTopotheList(List<String> list) {
    List<String> Keywords = ["Bus", "Car", "Truck", "Van", "Motorcycle"];
    return list.firstWhere((item) => Keywords.contains(item) == true);
  }

  Future<void> verifCarPLateNVIS(String carplate) async {
    final Map<String, String> _headerData = {
      "authority": "nvis.frsc.gov.ng",
      "cache-control": "max-age=0",
      "origin": "https://nvis.frsc.gov.ng",
      "upgrade-insecure-requests": "1",
      "content-type": "application/x-www-form-urlencoded",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36",
      "sec-fetch-dest": "document",
      "accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "sec-fetch-site": "same-origin",
      "sec-fetch-mode": "navigate",
      "sec-fetch-user": "?1",
      "referer": "https://nvis.frsc.gov.ng/VehicleManagement/VerifyPlateNo",
      "accept-language": "en-US,en;q=0.9,fr;q=0.8",
      "cookie":
          ".AspNetCore.Antiforgery.P37aaq0k6XY=CfDJ8IcFeG-74_xMtAODLORCXfiEQxskG8QsQgqsH4LvC58mpnGowhozuPdzv2W_cjRmkflLD_KwIU5AEYbzmcK7s_vdbMDsigKaCjfO2FJMKwVvtlgt1clkKCiPIFEY0c5ys7BkOCWU6kX7FDTWPvrINkg"
    };
    final Map<String, String> _bodyData = {
      "plateNumber": carplate,
      "__RequestVerificationToken":
          "CfDJ8IcFeG-74_xMtAODLORCXfh9-c74oBG9FMooe96pLx-ZOherz3FyZOE6fH4lK76u-WWFnNVyy7BftSBjkSdsJbmJjD-4BOLRtDUaqx_ClaxTC2DbSxPnwlAoe1AKq4e5krkNf4iBOdy-YzlWVnILuP4"
    };
    final String _url =
        'https://nvis.frsc.gov.ng/VehicleManagement/VerifyPlateNo';
    String _message = '';
    String _success = '';
    Map _result = {};
    int _index = 0;
    int _indexspandeb = 0;
    int _indexspanend = 0;
    await http
        .post(Uri.parse(_url),
            headers: _headerData,
            body: _bodyData,
            encoding: Encoding.getByName("utf-8"))
        .then((result) async {
      if (result.statusCode == 200 || result.statusCode == 400) {
        var _jsonbody = result.body;

        if ((_jsonbody.indexOf('showAlert(\'error\'') > 0)) {
          _index = _jsonbody.indexOf('showAlert(\'error\'');
          _VehicleError = result.body.substring(_index, _index + 200);
          _indexspandeb = _VehicleError.indexOf('error');
          _indexspanend = _VehicleError.indexOf('</script>');
          List<String> _ListVehicleError =
              _VehicleError.substring(_indexspandeb + 9, _indexspanend - 4)
                  .replaceAll(RegExp(r"[\']"), '')
                  .split(",");
          var _title = _ListVehicleError[0].trim();
          var _message = _ListVehicleError[1].trim();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(_title),
                content: new Text(_message),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
//                      _detectedPlatehaschanged = true;
                      setState(() {
                        _Message = 'Enter a Valid Carplate...';
//                        _errorMessage = 'Invalid CarPLate';
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        if ((_jsonbody.indexOf('vehicles-description get-bestoffer') > 0)) {
          _index = _jsonbody.indexOf('vehicles-description get-bestoffer');
          _VehicleStatus = result.body.substring(_index, _index + 1000);
          _indexspandeb =
              _VehicleStatus.indexOf('<div class="panel panel-heading">');
          _indexspanend = _VehicleStatus.indexOf('</div>');
          setState(() {
            _cartoUpdate.setVehicleCarstatus(
                _VehicleStatus.substring(_indexspandeb + 33, _indexspanend)
                    .trim());
            _confirmedVehicleStatus = true;
            _VehicleStatusController.value =
                TextEditingValue(text: _cartoUpdate.nvis_status);
          });
        }

        if ((_jsonbody.indexOf('Vehicle Make') > 0)) {
          _index = _jsonbody.indexOf('Vehicle Make');
          _VehicleMake = result.body.substring(_index, _index + 300);
          _VehicleMake = result.body.substring(_index, _index + 300);
          _indexspandeb = _VehicleMake.indexOf('<span>');
          _indexspanend = _VehicleMake.indexOf('</span>');
          setState(() {
            _cartoUpdate.setVehicleCartype(
                _VehicleMake.substring(_indexspandeb + 6, _indexspanend)
                    .trim());
            _confirmedVehicleMake = true;

            if (_cartoUpdate.nvis_cartype.contains('Truck') ||
                (_cartoUpdate.nvis_cartype.contains('Coaster'))) {
              if (_cartoUpdate.category != 'Class III' &&
                  _cartoUpdate.category != 'Class IV') {
                _errorVehicleStatus = 'Vehicle Status incorrect';
              } else {
                _errorVehicleStatus = '';
              }
            }
          });
        }

        if ((_jsonbody.indexOf('Vehicle Color') > 0)) {
          _index = _jsonbody.indexOf('Vehicle Color');
          _Vehiclecolor = result.body.substring(_index, _index + 300);
          _indexspandeb = _Vehiclecolor.indexOf('<span>');
          _indexspanend = _Vehiclecolor.indexOf('</span>');
          setState(
            () {
              _cartoUpdate.setVehicleColor(
                  _Vehiclecolor.substring(_indexspandeb + 6, _indexspanend)
                      .trim());
              _confirmedVehicleColor = true;
            },
          );
        }

//        print('_Vehiclecolor = $_Vehiclecolor');
      }
      await _scanImage(_selectedFile).then((data) {
        print('data = $data');
      });

      if (RecognizeVehicleonTopotheList(_scanResults) == 'Bus') {
        if (_cartoUpdate.category != 'Class III' &&
            _cartoUpdate.category != 'Class IV') {
          _errorVehicleStatus = 'Vehicle Status incorrect';
          _confirmedVehicleType = false;
          setState(() {
            _buttonToggleChecking = 'Verify';
          });
        } else {
          _errorVehicleStatus = '';
          _confirmedVehicleType = true;
          setState(() {
            _buttonToggleChecking = 'Add';
          });
        }
      }

      if (RecognizeVehicleonTopotheList(_scanResults) == 'Car') {
        if (_cartoUpdate.category != 'Class I') {
          _errorVehicleStatus = 'Vehicle Status incorrect';
          _confirmedVehicleType = false;
          setState(() {
            _buttonToggleChecking = 'Verify';
          });
        } else {
          _errorVehicleStatus = '';
          _confirmedVehicleType = true;
          setState(() {
            _buttonToggleChecking = 'Add';
          });
        }
      }

      if (RecognizeVehicleonTopotheList(_scanResults) == 'Van') {
        if (_cartoUpdate.category != 'Class II' &&
            _cartoUpdate.category != 'Class IIA') {
          _errorVehicleStatus = 'Vehicle Status incorrect';
          _confirmedVehicleType = false;
          setState(() {
            _buttonToggleChecking = 'Verify';
          });
        } else {
          _errorVehicleStatus = '';
          _confirmedVehicleType = true;
          setState(() {
            _buttonToggleChecking = 'Add';
          });
        }
      }

      if (RecognizeVehicleonTopotheList(_scanResults) == 'Motorcycle') {
        if (_cartoUpdate.category != 'Class M') {
          _errorVehicleStatus = 'Vehicle Status incorrect';
          _confirmedVehicleType = false;
          setState(() {
            _buttonToggleChecking = 'Verify';
          });
        } else {
          _errorVehicleStatus = '';
          _confirmedVehicleType = true;
          setState(() {
            _buttonToggleChecking = 'Add';
          });
        }
      }

      _isChecking = false;
    }).catchError((e) {
      print("Error in verifCarPLateNVIS : $e");
      setState(() {
        _errorMessage = e;
      });
    });
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  Future<dynamic> _scanImage(File imageFile) async {
    _scanResults = [];
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    var res = null;
    bool _vehiclelog = false;
    bool _buslog = false;
    bool _carlog = false;
    await _imageLabeler.processImage(visionImage).then((results) {
      res = results;
      setState(() {
        res.forEach((item) {
          _scanResults.add(item.text);
          print("item = ${item.text}, proba = ${item.confidence}");
          if (item.text.contains("Vehicle") == true) {
            _vehiclelog = true;
            print("found a Vehicle! ");
          }
          if (item.text.contains("Car") == true) {
            if (_vehiclelog == true && _buslog == false) {
              _carlog = true;
              print("found a Car! ");
            }
          }
          if (item.text.contains("Bus") == true) {
            if (_vehiclelog == true) {
              _buslog = true;
              print("found a Bus! ");
            }
            ;
          }
          if (item.text.contains("Bus") == true) {
            print("found Bus! ");
          }
          if (item.text.contains("Motorcycle") == true) {
            print("found Motorcycle! ");
          }
        });
        print('res[0] = ${res[0].text}');
        //res[0].confidence, entityId, text
      });
    });
//    return _scanResults;
  }

  bool isaPlateNumber(String input) {
    input = input.trim();
    bool result = false;

//      Pattern isPlatestring = r'^[A-Z]{3}[-\s]{0,1}[0-9]{2,3}[A-Z]{2}$';
    Pattern isPlatestring = r'\d{2,3}';
    RegExp isPlate = new RegExp(isPlatestring);

    Pattern isPlatebefore2011string = r'^[A-Z]{2}[0-9]{2,3}[-\s]{0,1}[A-Z]{3}$';
    RegExp isPlatebefore2011 = RegExp(isPlatebefore2011string);

    if ((input.trim().length >= 7) &&
        (input == input.toUpperCase()) &&
        (isPlate.hasMatch(input))) {
      // this is a Valid Car Plate
      result = true;
    }
    return result;
  }

  Future<void> readText() async {
    FirebaseVisionImage image = FirebaseVisionImage.fromFile(_selectedFile);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText recognizedText = await textRecognizer.processImage(image);
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        print('text =${line.text}, confidence=${line.confidence}');
        if (isaPlateNumber(line.text) == true &&
            _detectedPlatehaschanged == false) {
          print('Hourra there is a plate number = ${line.text}');
          setState(() {
            _cartoUpdate.setVehicleImmatriculation(
                line.text.trim().replaceAll(new RegExp(r"[^A-Za-z0-9]"), ""));
          });
        }
      }
    }
    await verifCarPLateNVIS(_cartoUpdate.immatriculation);
  }

//      this.setState(() {
//        _selectedFile = cropped;
////        _inProcess = false;
//        readText();
//      });
//    else {
//      this.setState(() {
//        _inProcess = false;
//      });
//    }

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    _cartoUpdate = settings.arguments;
    if (_cartoUpdate.category == "") {
      _vehicleType = "Class I";
    } else {
      _vehicleType = _cartoUpdate.category;
    }
    ;
    _Vehiclecolor = _cartoUpdate.nvis_color;
//    _VehicleStatus = _cartoUpdate.nvis_status;
//    _VehicleMake = _cartoUpdate.nvis_cartype;
    _detectedPlate = _cartoUpdate.immatriculation;
//    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final _formKey = new GlobalKey<FormState>();

    bool _isLoading = false;
    final Firestore db = Provider.of<Firestore>(context, listen: false);
    final providerVariables _globalvariables =
        Provider.of<providerVariables>(context, listen: false);
//    String _password = '';

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
            radius: 28.0,
            child: Image.asset('assets/logoLCCLekki.png'),
            // Image.asset('assets/flutter-icon.png'),
          ),
        ),
      );
    }

    Widget getImageWidget() {
      if (_selectedFile != null) {
        return AspectRatio(
            aspectRatio: 1.4 / 1,
            child: Image.file(
              _selectedFile,
              width: 450,
              height: 250,
              fit: BoxFit.fill,
            ));
      } else {
        return (_cartoUpdate.filePath != null && _cartoUpdate.filePath != "")
            ? Stack(
                children: <Widget>[
                  Container(
                      child: Image.asset(
                    "assets/carfront.png",
                    width: 450,
                    height: 250,
                    fit: BoxFit.fill,
                  )),
                  Image.network(_cartoUpdate.filePath)
                ],
              )
            : CarouselSlider(
                viewportFraction: 0.9,
                aspectRatio: 2.0,
                autoPlay: true,
                enlargeCenterPage: true,
                items: imgList.map(
                  (assetimgpath) {
                    return Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Image.asset(
                          assetimgpath,
                          fit: BoxFit.fitHeight,
                          width: 1000.0,
                        ),
                      ),
                    );
                  },
                ).toList(),
              );

//        Container(
//                child: Image.asset(
//                "assets/carfront.png",
//                width: 450,
//                height: 250,
//                fit: BoxFit.fill,
//              ));
      }
    }

    Widget showImmatriculationInput() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage('assets/plate_background.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: 57,
                  width: 140,
                  child: new TextFormField(
                    focusNode: _immatFocus,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                    initialValue: _cartoUpdate.immatriculation,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Immatriculation',
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFD97A00), width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
//            ),
                    ),
                    validator: (value) => value.isEmpty
                        ? 'Immatriculation can\'t be empty'
                        : null,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
                    ],
                    onChanged: (value) {
                      print(value);
//                      _detectedPlate = value;
                      _Message = '';
                      _detectedPlatehaschanged = true;
                      _cartoUpdate.setVehicleImmatriculation(value);
                    },
                    onSaved: (value) {
                      //                     _immatriculation = value.trim();
                      _cartoUpdate.setVehicleImmatriculation(value.trim());
                    },
                  ),
                  //       ),
                ),
              ],
            ),
          ));
    }

    Widget showCapturebuttons() {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              child: SizedBox(
                height: 46.0,
                child: _cartoUpdate.update
                    ? Container()
                    : RaisedButton(
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        color: Color(0xFFD97A00),
                        child: new Text('Camera',
                            style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          await getImage(ImageSource.camera).then((file) {
                            setState(() {
                              _selectedFile = file;
                            });
                            readText();
                          });
                        },
                      ),
              ),
            ),
            showImmatriculationInput(),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              child: SizedBox(
                height: 46.0,
                child: _cartoUpdate.update
                    ? Container()
                    : RaisedButton(
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        color: Color(0xFFD97A00),
                        child: Text('Gallery',
                            style: new TextStyle(
                                fontSize: 23.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          _detectedPlatehaschanged = false;
                          setState(() {
//                      _detectedPlate = '';
                            _cartoUpdate.setVehicleImmatriculation("");
                            _isChecking = true;
                          });
                          await getImage(ImageSource.gallery).then((file) {
                            setState(() {
                              _selectedFile = file;
                            });
                            readText();
                          });
                        }),
              ),
            ),
          ]);
    }

    Widget showMessage() {
      if (_Message.length > 0 && _Message != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: new Text(
              _Message,
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.red,
                  height: 1.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    Widget showCarType() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 35,
                  child: new TextFormField(
                    readOnly: true,
                    initialValue: Car_Types[_cartoUpdate.category],
                    maxLines: 1,
                    enableInteractiveSelection:
                        false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'Car Type',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFD97A00), width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                _confirmedVehicleStatus
                    ? Positioned(
                        child: Icon(Icons.check, color: Colors.green[500]),
                        right: 5,
                        bottom: 5)
                    : Positioned(
                        child: _cartoUpdate.update
                            ? Icon(Icons.lock, color: Colors.green[500])
                            : Icon(
                                Icons.crop_square,
                                color: Colors.grey,
                              ),
                        right: 5,
                        bottom: 5)
              ],
            ),
          ));
    }

    Widget showVehicleTypeDropdown() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(
//                height: 58,
                child: _cartoUpdate.update
                    ? showCarType()
                    : DropdownButtonFormField<String>(
                        isExpanded: true,
                        isDense: true,
                        value: _cartoUpdate.category,
                        items: [
                          DropdownMenuItem(
                            value: "Class M",
                            child: Text(
                              "Class M: Motorcycles",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Class I",
                            child: Text(
                              "Class I: Saloon cars and tricycles",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Class II",
                            child: Text(
                                "Class II: Sports Utility Vehicles (SUVs), minibuses, and pick-up trucks ",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true),
                          ),
                          DropdownMenuItem(
                            value: "Class IIA",
                            child: Text("Class IIA: Commercial danfo minibuses",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true),
                          ),
                          DropdownMenuItem(
                            value: "Class III",
                            child: Text(
                                "Class III: Light trucks and 2-axle buses",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true),
                          ),
                          DropdownMenuItem(
                            value: "Class IV",
                            child: Text(
                                "Class IV: Heavy trucks and buses with two or more heavy axles",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true),
                          )
                        ],
                        onChanged: (String newValue) {
                          print("value : $newValue");
                          setState(() {
                            _vehicleType = newValue;
                            _cartoUpdate.setVehicleCategory(newValue);
                          });
                        },
                        decoration: new InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Color(0xFFE8E8E8),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          labelText: 'Vehicle Type',
                          alignLabelWithHint: false,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFD97A00), width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    }

    Widget showerrorVehicleStatus() {
      if (_errorVehicleStatus.length > 0 && _errorVehicleStatus != null) {
        return Center(
          child: new Text(
            _errorVehicleStatus,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    Widget DetectTextinPicture() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(80.0, 25.0, 80.0, 5.0),
          child: SizedBox(
            height: 46.0,
            child: _cartoUpdate.update
                ? RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(33.0),
                    ),
                    color: Color(0xFFD97A00),
                    child: Text('OK',
                        style: new TextStyle(
                            fontSize: 23.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
                : RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(33.0),
                    ),
                    color: Color(0xFFD97A00),
                    child: Text(_buttonToggleChecking,
                        style: new TextStyle(
                            fontSize: 23.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
//                if (await validateAndSubmit() == true) {
//                  Navigator.pushReplacementNamed(context, '/home');
//                }
                      if (_confirmedVehicleType &&
                          _confirmedVehicleMake &&
                          _confirmedVehicleStatus &&
                          _confirmedVehicleColor) {
                        // Change Button Label

                        // upload picture in Firestore add vehicle to database

                        String filePath = 'images/${DateTime.now()}.png';
                        _cartoUpdate.setVehicleurlfilePath(filePath);
                        StorageReference storageReference =
                            _storage.ref().child(filePath);
                        setState(() {
                          _uploadTask = storageReference.putFile(_selectedFile);
                          _uploadVehicleimage = true;
                        });
                        await _uploadTask.onComplete.then((value) async {
                          await storageReference
                              .getDownloadURL()
                              .then((fileURL) {
                            _uploadedFileURL = fileURL;
                            var ref = db.collection("vehicles");
                            ref.add({
                              "category": _cartoUpdate.category,
                              "immatriculation": _cartoUpdate.immatriculation,
                              "nvis_status": _cartoUpdate.nvis_status,
                              "nvis_cartype": _cartoUpdate.nvis_cartype,
                              "nvis_color": _cartoUpdate.nvis_color,
                              "picture_file": _cartoUpdate.filePath,
                              "picture_file_url": _uploadedFileURL,
                              "userId": _globalvariables.userId,
                            }).then((docref) {
                              print(
                                  "car added with carID = ${docref.documentID}");
                              Navigator.of(context).pop();
                            }).catchError((err) => print('Error: $err'));
                          });
                        });
                      } else {
                        if (_selectedFile != null) {
                          _getImageSize(_selectedFile);
                          readText();
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text('No Image Loaded !'),
                                content: new Text(
                                    'Please Load a Picture of Your Vehicle...'),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("OK"),
                                    onPressed: () {
                                      setState(() {
                                        _Message =
                                            'Please Load a Picture of Your Vehicle...';
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                      ;
                    },
                  ),
          ));
    }

    Widget showVehicleStatus() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 35,
                  child: new TextFormField(
                    readOnly: true,
                    initialValue: _cartoUpdate.nvis_status,
                    maxLines: 1,
//                    controller: _VehicleStatusController,
//                    onChanged: (String value) {
//                      setState(() {
//                        _VehicleStatusController.text = _VehicleStatus;
//                      });
//                    },
                    enableInteractiveSelection:
                        false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'NVIS Status',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFD97A00), width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  //       ),
                ),
                _confirmedVehicleStatus
                    ? Positioned(
                        child: Icon(Icons.check, color: Colors.green[500]),
                        right: 5,
                        bottom: 5)
                    : Positioned(
                        child: _cartoUpdate.update
                            ? Icon(Icons.lock, color: Colors.green[500])
                            : Icon(
                                Icons.crop_square,
                                color: Colors.grey,
                              ),
                        right: 5,
                        bottom: 5)
              ],
            ),
          ));
    }

    Widget showVehicleMake() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 35,
                  child: new TextFormField(
                    initialValue: _cartoUpdate.nvis_cartype,
                    enableInteractiveSelection:
                        false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'NVIS Car Type',
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFD97A00), width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    //       ),
                  ),
                ),
                _confirmedVehicleMake
                    ? Positioned(
                        child: Icon(
                          Icons.check,
                          color: Colors.green[500],
                        ),
                        right: 5,
                        bottom: 5)
                    : Positioned(
                        child: _cartoUpdate.update
                            ? Icon(Icons.lock, color: Colors.green[500])
                            : Icon(
                                Icons.crop_square,
                                color: Colors.grey,
                              ),
                        right: 5,
                        bottom: 5)
              ],
            ),
          ));
    }

    Widget showVehicleColor() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 35,
                  child: new TextFormField(
                    initialValue: _cartoUpdate.nvis_color,
                    enableInteractiveSelection:
                        false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: 'NVIS Color',
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFD97A00), width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  //       ),
                ),
                _confirmedVehicleColor
                    ? Positioned(
                        child: Icon(
                          Icons.check,
                          color: Colors.green[500],
                        ),
                        right: 5,
                        bottom: 5)
                    : Positioned(
                        child: _cartoUpdate.update
                            ? Icon(Icons.lock, color: Colors.green[500])
                            : Icon(
                                Icons.crop_square,
                                color: Colors.grey,
                              ),
                        right: 5,
                        bottom: 5)
              ],
            ),
          ));
    }

    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return Center(
          child: new Text(
            _errorMessage,
            style: TextStyle(
                fontSize: 13.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    Widget _showForm() {
      return new Container(
          padding: EdgeInsets.all(10.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
//                showExplanation(),
                Stack(children: <Widget>[
                  getImageWidget(),
                  _uploadVehicleimage
                      ? Align(
                          child: Uploader(uploadtask: _uploadTask),
                          alignment: Alignment.bottomCenter)
                      : Container()
                ]),
                showCapturebuttons(),
                showMessage(),
                showVehicleTypeDropdown(),
                showerrorVehicleStatus(),
                showVehicleStatus(),
                showVehicleMake(),
                showVehicleColor(),
                showErrorMessage(),
                _isChecking
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
//                showPasswordInput(),
                DetectTextinPicture(),
//                showIforgotmyPassword(),
//                showErrorMessage(),
//                showSecondaryButton(),
              ],
            ),
          ));
    }

    CustomPaint _buildResults(Size imageSize, dynamic results) {
      CustomPainter painter;

      switch (_currentDetector) {
        case Detector.barcode:
          painter = BarcodeDetectorPainter(_imageSize, results);
          break;
        case Detector.face:
          painter = FaceDetectorPainter(_imageSize, results);
          break;
        case Detector.label:
          painter = LabelDetectorPainter(_imageSize, results);
          break;
        case Detector.cloudLabel:
          // Label Results in results
          painter = LabelDetectorPainter(_imageSize, results);
          break;
        case Detector.text:
          painter = TextDetectorPainter(_imageSize, results);
          break;
        case Detector.cloudText:
          painter = TextDetectorPainter(_imageSize, results);
          break;
        default:
          break;
      }

      return CustomPaint(
        painter: painter,
      );
    }

    Widget _buildImage() {
      return Container(
        constraints: const BoxConstraints.expand(),
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: Image.file(_selectedFile).image,
//            fit: BoxFit.fill,
//          ),
//        ),
        child: _buildResults(_imageSize, _scanResults),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MAIN_COLOR, //change your color here
        ),
//        leading: new IconButton(
//          icon: new Icon(Icons.arrow_back, color: Colors.orange),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: _cartoUpdate.update
            ? Text(
                "View Vehicle",
                style: TextStyle(color: Colors.black),
              )
            : Text(
                "Add Vehicle",
                style: TextStyle(color: Colors.black),
              ),
        elevation: 0,
        actions: <Widget>[showLogo()],
      ),
      body: Stack(children: <Widget>[
        _showForm(),
        _showCircularProgress(),
//        _selectedFile == null
//            ? const Positioned(
//                top: 100,
//                left: 150,
//                right: 0,
//                child: Text('No image selected.'))
//            : _buildImage(),
      ]),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class Uploader extends StatefulWidget {
//  final File file;
  StorageUploadTask uploadtask;
  Uploader({Key key, this.uploadtask}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
//  StorageUploadTask _uploadTask;

  @override
  Widget build(BuildContext context) {
    if (widget.uploadtask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: widget.uploadtask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (widget.uploadtask.isComplete) Text('Picture Uploaded !'),
                if (widget.uploadtask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: widget.uploadtask.resume,
                  ),

                if (widget.uploadtask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: widget.uploadtask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return Container();
//        FlatButton.icon(
//        label: Text('Upload to Firebase'),
//        icon: Icon(Icons.cloud_upload),
//        onPressed: _startUpload,
//      );
    }
  }
}

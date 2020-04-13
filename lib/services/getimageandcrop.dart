import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_paul_test/utils/const.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File> getImage(ImageSource source) async {
//    this.setState(() {
//      _inProcess = true;
//    });
  File _result;
  await ImagePicker.pickImage(source: source).then((File image) async {
    if (image != null) {
      await ImageCropper.cropImage(
          sourcePath: image.path,
//          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: MAIN_COLOR,
            toolbarTitle: "Adjust your Image",
            statusBarColor: MAIN_COLOR,
            backgroundColor: Colors.white,
          )).then((File cropped) {
        _result = cropped;
      });
    }
  });
  return _result;
}

import 'package:flutter/material.dart';

Widget showCircularProgress(bool _isLoading) {
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

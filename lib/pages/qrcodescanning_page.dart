import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePage createState() => _QRCodePage();
}

class _QRCodePage extends State<QRCodePage> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: Image.memory(bytes),
            ),
            Text('RESULT  $barcode'),
            RaisedButton(onPressed: _scan, child: Text("Scan")),
            RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
            RaisedButton(
                onPressed: _generateBarCode, child: Text("Generate Barcode")),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }

  Future _generateBarCode() async {
    Uint8List result = await scanner
        .generateBarCode('https://github.com/leyan95/qrcode_scanner');
    this.setState(() => this.bytes = result);
  }
}

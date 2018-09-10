import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BarcordReader extends StatefulWidget {
  @override
  _BarcordReaderState createState() => _BarcordReaderState();
}

class _BarcordReaderState extends State<BarcordReader> {

  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  File galleryFile;

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
// maxHeight: 50.0,
// maxWidth: 50.0,
    );
    print("You selected gallery image : " + galleryFile.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.account_circle, color: Colors.grey, size: 35.0,),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(FontAwesomeIcons.userFriends, color: Colors.blue,),
          )
        ],
      ),
      body: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new RaisedButton(
                    onPressed: barcodeScanning,
                    child: new Text("Capture image")
                ),
                padding: const EdgeInsets.all(8.0),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              new Text("Barcode Number after Scan : " + barcode),
              // displayImage(),
            ],
          ),
      ),
    );
  }

  Widget displayImage() {
    return new SizedBox(
      height: 300.0,
      width: 400.0,
      child: galleryFile == null ? new Text('Sorry nothing to display') : new Image.file(galleryFile),
    );
  }

// Method for scanning barcode....
  Future barcodeScanning() async {
//imageSelectorGallery();

    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
      'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

}



import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReaderCode(),
    ),
  );
}

class ReaderCode extends StatefulWidget {
  @override
  ReaderCodeState createState() => ReaderCodeState();
}

class ReaderCodeState extends State<ReaderCode> {
  String result = "";

  Future scancodes() async {
    try {
      ScanResult qrcoderes = await BarcodeScanner.scan();
      if (qrcoderes.type == ResultType.Barcode)
        setState(() {
          result = qrcoderes.rawContent;
        });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = 'The user not allowed access to camera';
        });
      } else {
        setState(() {
          result = 'Unknown error';
        });
      }
    } on FormatException {
      setState(() {
        result = 'Back button pressed before scanning';
      });
    } catch (e) {
      setState(() {
        result = 'Unknown error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/image.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 100,
                    ),
                    height: 300,
                    width: 320,
                    child: Image.asset(
                      'images/LCD.jpg',
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 130,
                      ),
                      height: 200,
                      width: 310,
                      child: result == ""
                          ? Container(
                              width: 150,
                              height: 200,
                              child: Icon(
                                Icons.videocam,
                                color: Colors.white,
                              ),
                            )
                          : Container(),
                    ),
                    onPressed: () {
                      scancodes();
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Text(
                    '$result',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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

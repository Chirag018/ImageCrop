import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imag Crop',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _selectedFile;
  bool _isProcess = false;

  // ignore: missing_return
  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/placeholder.jpg',
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  dynamic getImage(ImageSource source) async {
    this.setState(() {
      _isProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 100,
        maxHeight: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: 'CM Cropper',
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ),
      );
      this.setState(() {
        _selectedFile = cropped;
        _isProcess = false;
      });
    } else {
      this.setState(() {
        _isProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getImageWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  color: Colors.green,
                  child: Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  color: Colors.red,
                  child: Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        (_isProcess)
            ? Container(
              color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center()
      ],
    ));
  }
}

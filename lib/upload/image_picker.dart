import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(ImagePickerApp());

class ImagePickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Imagepicker Widget',
      home: ImagePickerWidget(),
    );
  }
}

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget({Key key}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State {

  File _image;
  @override
  void initState() {
    super.initState();
  }

  void open_camera()
  async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });

  }
  void open_gallery()
  async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sample Imagepicker Widget"),
          backgroundColor: Colors.black45,),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.black12,
                  height: 300.0,
                  width: 900.0,
                  child: _image == null ? Text("Still waiting!") : Image.file(_image),),
                FlatButton(
                  color: Colors.deepOrangeAccent,
                  child: Text("Open Camera", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    open_camera();
                  },),
                FlatButton(
                  color: Colors.limeAccent,

                  child:Text("Open Gallery", style: TextStyle(color: Colors.black),),
                  onPressed: (){
                    open_gallery();
                  },
                )
              ],
            ),
          ),
        )

    );

  }
}
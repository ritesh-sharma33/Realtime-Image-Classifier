import 'package:camera/camera.dart';
import 'package:realtime_image_classifier/label_widge.dart';

import 'camera.dart';
import 'package:flutter/material.dart';
import 'package:realtime_image_classifier/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class CameraPage extends StatefulWidget {
  final CameraDescription cameras;

  CameraPage(this.cameras);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  loadModel() async {
    String res;

    res = await Tflite.loadModel(
        model: "assets/mobilenet.tflite",
        labels: "assets/mobilenet_labels.txt");

    setState(() {
      _model = "MobileNet";
    });

    print(res);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Camera(widget.cameras, _model, setRecognitions),
        LabelWidget(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
            _model)
      ],
    );
  }
}

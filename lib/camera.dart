import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final CameraDescription cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  bool isAllOkay = true;

  @override
  void initState() {
    if (widget.cameras == null) {
      print('No camera is found');
    } else {
      controller =
          new CameraController(widget.cameras, ResolutionPreset.low);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }

        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            int startingTime = new DateTime.now().millisecondsSinceEpoch;

            Tflite.detectObjectOnFrame(
                    bytesList: img.planes.map((plane) {
                      return plane.bytes;
                    }).toList(),
                    imageHeight: img.height,
                    imageWidth: img.width,
                    imageMean: 127.5,
                    imageStd: 127.5,
                    numResultsPerClass: 1,
                    threshold: 0.4)
                .then((recognitions) {
              int endTime = new DateTime.now().millisecondsSinceEpoch;
              print("Detection took ${endTime - startingTime}");

              widget.setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
          }
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var tmp = controller.value.previewSize;
    var previewHeight = tmp.height;
    var previewWidth = tmp.width;
    var screenRatio = screenHeight / screenWidth;
    var previewRatio = previewHeight / previewWidth;

    return OverflowBox(
      maxHeight: screenRatio > previewRatio
          ? screenHeight
          : screenWidth / previewWidth * previewHeight,
      maxWidth: screenRatio > previewRatio
          ? screenHeight / previewHeight * previewWidth
          : screenWidth,
      child: CameraPreview(controller),
    );
  }
}

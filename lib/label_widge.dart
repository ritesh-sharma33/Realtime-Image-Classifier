import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {

  final List<dynamic> results;
  final int previewHeight;
  final int previewWidth;
  final double screenHeight;
  final double screenWidth;
  final String model;
  
  LabelWidget(this.results, this.previewHeight, this.previewWidth, this.screenHeight, this.screenWidth, this.model);

  List<Widget> _showStrings() {
    double offset = -10;
    return results.map((result) {
      offset = offset + 14;
      return Positioned(
        left: 10,
        top: offset,
        height: screenHeight,
        width: screenWidth,
        child: Text(
          "${result["label"]} ${(result["confidence"] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            color: Colors.red,
            fontSize: 14.0,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _showStrings()
    );
  }
}
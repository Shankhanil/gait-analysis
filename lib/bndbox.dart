// import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'models.dart';

class BndBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      this.model);
  double calculateDistance(double x1, double y1, double x2, double y2){
    var xdist = pow( (x1-x2), 2);
    var ydist = pow((y1-y2), 2);
    return sqrt( (xdist + ydist) );
  }
  // 0  nose,
  // 1  leftEye, 2  rightEye
  // 3  leftEar, 4  rightEar
  // 5  leftShoulder, 6  rightShoulder
  // 7  leftElbow, 8  rightElbow
  // 9  leftWrist,  10 rightWrist
  // 11 leftHip, 12 rightHip
  // 13 leftKnee, 14 rightKnee
  // 15 leftAnkle, 16 rightAnkle
  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      results.forEach((re) {
        // re["keypoints"].values.forEach((k) {
        //   print( "${ k["part"] } *************************************\n");
        // });
        // calculate gait patterns
        var leftAnkle = re["keypoints"].values.elementAt(15);
        var rightAnkle = re["keypoints"].values.elementAt(16);
        var leftKnee = re["keypoints"].values.elementAt(13);
        var rightKnee = re["keypoints"].values.elementAt(14);

        double endPoint = (leftAnkle["y"]+rightAnkle["y"])/2;

        // print gait patterns
        print("******************************************");
        print("distance between of ${leftKnee["part"]} and ${rightKnee["part"]} "
            "is ${ calculateDistance(leftKnee["x"], leftKnee["y"], rightKnee["x"], rightKnee["y"]) }");
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
        // map keypoints
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            var difW = (scaleW - screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            var difH = (scaleH - screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          // return
          return KeyPointsInfo(x: x, y: y, keypoint: k["part"]);
        }).toList();
        lists..addAll(list);
      });
      return lists;
    }

    return Stack(
      children: [
        // KeyPointsInfo(keypoint: "ONE", x: 50.0, y: 50.0,height: 50,),
        // KeyPointsInfo(keypoint: "TWO", x: 50.0, y: 70.0,),
        // KeyPointsInfo(keypoint: "THREE", x: 50.0, y: 100.0,),
        Stack(children: model == posenet ? _renderKeypoints() : null),
      ],
    );
  }
}
 
class KeyPointsInfo extends StatelessWidget {
  const KeyPointsInfo({
    Key key,
    @required this.x,
    @required this.y,
    this.width,
    this.height,
    @required this.keypoint,
  }) : super(key: key);

  final x;
  final y;
  final keypoint;
  final width, height;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 6,
      top: y - 6,
      width: 100,
      height: 12,
      child: Container(
        child: Text(
          // "● ${k["part"]}",
          " ● $keypoint ",
          style: TextStyle(
            // color: Color.fromRGBO(37, 213, 253, 1.0),
            color: Colors.black,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}

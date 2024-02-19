// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:io';

import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class ImageRecognitionWidget extends StatefulWidget {
  const ImageRecognitionWidget({
    Key? key,
    this.width,
    this.height,
    this.imageURL,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? imageURL;

  @override
  State<ImageRecognitionWidget> createState() => _ImageRecognitionWidgetState();
}

class _ImageRecognitionWidgetState extends State<ImageRecognitionWidget> {
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  List? _recognitions;

  @override
  void initState() {
    super.initState();
    _imageUrl = null; // Set to null or provide an initial URL
    loadModel();
    if (_imageUrl == null || _imageUrl!.isEmpty) {
      grabImage();
    }
  }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/images/model.tflite",
        labels: "assets/images/labels.txt",
      );
      print("Loaded model: $res");
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> grabImage() async {
    String? imageId = await ImageDownloader.downloadImage(_imageUrl!);
    if (imageId == null) {
      return;
    }
    String? path = await ImageDownloader.findPath(imageId);
    print('Saved new image: $path');
    await recognizeImage(File(path!));
  }

  Future<void> recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    stackChildren.add(
      Center(
        child: Column(
          children: _recognitions != null
              ? _recognitions!.map((res) {
                  return Text(
                    "${res["index"]} ${res["label"]}: ${res["confidence"].toStringAsFixed(3)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      backgroundColor: Colors.white,
                    ),
                  );
                }).toList()
              : [],
        ),
      ),
    );
    return Column(
      children: stackChildren,
    );
  }
}

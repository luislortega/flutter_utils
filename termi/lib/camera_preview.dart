//an view that receive an XFile and print it on the screen
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PicturePreview extends StatelessWidget {
  final XFile picture;

  const PicturePreview({Key? key, required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("capture preview"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //show image
          child: Image.file(
            File(picture.path),
            fit: BoxFit.cover,
          ),
        ));
  }
}

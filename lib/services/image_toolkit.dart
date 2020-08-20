import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageToolkit {
  File _imageFile;

  File get imageFile {
    return this._imageFile;
  }

  Future<void> cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.png,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It',
        lockAspectRatio: false,
      ),
    );
    _imageFile = cropped;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      File selected = await ImagePicker.pickImage(source: source);
      _imageFile = selected;
      if (_imageFile != null) {
        await cropImage();
      }
    } catch (e) {
      print(e);
    }
  }
}

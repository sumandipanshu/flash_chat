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
      ImagePicker imagePicker = ImagePicker();
      PickedFile pickedFile;

      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      _imageFile = File(pickedFile.path);
      if (_imageFile != null) {
        await cropImage();
      }
    } catch (e) {
      print(e);
    }
  }

  void showMenu({BuildContext context, Function chooseImage}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(15),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                child: Text(
                  'Choose photo',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      chooseImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset(
                            'assets/images/gallery.png',
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Text(
                              'Gallery',
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      chooseImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset(
                            'assets/images/camera.png',
                            width: 60,
                            height: 60,
                          ),
                          Text(
                            'Camera',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      useRootNavigator: true,
    );
  }
}

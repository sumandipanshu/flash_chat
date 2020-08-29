import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/global.dart';
import 'package:flash_chat/routes/chat_screen.dart';
import 'package:flash_chat/services/image_toolkit.dart';
import 'package:flash_chat/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  static const String id = 'userProfile';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FocusNode addPhotoNode = FocusNode();
  String _displayName, _photoURL;
  bool error = false, uploading = false, isWaiting = false;
  File _imageFile;
  final User _user = FirebaseAuth.instance.currentUser;
  ImageToolkit imageToolkit = ImageToolkit();
  Storage storage = Storage();

  void chooseImage(ImageSource source) async {
    try {
      imageToolkit.pickImage(source);
      setState(() {
        _imageFile = imageToolkit.imageFile;
      });
      if (_imageFile != null) {
        print(_imageFile);

        setState(() {
          uploading = true;
        });
        await storage.uploadPhoto(_imageFile, _user);
        setState(() {
          uploading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        uploading = false;
      });
    }
  }

  void onSubmit() async {
    try {
      print(_displayName);
      if (_displayName == null || _displayName.isEmpty)
        throw 'Enter a valid name';
      setState(() {
        isWaiting = true;
      });
      await _user.updateProfile(displayName: _displayName, photoURL: _photoURL);
      setState(() {
        isWaiting = false;
      });
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    } catch (e) {
      print(e);
      setState(() {
        isWaiting = false;
        error = true;
      });
    }
  }

  @override
  void dispose() {
    addPhotoNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 75.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 82,
                      backgroundColor: Colors.black54,
                      child: CircleAvatar(
                        child: ClipRRect(
                          child: _photoURL == null
                              ? Image.asset(
                                  'assets/images/user.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.network(
                                  _photoURL,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        backgroundColor: Colors.white,
                        radius: 80,
                      ),
                    ),
                    Visibility(
                      visible: uploading,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.45),
                        child: CircularProgressIndicator(),
                        radius: 82,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          focusNode: addPhotoNode,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(addPhotoNode);
                            try {
                              _imageUploadPicker(context);
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            TextField(
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              decoration: kTextInputDecoration.copyWith(
                hintText: 'Enter your Display name',
                fillColor: Colors.red.withOpacity(0.35),
                filled: error,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: error ? Colors.red : kPrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: error ? Colors.red : kPrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
              onChanged: (value) {
                _displayName = value;
                setState(() {
                  error = false;
                });
              },
              onTap: () {
                setState(() {
                  error = false;
                });
              },
              onEditingComplete: onSubmit,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: onSubmit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator()),
                      ),
                      visible: isWaiting,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _imageUploadPicker(context) {
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
                  'Profile photo',
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

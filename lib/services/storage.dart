import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  String _photoURL;

  String get photoURL {
    return this._photoURL;
  }

  Future<void> uploadPhoto(File imageFile, User user) async {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://flash-chat-177ef.appspot.com');
    StorageUploadTask _uploadTask;
    String filePath = 'profilePic/${user.uid}.png';

    try {
      _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
      await _uploadTask.onComplete;
      print('File Uploaded');
      _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
        _photoURL = fileURL;
      });
    } catch (e) {
      print(e);
    }
  }
}

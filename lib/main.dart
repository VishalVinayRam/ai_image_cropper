import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  runApp(MyApp(storage: storage, firestore: firestore));
}

class MyApp extends StatelessWidget {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  const MyApp({required this.storage, required this.firestore});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ImageUploader(storage: storage, firestore: firestore),
    );
  }
}

class ImageUploader extends StatefulWidget {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  const ImageUploader({required this.storage, required this.firestore});

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 512,
        maxWidth: 512,
        compressFormat: ImageCompressFormat.jpg,
      );

      setState(() {
        _image = File(croppedFile!.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    final storageRef = widget.storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await storageRef.putFile(_image!);

    final downloadURL = await storageRef.getDownloadURL();

    final user = FirebaseAuth.instance.currentUser;
    final uid = "1";

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'uploaded_by': uid},
    );

    final docRef = widget.firestore.collection('images').doc();
    await docRef.set({
      'url': downloadURL,
      'uploaded_by': uid,
      'time_at': FieldValue.serverTimestamp(),
    });

    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) ...[
              Image.file(_image!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image'),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add),
      ),
    );
  }
}

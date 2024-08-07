import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyAmaDTXylPpK49GMbLfTBEkl_a_UTr-Ts4",
    authDomain: "fire-setup-3bdb5.firebaseapp.com",
    projectId: "fire-setup-3bdb5",
    storageBucket: "fire-setup-3bdb5.appspot.com",
    messagingSenderId: "983055968483",
    appId: "1:983055968483:web:38cc2943d27d6943d63dd6",
    measurementId: "G-TWHQ0HN7FB"));
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
  if (_image == null) return;

  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('documents/${DateTime.now().toIso8601String()}.jpg');
    final uploadTask = storageRef.putFile(_image!);

    // Wait for the upload to complete
    final snapshot = await uploadTask.whenComplete(() => null);

    // Get the download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image uploaded successfully! URL: $downloadUrl')),
    );
  } catch (e) {
    print('Error occurred while uploading the image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to upload image: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner'),
      ),
      body: Center(
        child: _image == null
            ? ElevatedButton(
                onPressed: _pickImage,
                child: Text('Scan Document'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(_image!),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Next'),
                  ),
                ],
              ),
      ),
    );
  }
}
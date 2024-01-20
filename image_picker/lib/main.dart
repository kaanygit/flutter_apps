import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker',
      home: ImagePickerApp(),
    );
  }
}

class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({Key? key}) : super(key: key);

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanetly(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print("Filed to pick image :$e");
    }
  }

  Future<File> saveFilePermanetly(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Center(
            child: Text(
              "Pick an Image",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          _image != null
              ? Image.file(
                  _image!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                )
              : Image.network('https://picsum.photos/250?image=9'),
          SizedBox(
            height: 40,
          ),
          CustomButton(
              title: 'Pick from Gallery',
              icon: Icons.image_outlined,
              onClick: () => getImage(ImageSource.gallery)),
          CustomButton(
              title: 'Pick from Camera',
              icon: Icons.camera,
              onClick: () => getImage(ImageSource.camera)),
        ],
      )),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(children: [
        Icon(icon),
        SizedBox(
          width: 20,
        ),
        Text(title)
      ]),
    ),
  );
}

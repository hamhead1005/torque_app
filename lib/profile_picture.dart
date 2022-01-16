import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class profilePicture extends StatefulWidget {
  const profilePicture({Key? key, required this.title}) : super(key: key);

  final String title;
  //Image icon;
  @override
  _profilePictureState createState() => _profilePictureState();
}

class _profilePictureState extends State<profilePicture> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final ldImage = await ImagePicker().pickImage(source: source);

      if(ldImage == null){
        return;
      }

      final imageDir = File(ldImage.path);

      setState(() {
        this.image = imageDir;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 60,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: image != null
                          ? Image.file(
                          image!,
                        width: 380,
                        height: 380,
                        fit: BoxFit.cover,
                      )
                          : Image(image: NetworkImage('https://media.istockphoto.com/vectors/transport-and-vehicle-icon-set-vector-id621474410?k=20&m=621474410&s=170667a&w=0&h=8hYTRQYwKyDXTk8mOkBd_4-uZwiu46gQ0rgbvsAtDvs=')),
                    )
                  ],
                )
            ),
            Expanded(
              flex: 20,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 60,right: 60),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                        ),
                        onPressed: () => pickImage(ImageSource.gallery),
                        child: Row(
                          children: const [
                            Icon(Icons.photo_outlined),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Pick from Gallery",
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 60,right: 60),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                        ),
                        onPressed: () => pickImage(ImageSource.camera),
                        child: Row(
                          children: const [
                            Icon(Icons.camera_alt_outlined),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Take Picture",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Expanded(
              flex: 20,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green
                    ),
                    onPressed: () {
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}

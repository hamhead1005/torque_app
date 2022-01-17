import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourqe_app/add_sections.dart';


class NewVehiclePage extends StatefulWidget {
  const NewVehiclePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NewVehiclePage> createState() => _NewVehiclePageState();
}

class _NewVehiclePageState extends State<NewVehiclePage> {
  File? image;

  String dropdownValue = "Car/Truck";
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var typeValue = "Car/Truck";
  var imageUrl = 'https://media.istockphoto.com/vectors/transport-and-vehicle-icon-set-vector-id621474410?k=20&m=621474410&s=170667a&w=0&h=8hYTRQYwKyDXTk8mOkBd_4-uZwiu46gQ0rgbvsAtDvs=';

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
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //Values from info Page will be saved into the database from the addSections page
          //This is done to avoid duplicate entries when navigating with back button

          Navigator.push(context,
              //Values from this page are passed to addSections
              MaterialPageRoute(builder: (context) => addSections(
                title: 'Add Sections of Vehicle',
                name: nameController.text,
                description: descriptionController.text,
                type: typeValue,
                image: imageUrl,
                photo: image,
              )));
        },
        label: const Text('Sections'),
        icon: const Icon(Icons.arrow_forward),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              //Holds Title

              flex: 10,
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text(
                  "Info Page",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              //Holds Image Add Button

              flex: 30,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: image != null
                      ? Image.file(
                        image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                 ): Image(image: NetworkImage('https://media.istockphoto.com/vectors/transport-and-vehicle-icon-set-vector-id621474410?k=20&m=621474410&s=170667a&w=0&h=8hYTRQYwKyDXTk8mOkBd_4-uZwiu46gQ0rgbvsAtDvs=')),
                ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightBlue
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo_rounded),
                        iconSize: 20,
                        color: Colors.white,
                        tooltip: 'Add Vehicle Photo',
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  color: Colors.lightBlueAccent,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                            flex: 20,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 60,right: 60),
                                                  child: ElevatedButton(
                                                    style: const ButtonStyle(
                                                    ),
                                                    onPressed: () {
                                                      pickImage(ImageSource.gallery);

                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.photo_outlined,),
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
                                                    onPressed: () {
                                                      pickImage(ImageSource.camera);
                                                      Navigator.pop(context);
                                                    },
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
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Expanded(
              //Holds TextFormFields and DropDown Menu

              flex: 50,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vehicle Name',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text(
                          "Select Vehicle Type:",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,),
                        ),
                      ),
                      DropdownButton<String>(
                        hint: const Text("Select Vehicle Type"),
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        style: const TextStyle(color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.blueGrey,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            typeValue = dropdownValue;
                          });
                        },
                        items: <String>['Car/Truck', 'Motorcycle', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      controller: descriptionController,
                      minLines: 5,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,  // user keyboard will have a button to move cursor to next line
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
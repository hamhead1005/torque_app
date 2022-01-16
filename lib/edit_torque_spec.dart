import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class editTorque extends StatefulWidget {
  const editTorque({Key? key,
    required this.title,
    required this.sectionid,
    required this.torqueid,
    required this.bolt,
    required this.boltUnit,
    required this.image,
    required this.name,
    required this.note,
    required this.torque,
    required this.torqueUnit,
  }) : super(key: key);

  final String title;
  final String sectionid;
  final String torqueid;
  final String bolt;
  final String boltUnit;
  final String image;
  final String name;
  final String note;
  final String torque;
  final String torqueUnit;

  @override
  _editTorqueState createState() => _editTorqueState();
}

class _editTorqueState extends State<editTorque> {
  File? image;

  String dropdownValueTorque = "ft-lbs";
  String dropdownValueSize = 'mm';

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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _boltController = TextEditingController();
  TextEditingController _torqueController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  Future<void> removeItem() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "torque/torque" + (int.parse(widget.torqueid)).toString()
    );

    await ref.remove();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _boltController.dispose();
    _torqueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = new TextEditingController(text: widget.name);
    _boltController = new TextEditingController(text: widget.bolt);
    _torqueController = new TextEditingController(text: widget.torque);
    _notesController = new TextEditingController(text: widget.note);
    dropdownValueSize = widget.boltUnit;
    dropdownValueTorque = widget.torqueUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: const TextStyle(
              fontSize: 20
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              //Contains Camera Options

              flex: 30,
              child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: image != null
                          ? Image.file(
                        image!,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ): Image(
                          image: NetworkImage(
                              'https://uxwing.com/wp-content/themes/uxwing/download/33-tools-equipment-construction/bolt.png')
                        , width: 180,
                      height: 180,),
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
              // child: Container(
              //   width: 180,
              //   margin: const EdgeInsets.only(top: 20, bottom: 40),
              //   color: Colors.blueGrey,
              //   child: IconButton(
              //     icon: const Icon(Icons.add_a_photo_rounded),
              //     iconSize: 120,
              //     tooltip: 'Add Vehicle Photo',
              //     onPressed: () {
              //
              //     },
              //
              //   ),
              // ),
            ),
            Expanded(
              flex: 60,
              child: Column(
                children: [
                  Container(
                    width: 300,
                    child: TextFormField(
                      controller: _nameController,
                      //initialValue: widget.name,
                      keyboardType: TextInputType.multiline,  // user keyboard will have a button to move cursor to next line
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bolt Name',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 100,
                        height: 50,
                        child: TextFormField(
                          controller: _torqueController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Torque"
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: DropdownButton<String>(
                          hint: const Text("Display Metric"),
                          value: dropdownValueTorque,
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          style: const TextStyle(color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.blueGrey,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueTorque = newValue!;
                            });
                          },
                          items: <String>['ft-lbs', 'inch-lbs', 'Nm']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 100,
                        height: 50,
                        child: TextFormField(
                          controller: _boltController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Bolt Size"
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: DropdownButton<String>(
                          hint: const Text("Display Metric"),
                          value: dropdownValueSize,
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          style: const TextStyle(color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.blueGrey,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueSize = newValue!;
                            });
                          },
                          items: <String>['mm', 'inch']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 300,
                    height: 200,
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 5,
                      minLines: 5,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Notes"
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15, left: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red
                        ),
                        onPressed: () {
                          removeItem();
                          Navigator.pop(context);
                        },
                        child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),

                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(top: 15,bottom: 15, right: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          var timestamp = new DateTime.now().millisecondsSinceEpoch;

                          FirebaseDatabase.instance.ref().child('torque/torque' + (widget.torqueid)).set(
                              {
                                "name" : _nameController.text,
                                "torque" : _torqueController.text,
                                "torqueUnit" : dropdownValueTorque,
                                "bolt" : _boltController.text,
                                "boltUnit" : dropdownValueSize,
                                "image" : 'https://uxwing.com/wp-content/themes/uxwing/download/33-tools-equipment-construction/bolt.png',
                                "sectionid" : widget.sectionid,
                                "note" : _notesController.text,
                                "torqueid" : widget.torqueid
                              }
                          ).then((value) {
                            print("Added Successfully");
                          }).catchError((error) {
                            print("Failed to add");
                          });

                          print("Torque Spec Created");

                          Navigator.pop(context);
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
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

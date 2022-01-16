import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class addSections extends StatefulWidget {
  const addSections({Key? key,
    required this.title,
    required this.name,
    required this.type,
    required this.description,
    required this.image,
  }) : super(key: key);

  final String title;
  final String name;
  final String type;
  final String description;
  final String image;
  @override
  _addSectionsState createState() => _addSectionsState();
}

class _addSectionsState extends State<addSections> {
  List<String> sections = []; //local List sections

  final sectionNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              //Contains the add button and TextFormField

              flex: 10,
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_box),
                            iconSize: 40,
                            tooltip: 'Add Section',
                            color: Colors.green,
                            onPressed: () {
                              sections.add(sectionNameController.text);
                              sectionNameController.clear();
                              setState(() {}); //redraw screen
                            },
                          ),
                          SizedBox(
                            width: 220,
                            height: 40,
                            child: TextFormField(
                              controller: sectionNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Section Name',
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
            ),
            Expanded(
              //Contains List of Added Sections

              flex: 65,
                child: Column(
                  children: [
                    const Text(
                      "Added Sections",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: 420,
                        width: 400,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: sections.length,
                          itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey)
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.indeterminate_check_box),
                                  iconSize: 40,
                                  color: Colors.red,
                                  tooltip: 'Remove Section',
                                  onPressed: () {
                                    sections.removeAt(index);
                                    setState(() {
                                    }); //redraw screen
                                  },
                                ),
                                Container(
                                  height: 50,
                                  width: 320,
                                  alignment: Alignment.center,
                                  color: Colors.blueGrey[100],
                                  child: Text(
                                  sections[index],
                                    style: const TextStyle(
                                      fontSize: 25
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                          separatorBuilder: (BuildContext context, int index) => const Divider(), //adds visual Divider between sections
                      ),
                      ),
                    )
                  ]
                )
            ),
            Expanded(
              //Contains Finish Button
              //Also Creates Vehicle and Sections items in Database

              flex: 5,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      //Create Vehicle
                      var timestamp = DateTime.now().millisecondsSinceEpoch;
                      FirebaseDatabase.instance.ref().child('vehicles/vehicle' + timestamp.toString()).set(
                          {
                            "name" : widget.name,
                            "description" : widget.description,
                            "type" : widget.type,
                            "image" : widget.image,
                            "vehicleid" : timestamp.toString()
                          }
                      ).then((value) {
                        print("Vehicle Added Successfully");
                      }).catchError((error) {
                        print("Failed to add");
                      });

                      print("New Vehicle Created");

                      //Create Sections for Vehicle
                      for(int index = 0; index < sections.length; index++){
                        FirebaseDatabase.instance.ref().child('sections/section' + ((timestamp) + index).toString()).set(
                            {
                              "name" : sections[index],
                              "vehicleid" : timestamp.toString(),
                              "sectionid" : ((timestamp) + index).toString()
                            }
                        ).then((value) {
                          print("Section added");
                        }).catchError((error) {
                          print("section failed to add");
                        });
                      }

                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: const Text(
                      "Finish",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                )
            ),
            const Expanded(
              //Contains Bottom Note

              flex: 10,
                child: Text(
                  "note: Sections are areas of the vehicle that you will add torque specifications for (ex: engine, wheels, etc)"
                      "You can also add more sections later",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

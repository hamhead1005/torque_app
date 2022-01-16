import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class addTorque extends StatefulWidget {
  const addTorque({Key? key,
    required this.title,
    required this.sectionid
  }) : super(key: key);

  final String title;
  final String sectionid;
  @override
  _addTorqueState createState() => _addTorqueState();
}

class _addTorqueState extends State<addTorque> {
  String dropdownValueTorque = "ft-lbs";
  String dropdownValueSize = 'mm';

  var boltNameController = TextEditingController();
  var torqueController = TextEditingController();
  var boltSizeController = TextEditingController();
  var notesController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    boltNameController.dispose();
    torqueController.dispose();
    boltSizeController.dispose();
    notesController.dispose();
    super.dispose();
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
              flex: 30,
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(top: 20, bottom: 40),
                color: Colors.blueGrey,
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo_rounded),
                  iconSize: 120,
                  tooltip: 'Add Vehicle Photo',
                  onPressed: () {

                  },

                ),
              ),
            ),
            Expanded(
              flex: 60,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      child: TextFormField(
                        controller: boltNameController,
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
                            controller: torqueController,
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
                            controller: boltSizeController,
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
                        controller: notesController,
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
                child: Container(
                  margin: EdgeInsets.only(top: 15,bottom: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      var timestamp = new DateTime.now().millisecondsSinceEpoch;

                      FirebaseDatabase.instance.ref().child('torque/torque' + timestamp.toString()).set(
                          {
                            "name" : boltNameController.text,
                            "torque" : torqueController.text,
                            "torqueUnit" : dropdownValueTorque,
                            "bolt" : boltSizeController.text,
                            "boltUnit" : dropdownValueSize,
                            "image" : 'https://uxwing.com/wp-content/themes/uxwing/download/33-tools-equipment-construction/bolt.png',
                            "sectionid" : widget.sectionid,
                            "note" : notesController.text,
                            "torqueid" : timestamp.toString()
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
                )
            )
          ],
        ),
      ),
    );
  }
}

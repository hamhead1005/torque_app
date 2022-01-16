import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  String dropdownValueTorque = "ft-lbs";
  String dropdownValueSize = 'mm';

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

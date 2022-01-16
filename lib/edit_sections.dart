import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class editSections extends StatefulWidget {
  const editSections({Key? key,
    required this.title,
    required this.vehicleid,
  }) : super(key: key);

  final String title;
  final String vehicleid;
  @override
  _editSectionsState createState() => _editSectionsState();
}

class _editSectionsState extends State<editSections> {
  var oldSections = []; //sections already created
  var newSections = []; //new Sections we want to add
  var sections = []; //Combined old and new for display purposes
  int _initalOldValues = 0;

  Future<void> removeItem(index) async {
    //print(oldSections[index]);
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "sections/section" + (oldSections[index]['sectionid'])
    );

    await ref.remove();
    _initalOldValues--;
  }
  
  _editSectionsState(){
    FirebaseDatabase.instance.ref().child("sections").once()
        .then((datasnapshot) {
      print("loaded successfully");

      var tempSectionList = [];

      datasnapshot.snapshot.children.forEach((element) async {
        //print(element.value);
        tempSectionList.add(element.value);
      });

      for(int i = 0; i < tempSectionList.length; i++){
        if(tempSectionList[i]['vehicleid'] == widget.vehicleid){
          oldSections.add(tempSectionList[i]);
        }
      }
      //sections = tempSectionList;

      _initalOldValues = oldSections.length;
      sections = oldSections;
      setState(() {

      });
    }).catchError((error){
      print("Did not load");
      print(error);
    });


  }

  final List<int> colorCodes = <int>[600, 500, 100];

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
                              sections.add(
                                  {
                                    'name' : sectionNameController.text,
                                    "sectionid" : "temp",
                                    "vehicleid" : widget.vehicleid,
                                  }
                              );

                              newSections.add(sectionNameController.text);

                              print(newSections);
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

                                        if(index <= _initalOldValues){
                                          //Remove inital Values from OldSections list
                                          removeItem(index); //Remove from database
                                          oldSections.removeAt(index); //Remove from local list
                                        }
                                        else {
                                          //Remove New, not created yet sections from new Sections list
                                          newSections.removeAt(index-_initalOldValues);
                                          sections.removeAt(index);
                                        };

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
                                        sections[index]["name"],
                                        style: const TextStyle(
                                            fontSize: 25
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                          ),
                        ),
                      )
                    ]
                )
            ),
            Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      var timestamp = new DateTime.now().millisecondsSinceEpoch;
                      //Create Sections for Vehicle
                      for(int index = 0; index < newSections.length; index++){
                        FirebaseDatabase.instance.ref().child('sections/section' + (timestamp + index).toString()).set(
                            {
                              "name" : newSections[index],
                              "vehicleid" : widget.vehicleid,
                              "sectionid" : ((timestamp) + index).toString()
                            }
                        ).then((value) {
                          print("Section added");
                        }).catchError((error) {
                          print("section failed to add");
                        });
                      }

                      Navigator.pop(context);
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


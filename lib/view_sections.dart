import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'edit_sections.dart';
import 'torque_list.dart';

class viewSections extends StatefulWidget {
  const viewSections({Key? key,
    required this.title,
    required this.vehicleid,
  }) : super(key: key);

  final String title;
  final String vehicleid;
  @override
  _viewSectionsState createState() => _viewSectionsState();
}

class _viewSectionsState extends State<viewSections> {
  var sections = []; //list sections

  //Load Sections on Startup
  _viewSectionsState(){
    loadSections();
  }

  //load Section after additions have been made on editSections page
  void refresh(dynamic value){
    sections = [];
    loadSections();
  }

  //Method Load Sections for database
  void loadSections(){
    FirebaseDatabase.instance.ref().child("sections").once()
        .then((datasnapshot) {
      print("loaded successfully");

      var tempSectionList = [];

      datasnapshot.snapshot.children.forEach((element) async {
        tempSectionList.add(element.value);
      });

      //Only Get Sections that match Selected Vehicle (vehicleid)
      for(int i = 0; i < tempSectionList.length; i++){
        if(tempSectionList[i]['vehicleid'] == widget.vehicleid){
          sections.add(tempSectionList[i]);
        }
      }
      setState(() {

      });
    }).catchError((error){
      print("Did not load");
      print(error);
    });
  }

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
        title: Text(widget.title,
          style: const TextStyle(
            fontSize: 30
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          //Allow Users to edit Sections via editSections page

          Route route = MaterialPageRoute(builder: (context) => editSections(
            title: 'New Torque Spec',
            vehicleid: widget.vehicleid,
          ));

          Navigator.push(context, route).then(refresh); //call refresh method upon return
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              //Contains Search Bar

                flex: 20,
                child: Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        icon: Icon(Icons.search)
                    ),
                  ),
                )
            ),
            Expanded(
              //Contains List of Sections
              //Contains method to listTorques

                flex: 80,
                child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: 475,
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
                                    Container(
                                      height: 50,
                                      width: 382,
                                      alignment: Alignment.center,
                                      color: Colors.grey,
                                      child: TextButton(
                                        child: Text(sections[index]["name"],
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black
                                          ),
                                        ),
                                        onPressed: () {
                                          //Navigate to torque list page

                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => torqueList(
                                                title: 'Torque Specs: ',
                                                section: sections[index]['name'],
                                                sectionid: sections[index]['sectionid'],
                                              )));
                                        },
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
          ],
        ),
      ),
    );
  }
}

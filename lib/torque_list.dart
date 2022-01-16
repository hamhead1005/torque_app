import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_torque_spec.dart';
import 'edit_torque_spec.dart';

class torqueList extends StatefulWidget {
  const torqueList({Key? key,
    required this.title,
    required this.section,
    required this.sectionid
  }) : super(key: key);

  final String title;
  final String section;
  final String sectionid;
  @override
  _torqueListState createState() => _torqueListState();
}

class _torqueListState extends State<torqueList> {
  var torqueList = []; //Values from database
  String dropdownValue = 'ft-lbs';

  //Initial Load list
  _torqueListState(){
    loadList();
  }

  //Used to Load List after new Torque has been added
  FutureOr refresh(dynamic value){
    torqueList = [];
    loadList();
  }

  //Method to load Torques for this section
  void loadList(){
    FirebaseDatabase.instance.ref().child("torque").once()
        .then((datasnapshot) {
      print("loaded successfully");

      var tempTorqueList = [];

      datasnapshot.snapshot.children.forEach((element) {
        tempTorqueList.add(element.value);
      });

      //Only List TorqueSpecs for this Section via Sectionid
      for(int i = 0; i < tempTorqueList.length; i++){
        if(tempTorqueList[i]['sectionid'] == widget.sectionid){
          torqueList.add(tempTorqueList[i]);
        }
      }

      torqueList = torqueList;

      print(torqueList.length);
      setState(() {});
    }).catchError((error){
      print("Did not load");
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + widget.section,
          style: const TextStyle(
              fontSize: 20
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              //Contains Search bar

              flex: 10,
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
              //Contains List of Torque Specs in formatted view
              //Contains button to edit/delete Torque Spec

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
                          itemCount: torqueList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 382,
                                    alignment: Alignment.center,
                                    color: Colors.grey[400],
                                    child: Column(
                                      children: [
                                        Expanded(
                                          //Contains Edit Button and title

                                          flex: 20,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 130.0),
                                                child: Text(torqueList[index]['name'],
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  //Pass Values to edit page.
                                                  Route route = MaterialPageRoute(builder: (context) => editTorque(
                                                    title: 'Edit Torque Spec',
                                                    sectionid: torqueList[index]['sectionid'],
                                                    bolt: torqueList[index]['bolt'],
                                                    boltUnit: torqueList[index]['boltUnit'],
                                                    image: torqueList[index]['image'],
                                                    name: torqueList[index]['name'],
                                                    note: torqueList[index]['note'],
                                                    torque: torqueList[index]['torque'],
                                                    torqueUnit: torqueList[index]['torqueUnit'],
                                                    torqueid: torqueList[index]['torqueid'],
                                                  ));

                                                  Navigator.push(context, route).then(refresh); //load list after edits
                                                },
                                                icon: Icon(Icons.edit_outlined),
                                                color: Colors.lightBlueAccent,
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          //Contains Display info for Torque spec

                                          flex: 80,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Image(
                                                    image: NetworkImage(torqueList[index]['image']),
                                                    width: 120,
                                                    height: 120,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black),
                                                    color: Colors.white
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (
                                                          "Spec: " +
                                                              torqueList[index]['torque'] +
                                                          " " + torqueList[index]['torqueUnit']
                                                      ),
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18
                                                      ),
                                                    ),
                                                    Text(
                                                      "Size: " +
                                                      torqueList[index]['bolt'] + " " +
                                                      torqueList[index]['boltUnit'],
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18
                                                      ),
                                                    ),
                                                    Text(
                                                      "Notes: " +
                                                      torqueList[index]['note'],
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                        ),
                      ),
                    )
                  ],
                )
            ),
            Expanded(
              //Contains Add Button and metric display selector

              flex: 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(builder: (context) => addTorque(
                            title: 'New Torque Spec',
                            sectionid: widget.sectionid,
                          ));

                          Navigator.push(context, route).then(refresh);
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        hint: const Text("Display Metric"),
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        style: const TextStyle(color: Colors.blueGrey),
                        underline: Container(
                          height: 2,
                          color: Colors.blueGrey,
                        ),
                        onChanged: (String? newValue) {
                          dropdownValue = newValue!;
                          changeMetric(dropdownValue);
                        },
                        items: <String>['ft-lbs', 'inch-lbs', 'Nm']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  //Used to convert the displayed torque spec to a different metric
  void changeMetric(String tUnitvalue) {
    String ogUnit = "";
    for(int i = 0; i < torqueList.length; i++){
      ogUnit = torqueList[i]['torqueUnit'];

      //ft-lbs => Nm
      if(ogUnit == "ft-lbs" && tUnitvalue == "Nm"){
        double val = (double.parse(torqueList[i]['torque']) * 1.356);

        torqueList[i]['torque'] = val.toStringAsFixed(2);
        torqueList[i]['torqueUnit'] = tUnitvalue;
      }
      //ft-lbs -> inch-lbs
      else if(ogUnit == "ft-lbs" && tUnitvalue == "inch-lbs"){
        double val = (double.parse(torqueList[i]['torque']) * 12);

        torqueList[i]['torque'] = val.toStringAsFixed(2);
        torqueList[i]['torqueUnit'] = tUnitvalue;
      }
      //Nm --> ft-lbs
      else if(ogUnit == "Nm" && tUnitvalue == "ft-lbs"){
        double val = (double.parse(torqueList[i]['torque']) / 1.356);

        torqueList[i]['torque'] = val.toStringAsFixed(2);
        torqueList[i]['torqueUnit'] = tUnitvalue;
      }
      //Nm --> inch-lbs
      else if(ogUnit == "Nm" && tUnitvalue == "inch-lbs"){
        double val = (double.parse(torqueList[i]['torque']) * 8.8507457676);

        torqueList[i]['torque'] = val.toStringAsFixed(2);
        torqueList[i]['torqueUnit'] = tUnitvalue;
      }
      //inch-lbs --> ft-lbs
      else if(ogUnit == "inch-lbs" && tUnitvalue == "ft-lbs"){
        double val = (double.parse(torqueList[i]['torque']) / 12);

        torqueList[i]['torque'] = val.toStringAsFixed(2);
        torqueList[i]['torqueUnit'] = tUnitvalue;
      }
      //inch-lbs -> Nm
      else if(ogUnit == "inch-lbs" && tUnitvalue == "Nm"){

        double val = (double.parse(torqueList[i]['torque']) / 8.8507457676);

        torqueList[i]['torque'] = val.toStringAsFixed(2);
        torqueList[i]['torqueUnit'] = tUnitvalue;
      }

      setState(() {});
    }

  }
}

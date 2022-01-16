import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'view_sections.dart';

class VehicleViewPage extends StatefulWidget {
  const VehicleViewPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VehicleViewPage> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleViewPage> {
  var VehicleList = [];

  _VehicleViewState() {
    //Get Vehicles from Database

    FirebaseDatabase.instance.ref().child("vehicles").once()
        .then((datasnapshot) {
          print("loaded successfully");

          var tempVehicleList = [];
          datasnapshot.snapshot.children.forEach((element) {
            //print(element.value);
            tempVehicleList.add(element.value);
          });
          //print(tempVehicleList);
          VehicleList = tempVehicleList;
          setState(() {

          });
    }).catchError((error){
      print("Did not load");
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
              //Contains Tile View of Vehicles

              flex: 80,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 550,
                    width: 400,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey)
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(VehicleList.length, (index) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 60),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: const BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(
                                children: [
                                  IconButton(
                                    //icon: Image.file(File(VehicleList[index]['image'])),
                                    icon: Image.network('${VehicleList[index]['image']}'),
                                    tooltip: 'Select Vehicle',
                                    iconSize: 100,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => viewSections(
                                            title: 'Select Section',
                                            vehicleid: VehicleList[index]['vehicleid'],
                                          )));
                                    },
                                  ),
                                  Text(
                                      '${VehicleList[index]['name']}',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline
                                    ),
                                  )
                                ],
                              ),
                            )
                          );
                        }),
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

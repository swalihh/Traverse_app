import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/Addfirst.dart';
import 'package:travel_/screens/start.dart';
import 'package:travel_/widgets/recocopy.dart';

import '../widgets/alertbox_widget.dart';

// ignore: must_be_immutable
class tripdetails extends StatefulWidget {
  tripdetails({super.key, required this.userInfo, required this.tripData});
  Map<String, dynamic> userInfo;
  Map<String, dynamic> tripData;

  @override
  State<tripdetails> createState() => _tripdetailsState();
}

final _noteShowController = TextEditingController();
String? note;

class _tripdetailsState extends State<tripdetails> {
  @override
  void initState() {
    _noteShowController.text = widget.tripData[DatabaseHelper.ColumnNote];
    note = _noteShowController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double deviceheight = MediaQuery.sizeOf(context).height;
    double devicewidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Start(
                            userInfo: widget.userInfo,
                          )),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {
              showDeleteConfirmation(context, () {
                _deleteTrip(widget.tripData[DatabaseHelper.ColumnTripId]);
              });
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
        backgroundColor: Colors.black,
        title: Text(
          widget.tripData['Ending'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              Container(
                  height: 205,
                  child: RecoCopy(
                    place: '',
                    image: widget.tripData['_image'],
                    view: '',
                  )),

              ListTile(
                textColor: const Color.fromARGB(255, 255, 254, 251),
                title: Text('Starting date'),
                subtitle: Text(widget.tripData['startdate']),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      'Ending date',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      widget.tripData['enddate'],
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          barrierColor: Color.fromARGB(185, 0, 0, 0),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
                              // Set the desired height of the BottomSheet
                              padding: EdgeInsets.all(16),
                              child:
                                  StatefulBuilder(builder: (context, refresh) {
                                return FutureBuilder<
                                        List<Map<String, dynamic>>>(
                                    future: DatabaseHelper.instance
                                        .Getcompanion(
                                            widget.tripData['userid']),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: (context, index) {
                                            final data =
                                                snapshot.data?[index] ??
                                                    [] as Map;
                                            print(companionList);
                                            //final companion = companionList[index];
                                            final companionName =
                                                data["CompanionName"] ?? '';
                                            final companionNumber =
                                                data["CompanionNum"] ?? '';
                                            return ListTile(
                                              title: Text(companionName),
                                              subtitle: Text(companionNumber),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    showDeleteConfirmation(
                                                        context, () { 
                                                      _deleteCompanion(
                                                          companionList [index][
                                                              "companionId"]); // Assuming "CompanionId" is the identifier of the companion
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  )),
                                            );
                                          },
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    });
                              }),
                            );
                          });
                    },
                    child: Text(
                      'Show Companions',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        companionList.clear();

                        final contact =
                            await FlutterContactPicker.pickPhoneContact();

                        String CompanionName = contact.fullName ?? '';
                        String CompanionNumber =
                            contact.phoneNumber?.number ?? '';
                        if (CompanionName.isNotEmpty &&
                            CompanionNumber.isNotEmpty) {
                          final row = {
                            "CompanionName": CompanionName,
                            "CompanionNum": CompanionNumber,
                            "TripId": widget.tripData['userid']
                          };
                          await DatabaseHelper.instance.insertCompanion(row);

                          print('$CompanionName==$CompanionNumber');
                          print('added ${companionList.length}');
                        } else {
                          print('List is Empty');
                        }
                      },
                      icon: Icon(Icons.group_add_outlined),
                      label: Text('Add Companion'))
                ],
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Trip Budget :",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.tripData['Budget'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                width: devicewidth,
                height: devicewidth / 2 - 6 * 20,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 79, 116),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),

              // Row(
              //   children: [
              //     ExpenseWidget(
              //         first: 'Trip\nBudget',
              //         cash: widget.tripData['Budget'],
              //         last: 'Balance:1500'),
              //     SizedBox(
              //       width: 35,
              //     ),
              //     TripExp()
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                  textColor: Colors.white,
                  title: Text('Note'),
                  trailing: IconButton(
                      onPressed: () {
                        noteBottomSheet();
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ))),

              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 255, 255, 255))),
                child: TextFormField(
                  controller: _noteShowController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  maxLines: 5,
                  maxLength: 500,
                ),
              ),

              // ListTile(
              //    textColor: Colors.white,
              //   title: Text('Photos'),
              //   trailing: IconButton(onPressed: (){}, icon: Icon(Icons.add_photo_alternate_outlined,  color: Colors.white,)),
              // )

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Addfirst(
                        userinfo: widget.userInfo,
                      );
                    }));
                  },
                  child: Text('Add more trips'))
            ],
          ),
        ),
      ),
    );
  }

  noteBottomSheet() async {
    final result = await showModalBottomSheet(
      barrierColor: Color.fromARGB(209, 0, 0, 0),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(0, 209, 189, 189))),
                    child: Form(
                      child: TextFormField(
                        controller: _noteShowController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        maxLines: 10,
                        maxLength: 500,
                      ),
                    ),
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        final notes = _noteShowController.text;
                        await DatabaseHelper.instance
                            .UpdateTripdata(notes, widget.tripData["userid"]);

                        // No setState here, it's moved below after the showModalBottomSheet

                        Navigator.of(context).pop(notes);
                      },
                      icon: Icon(
                        Icons.done,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      label: Text(
                        'SAVE NOTES',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );

    // Update the UI with the new notes after the modal bottom sheet is closed
    if (result != null) {
      setState(() {
        note = result;
      });
    }
  }

  void showDeleteConfirmation(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertBox(
          message: 'Delete this companion?',
          onCancelPressed: () {
            Navigator.of(context).pop();
          },
          onDeletePressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _deleteTrip(int tripId) async {
    final result = await DatabaseHelper.instance.deleteTrip(tripId);

    if (result > 0) {
      // Trip deleted successfully, navigate back or show a message
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Start(
                    userInfo: widget.userInfo,
                  )),
          (route) => false);
    } else {
      // Failed to delete the trip, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the trip.')),
      );
    }
  }
  Future<void> _deleteCompanion(int companionId) async {
  final result = await DatabaseHelper.instance.deleteComapanion(companionId);

  if (result > 0) {
    // Companion deleted successfully, refresh the companion list or show a message
    setState(() {
      companionList.removeWhere((companion) => companion["CompanionId"] == companionId);
    });
  } else {
    // Failed to delete the companion, show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete the companion.')),
    );
  }
}
}

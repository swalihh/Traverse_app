import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travel_/screens/Addfirst.dart';
import 'package:travel_/screens/photoView.dart';
import 'package:travel_/widgets/expence_ongoing_widget.dart';
import 'package:travel_/widgets/expenswdgt.dart';

import '../database/DatabaseHelper.dart';
import '../widgets/Reco.dart';
import '../widgets/alertbox_widget.dart';
import '../widgets/otherexpence.dart';
import '../widgets/textformfileldWidget.dart';
import 'start.dart';


class Ongoing extends StatefulWidget {
  Ongoing({
    super.key,
    required this.userInfo,
    required this.tripData,
    required this.expensedata
  });
  final Map<String, dynamic> userInfo;
 final Map<String, dynamic> tripData;
 Map<String, dynamic>? expensedata;
 

  @override
  State<Ongoing> createState() => _OngoingState();
}

final _OngoingnoteShowController = TextEditingController();

String? note;
late String tripName;
late String tripDate;
late String tripBudget;
double? mainexp;
int? upcoming;
int? finished;
class _OngoingState extends State<Ongoing> {
  List<XFile> selectedImages = [];

  @override
  void initState() {
     getExpence();
    _loadImagesFromDatabase();
    _OngoingnoteShowController.text =
        widget.tripData[DatabaseHelper.ColumnNote];
    note = _OngoingnoteShowController.text;
    tripName = widget.tripData['Ending'];
    tripDate = widget.tripData['enddate'];
    tripBudget = widget.tripData['Budget'];
    super.initState();
  }


  Widget build(BuildContext context) {
     double deviceheight = MediaQuery.sizeOf(context).height;
    double devicewidth = MediaQuery.sizeOf(context).width;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context,true);
        }, icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                final val =
                    editTripDetails(context, widget.tripData, widget.userInfo);
                if (val) {
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              )),
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
          tripName,
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
                  height: 150,
                  child: Reco(
                    place: '',
                    image: widget.tripData['_image'],
                    view: '',
                  )),
              ListTile(
                textColor: const Color.fromARGB(255, 255, 254, 251),
                title: Text('Starting date'),
                subtitle: Text(widget.tripData["startdate"]),
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
                      tripDate,
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
                                return ListView.builder(
                                  itemCount: companionList.length,
                                  itemBuilder: (context, index) {
                                    print(companionList);
                                    final companion = companionList[index];
                                    final companionName =
                                        companion["CompanionName"] ?? '';
                                    final companionNumber =
                                        companion["CompanionNumber"] ?? '';
                                    return ListTile(
                                      title: Text(companionName),
                                      subtitle: Text(companionNumber),
                                      trailing: IconButton(
                                          onPressed: () {
                                            showDeleteConfirmation(context, () {
                                              refresh(() {
                                                companionList.removeAt(index);
                                              });
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          )),
                                    );
                                  },
                                );
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
                        final contact =
                            await FlutterContactPicker.pickPhoneContact();

                        String CompanionName = contact.fullName ?? '';
                        String CompanionNumber =
                            contact.phoneNumber?.number ?? '';
                        if (CompanionName.isNotEmpty &&
                            CompanionNumber.isNotEmpty) {
                          companionList.add({
                            "CompanionName": CompanionName,
                            "CompanionNumber": CompanionNumber,
                          });

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
                height: 20,
              ),
              Row(
                children: [
                  ExpenseWidget(
                      first: 'Trip\nBudget',
                      cash: tripBudget,
                      last: ''),
                  SizedBox(
                    width: 35,
                  ),
                  InkWell(
                    onTap: () {
                       showModalBottomSheet(
                      backgroundColor: Colors.black,
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              height: 320,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Title(
                                          color: Colors.white,
                                          child: Text(
                                            'Totel Expences',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ))),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OtherExpense(
                                        food: 'Hotel',
                                            
                                        icons: Icons.hotel,
                                        money: widget.expensedata?['hotel'] ?? '0',
                                      ),
                                      OtherExpense(
                                        food: 'Food',
                                        icons: Icons.food_bank,
                                        money: widget.expensedata?['food']??'0',
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OtherExpense(
                                        food: 'Travel',
                                        icons: Icons.airport_shuttle,
                                        money: widget.expensedata?['travel']??'0',
                                      ),
                                      OtherExpense(
                                        food: 'Others',
                                        icons: Icons.open_with_rounded,
                                        money:widget.expensedata?['others']??'0',
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    height: 50,
                                    color:
                                        const Color.fromARGB(255, 184, 79, 116),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Totel expence :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          widget.expensedata?['Expence']??'0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      height: 143,
                      width: 155,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip Expenses',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                            Text(
                              widget.expensedata!['Expence']??'0',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                           Center(child: Text('Tap to view'))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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
                    ),
                  )),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 255, 255, 255))),
                child: TextFormField(
                  controller: _OngoingnoteShowController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  maxLines: 5,
                  maxLength: 500,
                ),
              ),
              ListTile(
                textColor: Colors.white,
                title: Text('Photos'),
                trailing: IconButton(
                    onPressed: () async {
                      final pickedImages = await ImagePicker().pickMultiImage();
                      if (pickedImages.isNotEmpty) {
                        setState(() {
                          selectedImages.addAll(pickedImages);
                        });

                        final tripId =
                            widget.tripData[DatabaseHelper.ColumnTripId];
                        await insertSelectedImagesToDatabase(tripId);
                      }
                    },
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.white,
                    )),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 10.0,
                children: List.generate(
                  selectedImages.length,
                  (index) {
                    final imagePath = selectedImages[index].path;

                    return GestureDetector(
                      onTap: () {
                        openImageViewPage(imagePath,  widget.tripData[DatabaseHelper.ColumnTripId]);
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
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

  void showDeleteConfirmation(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertBox(
          message: 'Are you sure?',
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
                        controller: _OngoingnoteShowController,
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
                        final notes = _OngoingnoteShowController.text;
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

  // Function to delete the trip from the database
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

  bool editTripDetails(BuildContext context, Map<String, dynamic> tripData,
      Map<String, dynamic> userInfo) {
    TextEditingController TripName = TextEditingController();
    TripName.text = tripName;

    TextEditingController StartingDate = TextEditingController();
    StartingDate.text = widget.tripData['startdate'].toString();

    TextEditingController Endingdate = TextEditingController();
    Endingdate.text = tripDate;

    TextEditingController TripBudget = TextEditingController();

    TripBudget.text = tripBudget;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, refresh) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: SingleChildScrollView(
                child: Container(
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Your Destiny',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                        controller: TripName,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Change Your End Date',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                          onTap: () async {
                            DateTime? Pickeddate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2075));
                            if (Pickeddate != null) {
                              print(Pickeddate);
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(Pickeddate);
                              refresh(() {
                                Endingdate.text = formattedDate;
                              });
                            }
                          },
                          controller: Endingdate),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Add Budget',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(controller: TripBudget),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              DatabaseHelper.instance.updateTrip(
                                widget.tripData[DatabaseHelper.ColumnTripId],
                                TripName.text,
                                Endingdate.text,
                                TripBudget.text,
                              );

                              // Close the bottom sheet
                              Navigator.of(context).pop();

                              setState(() {
                                tripName = TripName.text;
                                tripDate = Endingdate.text;
                                tripBudget = TripBudget.text;
                              });

                              // Refresh the UI with the updated data if needed
                            },
                            child: Text('DONE')),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
    return true;
  }

  Future<void> insertSelectedImagesToDatabase(int tripId) async {
    print(',,,');
    for (var image in selectedImages) {
      await DatabaseHelper.instance.insertPhotoToAlbum(tripId, image.path);
    }
  }

  Future<void> _loadImagesFromDatabase() async {
    final tripId = widget.tripData[DatabaseHelper.ColumnTripId];
    final images = await DatabaseHelper.instance.getAlbumImages(tripId);
    setState(() {
      selectedImages = images.map((path) => XFile(path)).toList();
    });
  }

  void openImageViewPage(String imagePath, int tripId) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ImageViewPage(imagePath: imagePath, tripId: tripId),
    ),
  );
}
  getExpence() async {
    final exp =
        await DatabaseHelper.instance.getExpences(widget.tripData['userid']);

    setState(() {});
    if (exp != null) {
      final expMapList = exp
          .toList(); // Convert the QueryResultSet to a List<Map<String, dynamic>>
      if (expMapList.isNotEmpty) {
        setState(() {
          widget.expensedata = expMapList
              .first; // Assuming you want to use the first item in the list
        });
      }
    }

    print('*****');
    print(exp);
  }
   double _calculateTotalExpenses(List<Map<String, dynamic>> expenses) {
    double totalExpenses = 0.0;
    for (var expense in expenses) {
      totalExpenses +=
          double.parse(expense[DatabaseHelper.ColumnExpence] as String);
    }
    return totalExpenses;
  }
   

}

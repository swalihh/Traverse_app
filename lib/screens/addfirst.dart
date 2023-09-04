import 'dart:io';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/addfinal.dart';
import 'package:travel_/widgets/imagecrop.dart';
import '../widgets/alertbox_widget.dart';
import '../widgets/textfield.dart';

List<Map<String, dynamic>> companionList = [];

class Addfirst extends StatefulWidget {
    Addfirst({super.key, required this.userinfo});
  final   Map<String,dynamic> userinfo;

  @override
  State<Addfirst> createState() => _AddfirstState();
}

XFile? imagefile;
bool ImageCheck = false;
final Formkey2 = GlobalKey<FormState>();

class _AddfirstState extends State<Addfirst> {
  final _stratingpointController = TextEditingController();
  final _destinyController = TextEditingController();
  final _startingdateController = TextEditingController();
  final _enddateController = TextEditingController();
  Map<String, dynamic> addtripdata = {};
  String? CoverImage;
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.sizeOf(context).height;
    double devicewidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(leading: null,
      //   backgroundColor: Colors.black,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Form(
            key: Formkey2,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: devicewidth,
                  height: devicewidth/3-70,
                ),
                Text(
                  'Add Your Trip\nDetails   ',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () async {
                      XFile? selectedImage = await ImagePickerService()
                          .pickCropImage(
                              cropAspectRatio:
                                  CropAspectRatio(ratioX: 16, ratioY: 9),
                              imageSource: ImageSource.gallery);
                      if (selectedImage != null) {
                        ImageCheck = true;

                        String ImagePath = selectedImage.path;
                        print(ImagePath);
                        setState(() {
                          this.CoverImage = ImagePath;
                        });
                      } else {
                        ImageCheck = false;
                        imagefile = null;
                        setState(() {
                          this.CoverImage = null;
                        });
                      }
                    },
                    child: CoverImage == null
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 184, 79, 116)),
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            width: devicewidth,
                            height: deviceheight / 3 - 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add cover photo',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22),
                                )
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(CoverImage!)),
                                    fit: BoxFit.cover),
                                border: Border.all(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            width: devicewidth,
                            height: deviceheight / 3 - 160,
                          )),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                        return 'please fill the field';
                      } else {
                        return null;
                      }
                    },
                    controller: _stratingpointController,
                    icon: Icons.location_on,
                    label: 'Enter your starting point'),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                        return 'please fill the field';
                      } else {
                        return null;
                      }
                    },
                    controller: _destinyController,
                    icon: Icons.location_on,
                    label: 'Enter your Destiny'),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    onTap: () async {
                      DateTime? Pickeddate = await showDatePicker(
                        
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2075));
                      if (Pickeddate != null) {
                        setState(() {
                          _startingdateController.text =
                              DateFormat('yyyy-MM-dd').format(Pickeddate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill the field';
                      }

                      return null;
                    },
                    controller: _startingdateController,
                    icon: Icons.calendar_today_rounded,
                    label: 'Enter starting date'),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    onTap: () async {
                      DateTime? Pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2075));
                      if (Pickeddate != null) {
                        setState(() {
                          _enddateController.text =
                              DateFormat('yyyy-MM-dd').format(Pickeddate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill the field';
                      }

                      return null;
                    },
                    controller: _enddateController,
                    icon: Icons.calendar_today_rounded,
                    label: 'Enter ending date'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Choose Your Companion',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 20,
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
                                // height: 300,
                                // Set the desired height of the BottomSheet
                                padding: EdgeInsets.all(16),
                                child: StatefulBuilder(
                                    builder: (context, refresh) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: companionList.length,
                                    itemBuilder: (context, index) {
                                      print(companionList);
                                      final companion = companionList[index];
                                      final companionName =
                                          companion["CompanionName"] ?? '';
                                      final companionNumber =
                                          companion["CompanionNum"] ?? '';
                                      return ListTile(
                                        title: Text(companionName),
                                        subtitle: Text(companionNumber),
                                        trailing: IconButton( 
                                            onPressed: () {
                                              showDeleteConfirmation(context,
                                                  () {
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
                              "CompanionNum": CompanionNumber,
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
                  height: 30,
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          _Allform();
                        },
                        child: Text("Continue"))),
                SizedBox(
                  height: 30,
                ),
                LinearPercentIndicator(
                  lineHeight: 10,
                  percent: 0.5,
                  progressColor: Color.fromARGB(255, 184, 79, 116),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Adddb() async {
    final _starting = _stratingpointController.text;
    final _ending = _destinyController.text;
    final _startdate = _startingdateController.text;
    final _enddate = _enddateController.text;
    String? ImagePath = CoverImage;

    //creating map

    addtripdata[DatabaseHelper.Columnstarting] = _starting;
    addtripdata[DatabaseHelper.ColumnEnding] = _ending;
    addtripdata[DatabaseHelper.Columnstartdate] = _startdate;
    addtripdata[DatabaseHelper.Columnenddate] = _enddate;
    addtripdata[DatabaseHelper.ColumnCoverphoto] = ImagePath;

    print(addtripdata);

    // to clear textfield
    setState(() {
      _startingdateController.text = '';
      _enddateController.text = '';
      _startingdateController.text = '';
      _enddateController.text = '';
    });

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Addfinal(
        addtripdata: addtripdata,
        userInfo: widget.userinfo,
      );
    }));
  }

  void _Allform() async {
    if (Formkey2.currentState!.validate()) {
      await Adddb();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 184, 79, 116),
          elevation: 0.0,
          content: Text('Complete all Field'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
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
}

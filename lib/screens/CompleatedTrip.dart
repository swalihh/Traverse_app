import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travel_/widgets/otherexpence.dart';
import '../database/DatabaseHelper.dart';
import '../widgets/card.dart';
import 'Addfirst.dart';
import 'imageview.dart';

class CompletedTrip extends StatefulWidget {
  CompletedTrip({
    super.key,
    required this.userInfo,
    required this.tripData,
    required this.expensedata,
  });
  final Map<String, dynamic> userInfo;
  Map<String, dynamic> tripData;
  Map<String, dynamic>? expensedata;

  @override
  State<CompletedTrip> createState() => _CompletedTripState();
}

double? mainexp;
int? upcoming;
int? finished;

class _CompletedTripState extends State<CompletedTrip> {
  @override
  void initState() {
    getExpence();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.sizeOf(context).height;
    double devicewidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.tripData['Ending'],
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardd(
                  date: widget.tripData['enddate'],
                  place: '',
                  image: widget.tripData['_image']),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.black,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  height: 320,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                            money:
                                                widget.expensedata?['hotel'] ??
                                                    '0',
                                          ),
                                          OtherExpense(
                                            food: 'Food',
                                            icons: Icons.food_bank,
                                            money:
                                                widget.expensedata?['food'] ??
                                                    '0',
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
                                            money:
                                                widget.expensedata?['travel'] ??
                                                    '0',
                                          ),
                                          OtherExpense(
                                            food: 'Others',
                                            icons: Icons.open_with_rounded,
                                            money:
                                                widget.expensedata?['others'] ??
                                                    '0',
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        height: 50,
                                        color: const Color.fromARGB(
                                            255, 184, 79, 116),
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
                                              widget.expensedata?['Expence'] ??
                                                  '0',
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
                      color: const Color.fromARGB(255, 184, 79, 116),
                      width: devicewidth / 2 - 15,
                      height: deviceheight / 3 - 220,
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Text('Tap to view Expences',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color:
                                    const Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        fixedSize: Size(
                          devicewidth / 3 + 25,
                          deviceheight / 3 - 220,
                        )),
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          barrierColor: Color.fromARGB(185, 0, 0, 0),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 300,
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
                                      title: Text(
                                        companionName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(companionNumber,
                                          style:
                                              TextStyle(color: Colors.white)),
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
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text('Notes',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 255, 255, 255))),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 255, 255, 255))),
                height: devicewidth / 3 + 50,
                width: devicewidth,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.tripData['Note'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text('Photos',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 255, 255, 255))),
              SizedBox(
                height: deviceheight / 3 - 260,
              ),
              FutureBuilder<List<String>>(
                future: loadImagesForTrip(
                    widget.tripData[DatabaseHelper.ColumnTripId]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No photos available.');
                  } else {
                    return buildImageWrap(context, snapshot.data!);
                  }
                },
              ),
            ],
          ),
        ),
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

  Future<List<String>> loadImagesForTrip(int tripId) async {
    final imagePaths = await DatabaseHelper.instance.getAlbumImages(tripId);
    return imagePaths;
  }
}


Widget buildImageWrap(BuildContext context, List<String> imagePaths) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: imagePaths.map((path) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewerPage(imagePath: path),
              ),
            );
          },
          child: Image.file(
            File(path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }


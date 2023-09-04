import 'package:flutter/material.dart';

import 'package:travel_/database/DatabaseHelper.dart';

import 'package:travel_/widgets/successfultrip_future.dart';

class Gallery extends StatefulWidget {
  Gallery({super.key, required this.userInfo,    required this.tripData,
});
    final Map<String, dynamic> userInfo;
  Map<String, dynamic> tripData;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  @override
  Widget build(BuildContext context) {
    print('got in');
    DatabaseHelper.instance.readCompletedTrip(widget.userInfo['id']);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Our successful trips',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                Container(
                  child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    child: successfullTrip(UserInfo: widget.userInfo,)),
                ),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}

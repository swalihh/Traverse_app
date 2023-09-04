import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/trip_details.dart';
import 'package:travel_/widgets/horizontalcard.dart';

// ignore: must_be_immutable
class UpcomingWid extends StatefulWidget {
  UpcomingWid({super.key, required this.UserInfo});
  Map<String, dynamic> UserInfo;

  @override
  State<UpcomingWid> createState() => _UpcomingWidState();
}

class _UpcomingWidState extends State<UpcomingWid> {
  @override
  void initState() {
    super.initState();

  }

  

  @override
  Widget build(BuildContext context) {
    final userId = widget.UserInfo['id'];
    return FutureBuilder(
      future: DatabaseHelper.instance.readUpcomingTrips(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              height: 200,
              width: 600,
              child: Lottie.asset('assets/images/lottie.json'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              print(snapshot.data);
              Map<String, dynamic>? TripData = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return tripdetails(userInfo: widget.UserInfo, tripData: TripData);
                  }));
                },
                child: hrztlcard(
                    date: TripData[DatabaseHelper.Columnstartdate],
                    place: TripData[DatabaseHelper.ColumnEnding],
                    image: TripData[DatabaseHelper.ColumnCoverphoto]),
              );
            },
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.horizontal,
          );
        }
      },
    );
  }
}

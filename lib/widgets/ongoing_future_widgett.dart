import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/widgets/ongoing_view_card.dart';
import '../screens/ongoing.dart';

// ignore: must_be_immutable
class OngoingTrip extends StatefulWidget {
  OngoingTrip({super.key, required this.UserInfo});
  Map<String, dynamic> UserInfo;

  @override
  State<OngoingTrip> createState() => _UpcomingWidState();
}

class _UpcomingWidState extends State<OngoingTrip> {
  @override
  void initState() {
    super.initState();
    getUserId(); // Corrected method call
  }
  getUserId() async {
    // No need to use setState here, directly update the widget.UserInfo
    widget.UserInfo = widget.UserInfo;
  }
  @override
  Widget build(BuildContext context) {
    final userId = widget.UserInfo['id'];
    return FutureBuilder(
      future: DatabaseHelper.instance.readOngoingTrips(userId),
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

              print(TripData);
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Ongoing(
                      userInfo: widget.UserInfo,
                      tripData: TripData, expensedata: {},
                    );
                  }));
                },
                child: ongoingCard(
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

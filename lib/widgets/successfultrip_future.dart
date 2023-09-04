import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/CompleatedTrip.dart';
import 'package:travel_/widgets/successful_TripCard.dart';

class successfullTrip extends StatefulWidget {
  successfullTrip({super.key, required this.UserInfo});
   Map<String, dynamic> UserInfo;
    Map<String, dynamic>? expensedata;

  @override
  State<successfullTrip> createState() => _UpcomingWidState();
}

class _UpcomingWidState extends State<successfullTrip> {
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
      future: DatabaseHelper.instance.readCompletedTrip(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(

              child: Column(
                children: [
         Text('COMPLETED TRIPS IS EMPTY',style: TextStyle(color: Colors.amber),),

                Lottie.asset('assets/images/rkt.json'),
                ],
              ),
              color: const Color.fromARGB(255, 0, 0, 0),
              height: 200,
              width: 600,
             
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              print(snapshot.data);
              Map<String, dynamic>? TripData = snapshot.data![index];

              print(TripData);
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CompletedTrip(
                      expensedata:widget.expensedata ,
                      userInfo: widget.UserInfo,
                      tripData: TripData, 
                    );
                  }));
                },
                child: successfullTripCard(
                    date: TripData[DatabaseHelper.Columnstartdate],
                    place: TripData[DatabaseHelper.ColumnEnding],
                    image: TripData[DatabaseHelper.ColumnCoverphoto]),
              );
            },
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.vertical,
          );
        }
      },
    );
  }
}

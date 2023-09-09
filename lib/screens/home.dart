import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_/screens/ongoing.dart';
import 'package:travel_/screens/searchviewpage.dart';
import 'package:travel_/widgets/UpcomingTripWid.dart';
import 'package:travel_/widgets/drawer.dart';
import '../database/DatabaseHelper.dart';
import '../widgets/ongoing_view_card.dart';
class home extends StatefulWidget {
  home({
    super.key,
    required this.userInfo,
  });
 final Map<String, dynamic> userInfo;
//Map<String, dynamic> tripData;
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final GlobalKey<ScaffoldState> Scaffoldkey = GlobalKey<ScaffoldState>();
  void opendrawer() {
    Scaffoldkey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.sizeOf(context).height;
    // double devicewidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      key: Scaffoldkey,
      drawer: Drawers(userInfo: widget.userInfo),
      backgroundColor: Colors.black,
      appBar: AppBar(
          centerTitle: true,

        title: Text('Traverse',style: GoogleFonts.lora(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 25),),
        leadingWidth: 67,

        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: opendrawer,
            child: Icon(
              Icons.settings,
              color: Colors.white,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SearchPage(userInfo: widget.userInfo,);
              },));
            }, icon: Icon(Icons.search))
          )
        ],

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ongoing Trip',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: deviceheight / 3 - 110,
                    child: FutureBuilder(
                      future: DatabaseHelper.instance
                          .readOngoingTrips(widget.userInfo['id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                              Map<String, dynamic>? TripData =
                                  snapshot.data![index];

                              print(TripData);
                              return InkWell(
                                onTap: () async {
                                  final refresh = await Navigator.of(context)
                                      .push(
                                          MaterialPageRoute(builder: (context) {
                                    return Ongoing(
                                      userInfo: widget.userInfo,
                                      tripData: TripData,
                                       expensedata: {},
                                    );
                                  }));
                                  if ( refresh) {
                                    setState(() {});
                                  }
                                },
                                child: ongoingCard(
                                    date: TripData[
                                        DatabaseHelper.Columnstartdate],
                                    place:
                                        TripData[DatabaseHelper.ColumnEnding],
                                    image: TripData[
                                        DatabaseHelper.ColumnCoverphoto]),
                              );
                            },
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    )
                    // OngoingTrip(UserInfo: widget.userInfo,),
                    ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Upcoming Trips',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: deviceheight / 3 - 110,
                  child: UpcomingWid(UserInfo: widget.userInfo),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Recommendation',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                SizedBox(
                  height: 10,
                ),
                //        Container(
                //         height: 205,
                //  child: InkWell(
                //   onTap: () {

                //     Navigator.of(context).push(MaterialPageRoute(builder: (context){
                //       return Views();
                //     }));
                //   },
                //   child: Recomentation( place: 'London', image: 'assets/images/4.jpg', view: 'view more',))
                //       ),    Container(
                //         height: 205,
                //  child: Recomentation( place: 'Munnar', image: 'assets/images/5.jpg', view: 'view more',)
                //       ),    Container(
                //         height: 205,
                //  child: Recomentation( place: 'Bali', image: 'assets/images/6.jpg', view: 'view more',)
                //       ),    Container(
                //         height: 205,
                //  child: Recomentation( place: 'Bali', image: 'assets/images/7.jpg', view: 'view more',)
                //       ),    Container(
                //         height: 205,
                //  child: Recomentation( place: 'Bali', image: 'assets/images/8.jpg', view: 'view more',)
                //    ),
              ],
            ),
          ),
        ],
      ),
     
    );
  }
}

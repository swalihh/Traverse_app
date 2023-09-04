import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:travel_/screens/gallery.dart';
import 'package:travel_/screens/home.dart';
import 'package:travel_/screens/Addfirst.dart';
import 'package:travel_/screens/expenses.dart';

import '../database/DatabaseHelper.dart';

// ignore: must_be_immutable
class Start extends StatefulWidget {
  Map<String,dynamic> userInfo;
  Start({super.key,required this.userInfo});
  
  @override
  State<Start> createState() => _StartState();
} 


class _StartState extends State<Start> {
  int currentIndexSelect = 0;
  late final List<Widget> pages;
  void initState() {
    super.initState();
    getUserId;
    pages = [
      home(userInfo: widget.userInfo,),
      Addfirst(userinfo:widget.userInfo),
      Expenses(userInfo: widget.userInfo),
      Gallery(userInfo: widget.userInfo, tripData: {}, ),
    ];
  }

  getUserId() async  {
    final userData = await DatabaseHelper.instance.getloggeduser();
    print(userData);
    print('****************');
    setState(() {
      widget.userInfo=userData!;
    });
    
     print('^^^^^^^^^^^^^^^^^');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndexSelect],
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 33, 33, 33),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          child: GNav(
              onTabChange: (newindex) {
                setState(() {
                  currentIndexSelect = newindex;
                });
              },
              backgroundColor: Color.fromARGB(255, 33, 33, 33),
              
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: const Color.fromARGB(255, 184, 79, 116),
              padding: EdgeInsets.all(10),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: ' Home',
                ),
                GButton(
                  icon: Icons.add_box_outlined,
                  text: ' Add Trip',
                ),
                GButton(
                  icon: Icons.payments_outlined,
                  text: ' Expenses',
                ),
                GButton(
                  icon: Icons.photo_size_select_actual_outlined,
                  text: ' Gallery',
                ),
              ]),
        ),
      ),
    );
  }
}

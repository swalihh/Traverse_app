import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/appinfo.dart';
import 'package:travel_/screens/login.dart';
import 'package:travel_/screens/privacypolicy.dart';
import 'package:travel_/screens/termscnditions.dart';
import 'package:travel_/widgets/screen%20profile.dart';
import '../screens/profile.dart';

class Drawers extends StatelessWidget {
  Drawers({super.key, required this.userInfo});
  Map<String, dynamic> userInfo;

  @override
  Widget build(BuildContext context) {
     double deviceheight = MediaQuery.sizeOf(context).height;
     double devicewidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        shadowColor: Color.fromARGB(255, 239, 105, 105),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Settings',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            DrawerTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ProfilePage(userInfo: userInfo);
                }));
              },
              iconn: Icons.person_2_outlined,
              texxt: 'Personal details',
            ),
            DrawerTile(
              onTap: () {},
              iconn: Icons.delete_outline,
              texxt: 'Clear data',
            ),
            DrawerTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AppInfo();
                },));
              },
              iconn: Icons.help_outline_rounded,
              texxt: 'App info',
            ),
            DrawerTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return TermsAndConditions();
                },));
              },
              iconn: Icons.info_outline,
              texxt: 'Terms & Conditions',
            ),
            DrawerTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return PrivacyPolicy();
                },));
              },
              iconn: Icons.privacy_tip,
              texxt: 'Privacy and policy',
            ),
            DrawerTile(
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
              iconn: Icons.login_rounded,
              texxt: 'Sign out',
            ),
            SizedBox(height: deviceheight/3-200,),

            Text('Traverse 1.0',style:GoogleFonts.lora(color: const Color.fromARGB(164, 255, 255, 255),))
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Add border radius
            side: BorderSide(color: Colors.white), // Add border color
          ),
          title: Text('Logout', style: TextStyle(color: Colors.white)),
          content: Text(' you want to leave ?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseHelper.instance.logoutuser();
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                  return MyHomePage();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(184, 79, 116, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

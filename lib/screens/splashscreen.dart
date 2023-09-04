import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_/database/DatabaseHelper.dart';
import 'package:travel_/screens/login.dart';
import 'package:travel_/screens/start.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    loginornot();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Lottie.asset('assets/images/Travel.json'),
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  Future loginornot()async {
    Map<String, dynamic>?userdata =await DatabaseHelper.instance.getloggeduser();
    if(userdata!=null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        return Start(userInfo: userdata);
      },), (route) => false);
    }else{
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
        return MyHomePage();
      },), (route) => false);
    }
  }
}
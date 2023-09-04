import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DrawerTile extends StatelessWidget {
  DrawerTile(
      {super.key,
      required this.onTap,
      required this.iconn,
      required this.texxt});
  Function()? onTap;
  final IconData iconn;
  final String texxt;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconn,
        color: const Color.fromARGB(255, 255, 254, 254),
      ),
      title: Text(
        texxt,
        style: TextStyle(  
          
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
    ),
);}
}
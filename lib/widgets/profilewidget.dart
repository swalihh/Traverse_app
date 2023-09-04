import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsTile extends StatelessWidget {
  SettingsTile(
      {super.key,
      required this.icon,
      required this.text,
      this.colors,
      required this.onTap});

  final IconData icon;
  final String text;
  Color? colors;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    Color black = Colors.black;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 22, color: colors ?? black),
      title: Text(text,
          style: TextStyle(
            
            fontSize: 17,
            fontWeight: FontWeight.w700,
        )  ),
);
}
}
import 'dart:io';

import 'package:flutter/material.dart';

class hrztlcard extends StatelessWidget {
  final String date;
  final String place;
  final String image;

  const hrztlcard({super.key, required this.date, required this.place, required this.image});
  
  @override
  Widget build(BuildContext context) {
   MediaQueryData mediaQueryData = MediaQuery.of(context);

    // Get the device width from the MediaQueryData
    double deviceWidth = mediaQueryData.size.width;
    double deviceheight =mediaQueryData.size.height;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 170,
       
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Color.fromARGB(0, 0, 0, 0),
            ),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                image: FileImage(File(image )),
                fit: BoxFit.cover),
          ),
        ),
      
        Padding(
          padding: EdgeInsets.only(top:deviceheight/7+27,left: deviceWidth/30-10 ),
          child: Text(
            place,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 130, ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_sharp,
                color: Colors.white,
                size: 10,
              ),
              Text(
                date,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 10),
              )
            ],
          ),
        )
      ],
    );
  }

}

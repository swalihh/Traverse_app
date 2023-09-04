import 'dart:io';
import 'package:flutter/material.dart';

class successfullTripCard extends StatelessWidget {
  final String date;
  final String place;
  final String image;

  successfullTripCard({super.key, required this.date, required this.place, required this.image});
  
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double deviceWidth = mediaQueryData.size.width;
    double deviceheight = mediaQueryData.size.height;
    return Stack(
      children: [
        Container(
          height: 200,
          margin: EdgeInsets.only(right: 10),
          width: MediaQuery.sizeOf(context).width,
             
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
              width: 2,
            
              color: const Color.fromARGB(255, 184, 79, 116),
              
            ),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                image: FileImage(File(image)),
                fit: BoxFit.cover),
          ),
        ),
      
        Padding(
          padding:  EdgeInsets.only(left: deviceWidth/30,top: deviceheight/6+15),
          child: Text(
            place,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(top: deviceheight/35,left: deviceWidth/2+40),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_sharp,
                color: Colors.white,
                size: 13,
              ),
              Text(
                date,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 13),
              )
            ],
          ),
        )
      ],
    );
  }

}

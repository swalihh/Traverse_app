import 'dart:io';

import 'package:flutter/material.dart';

class cardd extends StatelessWidget {
  final String date;
  final String place;
  final String image;

  const cardd(
      {super.key,
      required this.date,
      required this.place,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 360,
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8 )),
            border: Border.all(
            
              color: const Color.fromARGB(255, 184, 79, 116),
              
            ), 
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.darken),
                image: FileImage(File(image)),
                fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 130,
          left: 15,
          child: Text(
            place,
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.calendar_month_sharp,
                color: Colors.white,
              ),
              Text(date,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.white)),
                      SizedBox(height: 10,)
            ],
          ),
        )
      ],
    );
  }
}



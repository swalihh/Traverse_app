

import 'dart:io';

import 'package:flutter/material.dart';

class Recomentationfinal extends StatelessWidget {
  
  final String place;
  final String image;

  const 
  Recomentationfinal(
      {super.key,
       
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
      ],
    );
  }
}

import 'package:flutter/material.dart';

class Alltrips extends StatelessWidget {
  final String first;
  final String cash;

  Alltrips({
    super.key,
    required this.first,
    required this.cash,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 143,
      width: 155,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 184, 79, 116),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              first,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              cash,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
           
          ],
        ),
      ),
    );
  }
}

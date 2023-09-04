import 'package:flutter/material.dart';

class OtherExpense extends StatelessWidget {
  final String money;
  final String food;
  final IconData icons;

  const OtherExpense({super.key, required this.money, required this.food, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 153,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              money,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  food,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Icon(icons)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TripExpe extends StatelessWidget {
  const TripExpe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                    height: 143,
                    width: 155,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trip Expenses',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w900,
                                fontSize: 18),
                          ),
                          Text(
                            '20,000',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                color: const Color.fromARGB(255, 184, 79, 116),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Add New',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
  }
}
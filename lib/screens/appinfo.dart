import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(
          'App Info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeading('About Traverse'),
            SizedBox(height: 16),
            Text(
              "Traverse App is an offline app designed to help you plan and manage your trips. It provides a user-friendly interface and a range of features to make your travel experience seamless and enjoyable.",
            style:TextStyle(color: Colors.white,fontSize: 12) ,),
            SizedBox(height: 16),
            _buildSectionHeading('Key Features'),
            SizedBox(height: 16),
            _buildFeatureParagraph(
              'Trip Organization & Details',
              'Effortlessly categorize your trips into ongoing, upcoming, and recent for better organization and planning. Add trip name, destination, dates, type, transportation method, and cover image for a comprehensive trip overview.',
            ),
            _buildFeatureParagraph(
              'Budget, Expenses & Companions',
              'Specify the number of companions, Set and manage your trip budget, track expenses, and stay within your financial limits.',
            ),
            SizedBox(height: 16),
            _buildSectionHeading('Version'),
            SizedBox(height: 16),
            Text(
              "Traverse Version 1.0",style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            _buildSectionHeading('Made in India'),
            SizedBox(height: 16),
            SizedBox(width: 15),
            Text(
              'Traverse App is proudly made in India.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String heading) {
    return Text(
      heading,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildFeatureParagraph(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          
          description,
          style: TextStyle(fontSize: 12,
          color: Colors.white),
          
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
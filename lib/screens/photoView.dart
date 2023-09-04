import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travel_/database/DatabaseHelper.dart';

class ImageViewPage extends StatelessWidget {
  final String imagePath;
  final int tripId;

   ImageViewPage({Key? key, required this.imagePath, required this.tripId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              _deletePhotoAndShowAlert(context);
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: Center(
        child: Image.file(
          File(imagePath), // Create a File object using the imagePath
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> _deletePhotoAndShowAlert(BuildContext context) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
      backgroundColor: Colors.black,
          title: Text('Delete Photo',style: TextStyle(color: Colors.white),),
          content: Text('Are you sure you want to delete this photo?',style: TextStyle(color: Colors.white),),
          actions:[
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: (){ Navigator.of(context).pop();}, child: Text('Cancel',style: TextStyle(color: Colors.black),)
            ),
            

            ElevatedButton(onPressed: ()async{await _deletePhotoFromFileSystem();

                await databaseHelper.deletePhotoFromAlbum(tripId, imagePath);

                Navigator.of(context).pop();

                Navigator.of(context).pop();}, child: Text('Delete')),
           
          ],
        );
      },
    );
  }

  Future<void> _deletePhotoFromFileSystem() async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting photo from file system: $e');
    }
  }
}

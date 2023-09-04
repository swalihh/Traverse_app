import 'package:flutter/material.dart';

class CustomAlertBox extends StatelessWidget {

  final String message;
  final VoidCallback onCancelPressed;
  final VoidCallback onDeletePressed;

  CustomAlertBox({
   
    required this.message,
    required this.onCancelPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
 
      content: Text(message,style: TextStyle(color: Colors.white),),
      actions: <Widget>[
        TextButton(
          onPressed: onCancelPressed,
          child: Text('Cancel',style: TextStyle(
            color: Colors.white
          ),),
        ),
        ElevatedButton(
          onPressed: onDeletePressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: Text('Delete'),
        ),
      ],
    );
  }
}

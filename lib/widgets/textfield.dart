import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final FormFieldValidator? validator;
  TextEditingController? controller;
  final VoidCallback? onTap;
  final bool obscureText; // New parameter for controlling text obfuscation

  CustomTextField({
    Key? key, // Adding Key parameter
    required this.icon,
    required this.label,
    required this.controller,
    this.validator,
    this.onTap,
    this.obscureText = false, // Default value is false
  }) : super(key: key); // Passing the key to the superclass constructor

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      validator: validator,
      controller: controller,
      obscureText: obscureText, // Using the provided value for text obfuscation
      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        labelText: label,
        suffixIcon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

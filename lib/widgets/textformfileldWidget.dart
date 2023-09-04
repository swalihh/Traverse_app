import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function()? onTap; 
  final bool viewOnly; 

  CustomTextFormField({
    required this.controller,
    this.hintText,
    this.validator,
    this.onTap,
    this.viewOnly = false, 
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      validator: validator,
      onTap: onTap,
      enabled: !viewOnly, 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 184, 79, 116),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

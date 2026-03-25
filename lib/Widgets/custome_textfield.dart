import 'package:flutter/material.dart';

class CustomeTextfield extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final Widget? prefixIcon;
  final TextEditingController controller;
 final  TextInputType keyboardType;

  const CustomeTextfield({super.key,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value){
          if(value==null || value.isEmpty){
            return "Please Enter $labelText";
          }
          else{
            return null;
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:product_hub/Firebase_auth_service/firebase.dart';
import 'package:product_hub/Widgets/custome_textfield.dart';

class CustomDialog extends StatelessWidget {
  final TextEditingController controller;
  final FirebaseService firebaseService;

  CustomDialog({
    super.key,
    required this.controller,
    required this.firebaseService,
  });
  final _dialogFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Reset Password"),
      content: Form(
        key: _dialogFormKey,
        child: CustomeTextfield(
          controller: controller,
          hintText: "Enter Email",
          labelText: "Email",
          obscureText: false,
          prefixIcon: Icon(Icons.email),
          keyboardType: TextInputType.emailAddress,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_dialogFormKey.currentState!.validate()) {
              String? result = await firebaseService.forgotpassword(
                controller.text.trim(),
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result ?? "Password reset link sent")),
              );
            }
          },
          child: Text("Send"),
        ),
      ],
    );
  }
}

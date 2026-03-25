import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:product_hub/Screens/auth/login_screen.dart';
import 'package:product_hub/Widgets/custome_textfield.dart';
import '../../Firebase_auth_service/firebase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();



  final _formkey = GlobalKey<FormState>();

  bool isloading = false;
  FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  creatuser() async {
    try {
      setState(() => isloading = true);

      String? result = await firebaseService.signup(email.text, password.text);

      if (result == null) {
        User? user = FirebaseAuth.instance.currentUser;
        await firebaseService.saveUserData(
          uid: user!.uid,
          name: name.text,
          email: email.text,
          phone: phone.text,
          address: address.text,
          city: city.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Signup successful! Verify email before login.",
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              result,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE0B2), // light orange
              Color(0xFFFFCC80),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4), // 🔥 changed
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6), // 🔥 changed
                    ),),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Title
                        Text(
                          "Create Account",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Sign up to get started",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 20),
                        // name
                        CustomeTextfield(
                          controller: name,
                          hintText: "Enter Name",
                          labelText: "Name",
                          obscureText: false,
                          prefixIcon: Icon(Icons.person),
                          keyboardType: TextInputType.text,
                        ),

                        CustomeTextfield(
                          controller: email,
                          hintText: "Enter Email",
                          labelText: "Email",
                          obscureText: false,
                          prefixIcon: Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        CustomeTextfield(
                          controller: phone,
                          hintText: "Enter Phone Number",
                          labelText: "Phone",
                          obscureText: false,
                          prefixIcon: Icon(Icons.phone),
                          keyboardType: TextInputType.phone,
                        ),

                        CustomeTextfield(
                          controller: password,
                          hintText: "Enter Password",
                          labelText: "Password",
                          obscureText: true,
                          prefixIcon: Icon(Icons.lock),
                          keyboardType: TextInputType.visiblePassword,
                        ),

                        CustomeTextfield(
                          controller: confirmPassword,
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          obscureText: true,
                          prefixIcon: Icon(Icons.lock),
                          keyboardType: TextInputType.visiblePassword,
                        ),

                        CustomeTextfield(
                          controller: address,
                          hintText: "Enter Address",
                          labelText: "Address",
                          obscureText: false,
                          prefixIcon: Icon(Icons.home),
                          keyboardType: TextInputType.streetAddress,
                        ),

                        CustomeTextfield(
                          controller: city,
                          hintText: "Enter City",
                          labelText: "City",
                          obscureText: false,
                          prefixIcon: Icon(Icons.location_city),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 10,),

                        /// Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Color(0xFFFFCC80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isloading
                                ? null
                                : () {
                              if (_formkey.currentState!.validate()) {

                                if (password.text != confirmPassword.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "Passwords do not match. Please check and try again.",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                creatuser();

                                password.text="";
                                confirmPassword.text="";
                              }
                                  },
                            child: isloading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Creating account...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  )
                                : Text(
                                    "Create Account",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Login Navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),)
    );
  }
}

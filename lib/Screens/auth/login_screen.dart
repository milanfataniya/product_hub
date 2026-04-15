import 'package:flutter/material.dart';
import 'package:product_hub/Firebase_auth_service/firebase.dart';
import 'package:product_hub/Screens/auth/signup_screen.dart';
import 'package:product_hub/Screens/home/home_screen.dart';
import 'package:product_hub/Screens/home/main_screen.dart';
import 'package:product_hub/Widgets/custom_dialog.dart';
import 'package:product_hub/Widgets/custome_textfield.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _dialogFormKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();

  bool isloading = false;
  FirebaseService firebaseService = FirebaseService();

  signin() async {
    try {
      setState(() => isloading = true);

      String? result =
      await firebaseService.signin(email.text, password.text);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "Login Successful",
            ),
          ),
        );
        password.clear();
        Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
        );
      } else {
        password.clear();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            result,
          ),
        ),
      );;
      }
    } catch (e) {
      password.clear();
      print(e);
    } finally {
      setState(() => isloading = false);
    }
  }

  forgotpassword()async{
    try{
      String? result=await firebaseService.forgotpassword(resetEmailController.text);
      if(result==null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("We’ve sent a password reset link to ${resetEmailController.text}. Check your email."),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(result),
          ),
        );
      }

    }
    catch(e){

    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
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

                  child: Container(
                    padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                    ),
                      ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Title
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Sign in to continue",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                  
                        const SizedBox(height: 20),
                  
                        /// Email
                        CustomeTextfield(
                          controller: email,
                          hintText: "Enter Email",
                          labelText: "Email",
                          obscureText: false,
                          prefixIcon: const Icon(Icons.email),
                          keyboardType: TextInputType.emailAddress,
                        ),
                  
                  
                        /// Password
                        CustomeTextfield(
                          controller: password,
                          hintText: "Enter Password",
                          labelText: "Password",
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                  
                        const SizedBox(height: 25),
                  
                        /// Login Button
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
                            onPressed:isloading?null: () {
                              if (_formkey.currentState!.validate()) {
                                signin();
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
                                Text("Authenticating...",style: TextStyle(color: Colors.black)),
                              ],
                            )
                                :  Text(
                              "Sign In",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                  
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            resetEmailController.clear();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  controller: resetEmailController,
                                  firebaseService: firebaseService,
                                );
                              },
                            );
                          },
                          child: Text("Forgot Password?"),
                        ),
                        /// Signup Navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen()),
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

            ),
          ),
        ),
      ),
    );
  }
}
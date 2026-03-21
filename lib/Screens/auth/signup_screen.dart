import 'package:flutter/material.dart';
import 'package:product_hub/Screens/auth/login_screen.dart';
import 'package:product_hub/Widgets/custome_textfield.dart';
import '../../Firebase_auth_service/firebase.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool isloading = false;
  FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  creatuser() async {
    try {
      setState(() => isloading = true);

      String? result = await firebaseService.signup(email.text, password.text);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
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
            colors: [Color(0xFFE8FDFC), Color(0xFFD1F5F2)],
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
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

                    /// Signup Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD1F5F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isloading
                            ? null
                            : () {
                                if (_formkey.currentState!.validate()) {
                                  creatuser();
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
    );
  }
}

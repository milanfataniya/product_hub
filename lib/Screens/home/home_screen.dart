import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:product_hub/Screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_hub/Widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            CustomAppbar(
              title: "Home",
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),



          ],
        ),
      ),
    );
  }
}

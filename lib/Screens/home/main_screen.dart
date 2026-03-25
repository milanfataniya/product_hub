import 'package:flutter/material.dart';
import 'package:product_hub/Firebase_auth_service/firebase.dart';
import 'package:product_hub/Screens/auth/login_screen.dart';
import 'package:product_hub/Screens/home/cart_screen.dart';
import 'package:product_hub/Screens/home/home_screen.dart';
import 'package:product_hub/Screens/home/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  FirebaseService firebaseService=FirebaseService();
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    CartScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:Colors.orange,
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index)async {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:product_hub/Widgets/custom_appbar.dart';
import 'package:product_hub/Screens/auth/login_screen.dart';
import 'package:product_hub/Widgets/loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("User not logged in")));
    }

    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: "Profile",
          automaticallyImplyLeading: false,
          leading: Icon(Icons.person),
        ),

        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text("No user data found"));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return  SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 40),

                  // 🔹 Avatar Section (Bigger + Stylish)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade200, Colors.orange.shade400],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Text(
                        data['name'][0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // 🔹 Name
                  Text(
                    data['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  // 🔹 Email
                  Text(
                    data['email'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 25),

                  // 🔹 Info Card (Premium)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        _profileTile(Icons.phone, "Phone", data['phone']),
                        SizedBox(height: 14),

                        _profileTile(Icons.home, "Address", data['address']),
                        SizedBox(height: 14),

                        _profileTile(Icons.location_city, "City", data['city']),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (route) => false,
                          );
                        },
                        icon: Icon(Icons.logout,color: Colors.white,),
                        label: Text(
                          "Sign Out",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _profileTile(IconData icon, String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 2),
              Text(value ?? "N/A",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        )
      ],
    );
  }
}

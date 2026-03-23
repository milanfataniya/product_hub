import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:product_hub/Api_Service/Products.dart';
import 'package:product_hub/Model/products_model.dart';
import 'package:product_hub/Screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_hub/Screens/home/product_detail_screen.dart';
import 'package:product_hub/Widgets/custom_appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ProductModel>> productlist;
  Api_Service api_service = Api_Service();
  List<ProductModel> carouselItems = [];
  String UserName="";

  @override
  void initState() {
    super.initState();

    productlist = api_service.getproduct();

    productlist.then((value) {
      final shuffled = List<ProductModel>.from(value)..shuffle();

      setState(() {
        carouselItems = shuffled.take(5).toList();
      });
    });
    getUserData();
  }
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppbar(
        title: "Welcom $UserName",
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
      body: FutureBuilder<List<ProductModel>>(future: productlist,
          builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(
            color: Colors.green,
            backgroundColor: Colors.white,
          ));
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No Data"));
        }
        final products=snapshot.data!;
        return RefreshIndicator(
          color: Colors.black,
            strokeWidth: 3,
            backgroundColor: Colors.white,
            onRefresh: () async {
              final data = await api_service.getproduct();
              carouselItems.shuffle();
              data.shuffle();
              setState(() {
                productlist = Future.value(data);
              });
          },
          child: Column(

            children: [
              Stack(
                children: [
                    CarouselSlider(
                      items: carouselItems.map((e){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductDetailScreen(
                                    product: e,
                                  )),
                                );
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.22,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "${e.discountPercentage.toStringAsFixed(0)}% OFF",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Image.network(
                                      e.thumbnail,
                                      fit: BoxFit.contain,
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.4),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      left: 12,
                                      bottom: 12,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child:  Row(
                                                  children: [
                                                    Icon(Icons.currency_rupee_sharp, size: 16, color: Colors.white),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      e.price.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                          SizedBox(height: 4),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Text(
                                              e.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        height: 150,
                        autoPlayAnimationDuration: Duration(seconds: 1),
                          viewportFraction: 1
                      ),
                    )

                  ],
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.7,
                ), itemBuilder:(context,index){
                      final product=products[index];
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductDetailScreen(
                              product: product,
                            )),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          child: SingleChildScrollView(
                            child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.star, size: 16, color: Colors.orange),
                                          SizedBox(width: 4),
                                          Text(
                                            product.rating.toStringAsFixed(1),
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product.thumbnail,
                                        height: 150,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    SizedBox(height: 8),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "₹${product.price}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 6),


                                  ],
                                )
                            ),
                          ),
                        ),
                      );
                }),
              ),
            ],
          ),
        );
      })
    );
  }

  void getUserData() async{
    User? user=FirebaseAuth.instance.currentUser;
    var doc=await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    setState(() {
      UserName=doc["name"];
    });



  }

  }

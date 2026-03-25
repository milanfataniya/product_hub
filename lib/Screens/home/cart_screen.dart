import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:product_hub/Firebase_auth_service/firebase.dart';
import 'package:product_hub/Widgets/custom_appbar.dart';
import 'package:product_hub/Widgets/loading.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseService  firebaseService=FirebaseService();
  String OrderDate="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var streamdata= firebaseService.getCartItems();

    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        appBar: CustomAppbar(
          title: "Order History",
          centerTitle: true,
          automaticallyImplyLeading:false,
        ),
        body: StreamBuilder(stream: streamdata, builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No Data"));
          }
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Lottie.asset(
                'assets/animation/Not_found.json',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index){
                final doc=docs[index];
                final data=doc.data() as Map<String,dynamic>;
                final timestamp = data['createdAt'];
                  if(timestamp!=null){
                    DateTime date = timestamp.toDate();
                    OrderDate = "${date.day}/${date.month}/${date.year}";
                  }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.7,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Order Date : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  OrderDate,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 3,
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Image.network(
                                  data['image'],
                                  width: 90,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),

                                SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Expanded(child: Text("Product",style: TextStyle(fontWeight: FontWeight.bold),)),
                                          Expanded(child: Text("Quantity",style: TextStyle(fontWeight: FontWeight.bold))),
                                          Expanded(child: Text("Price",style: TextStyle(fontWeight: FontWeight.bold))),
                                        ],
                                      ),

                                      SizedBox(height: 6),

                                      Divider(thickness: 1.5),
                                      SizedBox(height: 6),

                                      // DATA
                                      Row(
                                        children: [
                                          Expanded(child: Text(data['title'])),
                                          SizedBox(width: 20,),
                                          Expanded(child: Text(data['quantity'].toString())),
                                          Expanded(child: Text("₹${data['price']}")),
                                        ],
                                      ),
                                      SizedBox(height: 6),

                                      Divider(thickness: 1.5),
                                      Row(
                                        children: [
                                          Icon(Icons.receipt_long, size: 16, color: Colors.green),
                                          SizedBox(width: 4),
                                          Text(
                                            "Total: ₹${data['TotalPrice'] ?? 0}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                  ),
                );
            },
          );
        }),
      ),
    );
  }
}

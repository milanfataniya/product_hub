import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width:200 ,
        height: 200,
        child: Lottie.asset("assets/animation/app_loading.json"),
      ),
    );
  }
}

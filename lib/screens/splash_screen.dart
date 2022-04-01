import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/screenshot(213).jpeg'),
            Text(
              "Hang on...Loading",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CircularProgressIndicator(),
          ],
        ),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}

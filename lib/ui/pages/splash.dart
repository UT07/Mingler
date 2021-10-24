import 'package:flutter/material.dart';
import 'package:flutter_test2/ui/constants.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
            width: size.width,
            child: Center(
                child: Text("Mingler",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.2,
                    )))));
  }
}

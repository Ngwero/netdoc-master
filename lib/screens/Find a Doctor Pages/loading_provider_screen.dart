import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'hospitals_page.dart';

class LoadingProvidersScreen extends StatefulWidget {
  static String id = 'loading_hospitals_page';
  final String title;

  const LoadingProvidersScreen({Key? key, required this.title})
      : super(key: key); // Constructor
// Receive data
  @override
  _LoadingProvidersScreenState createState() => _LoadingProvidersScreenState();
}

class _LoadingProvidersScreenState extends State<LoadingProvidersScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // After 5 seconds, navigate to HospitalsPage
      Navigator.pop(context);
      Navigator.pushNamed(context, HospitalsPage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lottie animation widget
              Center(
                  child: Lottie.asset('images/goal.json',
                      width: 200, height: 200)),
              SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

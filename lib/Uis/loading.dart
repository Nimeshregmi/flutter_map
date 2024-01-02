


import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Loading.....',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
    );
  }
}
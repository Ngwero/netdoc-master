

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EndCallPage extends StatefulWidget {
  const EndCallPage({Key? key}) : super(key: key);

  @override
  State<EndCallPage> createState() => _EndCallPageState();
}

class _EndCallPageState extends State<EndCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('End Call Page'),
      ),
    );

  }
}

import 'package:flutter/material.dart';

import 'completed.dart';

class Pending extends StatelessWidget {
  const Pending({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Pending'),centerTitle: true,),
    body:  Padding(
      padding: EdgeInsets.fromLTRB(20,10,20,5),
      child: DeliveryStatus(status: 'pending',),
    ),);
  }
}

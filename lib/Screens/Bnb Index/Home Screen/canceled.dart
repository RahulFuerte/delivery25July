import 'package:flutter/material.dart';

import 'completed.dart';

class Canceled extends StatelessWidget {
  const Canceled({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Canceled'),centerTitle: true,),
    body: Padding(
      padding: EdgeInsets.fromLTRB(20,10,20,5),
      child: DeliveryStatus(status: 'canceled',),
    ),);
  }
}

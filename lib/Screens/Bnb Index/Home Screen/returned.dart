import 'package:flutter/material.dart';

import 'completed.dart';

class Returned extends StatelessWidget {
  const Returned({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Returned'),centerTitle: true,),
    body: const Padding(
      padding: EdgeInsets.fromLTRB(20,10,20,5),
      child: DeliveryStatus(status: 'returned',),
    ),);
  }
}

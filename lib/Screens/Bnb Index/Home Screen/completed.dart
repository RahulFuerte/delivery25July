import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Screens/Bnb%20Index/Orders%20Screen/order_card.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:flutter/material.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:const Text('Completed'),centerTitle: true,),
    body: const Padding(
      padding: EdgeInsets.fromLTRB(20,10,20,5),
      child: DeliveryStatus(status: 'completed',),
    ),);
  }
}

class DeliveryStatus extends StatelessWidget {
 final String status;
  const DeliveryStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return  OrderCard(
      userId: Text('userUid'),
      orderId: Text('orderId'),
      name: Text('userName'),
      address: Text('userAddress'),
      dateTime: DateTime.now(),
      status: 'new',
      totalPrice: 56,
      totalQty: totalQuantity,
      onAccept: () {},

      onReject: (){},
      onNo: (){},
      onYes: (){},
    ),

  }




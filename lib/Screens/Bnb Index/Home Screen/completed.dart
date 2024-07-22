import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Screens/Bnb%20Index/Orders%20Screen/order_card.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:flutter/material.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:Text('Completed'),centerTitle: true,),
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
    return  StreamBuilder<DocumentSnapshot>(
        stream: getAllOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No $status orders found.'));
          }

          final allOrderDetails = (snapshot.data!.data() as Map<String, dynamic>)['allOrderDetails'] as List<dynamic>;

          // Filter completed orders
          final completedOrders = allOrderDetails.where((order) {
            final orderMap = order as Map<String, dynamic>;
            return orderMap[status] == true;
          }).toList();

          if (completedOrders.isEmpty) {
            return Center(child: Text('No $status orders found.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: completedOrders.length,
            itemBuilder: (context, index) {
              final order = completedOrders[index] as Map<String, dynamic>;
              return OrderCard(
                name: order['name'],
                address: order['address'],
                dateTime: (order['orderTime'] as Timestamp).toDate(), // Convert timestamp to DateTime
                status: 'Completed',
                totalPrice: order['totalPrice'],
                totalQty: order['quantity'],
                onAccept: () {},
                onReject: () {},
                onYes: () {},
                onNo: () {},
                orderId: order['orderId'],
                userId: order['number'],
              );
            },
          );
        },
      );

  }
 Stream<DocumentSnapshot> getAllOrderDetails() {
   String? userId = SharedPreferencesHelper.getString('number');
   return FirebaseFirestore.instance
       .collection('Delivery User')
       .doc(userId)
       .collection('User Info')
       .doc('Orders')
       .snapshots();
 }
}



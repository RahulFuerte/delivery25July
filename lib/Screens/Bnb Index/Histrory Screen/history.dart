import 'package:delivery/Screens/Bnb%20Index/Home%20Screen/completed.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Utils/Global/global.dart';

class History extends StatefulWidget {

  const History({super.key});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
        physics: ScrollPhysics(),
        child: Column(children: [
          Center(child: Text('Completed'),),
          DeliveryStatus(status: 'completed',),
          Center(child: Text('Pending'),),
          DeliveryStatus(status: 'pending',),
          Center(child: Text('Canceled'),),
          DeliveryStatus(status: 'canceled',),
          Center(child: Text('Returned'),),
          DeliveryStatus(status: 'returned',),

        ],),
      )
      // StreamBuilder<QuerySnapshot>(
      //   stream: getAllOrderDetails(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(child: Text('No orders found.'));
      //     }
      //
      //     final List<Map<String, dynamic>> allOrderDetails = snapshot.data!.docs
      //         .map((doc) => doc.data() as Map<String, dynamic>)
      //         .toList();
      //
      //     return ListView.builder(
      //       itemCount: allOrderDetails.length,
      //       itemBuilder: (context, index) {
      //         final order = allOrderDetails[index];
      //         return ListTile(
      //           title: Text('Order ID: ${order['orderId']}'),
      //           subtitle: Text('Status: ${_getOrderStatus(order)}'),
      //           onTap: () => _showOrderDetails(context, order),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }

  String _getOrderStatus(Map<String, dynamic> order) {
    if (order['completed'] == true) return 'Completed';
    if (order['delivered'] == true) return 'Delivered';
    if (order['returned'] == true) return 'Returned';
    if (order['pending'] == true) return 'Pending';
    return 'Unknown';
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Order ID: ${order['orderId']}'),
                Text('Name: ${order['name']}'),
                Text('Number: ${order['number']}'),
                Text('Address: ${order['address']}'),
                Text('Order Time: ${_formatTimestamp(order['orderTime'])}'),
                Text('Accepted At: ${_formatTimestamp(order['acceptedAt'])}'),
                Text('Quantity: ${order['quantity']}'),
                Text('Total Price: ${order['totalPrice']}'),
                Text('Completed: ${order['completed']}'),
                Text('Delivered: ${order['delivered']}'),
                Text('Returned: ${order['returned']}'),
                Text('Pending: ${order['pending']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    return timestamp.toDate().toString();
  }
}
Stream<DocumentSnapshot> getAllOrderDetails() {
  String? userId = SharedPreferencesHelper.getString('number');
  return FirebaseFirestore.instance
      .collection('Delivery User')
      .doc(userId!)
      .collection('User Info')
      .doc('Orders')
      .snapshots();
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../Utils/Global/global.dart';
//
// class History extends StatefulWidget {
//   const History({super.key});
//
//   @override
//   HistoryState createState() => HistoryState();
// }
//
// class HistoryState extends State<History> {
//   bool _showCompleted = true;
//   @override
//   Widget build(BuildContext context) {
//     String? userId = SharedPreferencesHelper.getString('number');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Statuses'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: getAllOrderDetails(userId!),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('No orders foundg.'));
//           }
//
//           // Extract the document data
//           final data = snapshot.data!.data();
//           // if (data == null || !data.containsKey('orders')) {
//           //   return const Center(child: Text('No orders foundk.'));
//           // }
//
//           // Safely cast to List<dynamic>
//           final List<dynamic>? ordersList = data['orders'] as List<dynamic>?;
//
//           if (ordersList == null || ordersList.isEmpty) {
//             return const Center(child: Text('No orders foundl.'));
//           }
//
//           // Process orders and filter based on status
//           final filteredOrders = ordersList.where((order) {
//             final orderMap = order as Map<String, dynamic>;
//             // Customize the filter condition here if needed
//             return _showCompleted ? orderMap['completed'] == true : true;
//           }).toList();
//
//           return ListView.builder(
//             itemCount: filteredOrders.length,
//             itemBuilder: (context, index) {
//               final order = filteredOrders[index] as Map<String, dynamic>;
//               return ListTile(
//                 title: Text('Order ID: ${order['orderId']}'),
//                 subtitle: Text('Status: ${_getOrderStatus(order)}'),
//                 onTap: () => _showOrderDetails(context, order),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   String _getOrderStatus(Map<String, dynamic> order) {
//     if (order['completed'] == true) return 'Completed';
//     if (order['delivered'] == true) return 'Delivered';
//     if (order['returned'] == true) return 'Returned';
//     if (order['pending'] == true) return 'Pending';
//     return 'Unknown';
//   }
//
//   void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Order Details'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Order ID: ${order['orderId']}'),
//                 Text('Name: ${order['name']}'),
//                 Text('Number: ${order['number']}'),
//                 Text('Address: ${order['address']}'),
//                 Text('Order Time: ${_formatTimestamp(order['orderTime'])}'),
//                 Text('Accepted At: ${_formatTimestamp(order['acceptedAt'])}'),
//                 Text('Quantity: ${order['quantity']}'),
//                 Text('Total Price: ${order['totalPrice']}'),
//                 Text('Completed: ${order['completed']}'),
//                 Text('Delivered: ${order['delivered']}'),
//                 Text('Returned: ${order['returned']}'),
//                 Text('Pending: ${order['pending']}'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   String _formatTimestamp(Timestamp? timestamp) {
//     if (timestamp == null) return 'N/A';
//     return timestamp.toDate().toString();
//   }
// }
//
//
//
//
// Stream<DocumentSnapshot<Map<String, dynamic>>> getAllOrderDetails(String userId) {
//   return FirebaseFirestore.instance
//       .collection('Delivery User')
//       .doc(userId)
//       .collection('User Info')
//       .doc('Orders')
//       .snapshots();
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../../Utils/Global/global.dart';
import 'order_card.dart';

class OrdersList1 extends StatelessWidget {
  final String status;
  final bool hasOrdered, orderVisible, orderReturn, paymentStatus, orderStatus, deliveryStatus;

  const OrdersList1({
    super.key,
    required this.status,
    required this.orderVisible,
    required this.orderReturn,
    required this.paymentStatus,
    required this.orderStatus,
    required this.deliveryStatus, required this.hasOrdered,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, List<DocumentSnapshot>>>(
      stream: _getAllUsersOrdersStream(orderVisible, orderReturn, paymentStatus, orderStatus, deliveryStatus,hasOrdered),
      builder: (BuildContext context, AsyncSnapshot<Map<String, List<DocumentSnapshot>>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingAnimation();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data!.entries.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        Map<String, List<DocumentSnapshot>> ordersByMonth = snapshot.data!;
        // print('Orders By Month: $ordersByMonth');

        return snapshot.data!.entries.isEmpty?
        const Center(child: Text('No orders found'))
        :ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: ordersByMonth.entries.map((entry) {
            String monthName = entry.key;
            List<DocumentSnapshot> orders = entry.value;
            // print('Month: $monthName, Orders Count: ${orders.length}');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.yellow.shade50,
                    child: Center(
                      child: Text(
                        monthName.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black38),
                      ),
                    ),
                  ),
                ),
                ...orders.map((order) {
                  Map<String, dynamic> data = order.data() as Map<String, dynamic>;
                  List<dynamic> orderItems = data['orderItems'] ?? [];
                  int totalQuantity = 0;
                  double totalPrice = 0.0;

                  for (var item in orderItems) {
                    Map<String, dynamic> itemData = item as Map<String, dynamic>;
                    totalQuantity += itemData['productQuantity'] as int;
                    totalPrice += (itemData['productTotalPrice'] as num).toDouble();
                  }
                  Timestamp orderDate = data['orderDate'];

                  int year = orderDate.toDate().year;
                  int month = orderDate.toDate().month;
                  // print('monsn::$month yysy::$year');

                  String orderId = order.id;
                  return OrderCard(
                    userId: data['userUid'],
                    orderId: data['orderId'],
                    key: ValueKey(orderId),
                    name: data['userName'],
                    address: data['userAddress'],
                    dateTime: data['orderDate'].toDate(),
                    status: status,
                    totalPrice: totalPrice.toStringAsFixed(2),
                    totalQty: totalQuantity,
                    onAccept: () => _handleOrderAction(context, () {
                      Timestamp orderDate = data['orderDate'];
                      String year = orderDate.toDate().year.toString();
                      String month = orderDate.toDate().month.toString();
                      // print('monsn::$month yysy::$year');
                      return _onAccept(data['userUid'], orderId,year,month,data['userName'],data['userAddress'],
                      data['userUid'],data['orderDate'].toDate(),data['orderId'],totalPrice.toStringAsFixed(2),totalQuantity);
                    }),
                    onReject: () => _handleOrderAction(context, () {
                      Timestamp orderDate = data['orderDate'];
                      String year = orderDate.toDate().year.toString();
                      String month = orderDate.toDate().month.toString();
                      return _onReject(data['userUid'], orderId,year,month,data['userName'],
                          data['userAddress'],
                          data['userUid'],data['orderDate'].toDate(),data['orderId'],
                          totalPrice.toStringAsFixed(2),totalQuantity);
                    }),
                    onNo: () => _handleOrderAction(context, () {
                      Timestamp orderDate = data['orderDate'];
                      String year = orderDate.toDate().year.toString();
                      String month = orderDate.toDate().month.toString();
                      return _onNo(data['userUid'], orderId,
                        year,month,data['userName'],data['userAddress'],
                        data['userUid'],data['orderDate'].toDate(),data['orderId'],
                          totalPrice.toStringAsFixed(2),totalQuantity);
                    }),
                    onYes: () => _handleOrderAction(context, () {
                      Timestamp orderDate = data['orderDate'];
                      String year = orderDate.toDate().year.toString();
                      String month = orderDate.toDate().month.toString();
                      return _onYes(data['userUid'], orderId,
                        year,month,data['userName'],data['userAddress'],
                        data['userUid'],data['orderDate'].toDate(),data['orderId'],
                          totalPrice.toStringAsFixed(2),totalQuantity);
                    }),
                  );
                }),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _onAccept(String userId, String orderId,String year, String month,String orderUserName,
      String orderUserAddress,String orderUserNumber,DateTime orderTime,String orderID,
  String orderTotalPrice,int orderQuantity) async {
    String? number = SharedPreferencesHelper.getString('number');
    String? name = SharedPreferencesHelper.getString('name');
    if (number == null || name == null) {
      throw Exception('Delivery user number or name not found');
    }

    Map<String, dynamic> dataToUpdate = {
      'orderStatus': false,
      'acceptedAt': Timestamp.now(),
      'deliveryUserName': name,
      'deliveryUserNumber': number,
    };

    Map<String, dynamic> newOrderDetail = {
      'orderId': orderID,
      'acceptedAt': Timestamp.now(),
      'name': orderUserName,
      'address': orderUserAddress,
      'number': orderUserNumber,
      'orderTime': orderTime,
      'quantity': orderQuantity,
      'totalPrice': orderTotalPrice,
      'completed':false,
      'pending':true,
      'returned':false,
      'canceled':false,
    };
    await _updateUserData(newOrderDetail);
    await updateOrderData(userId, orderId, year,month, true,dataToUpdate);
    await _incrementDeliveryCount('pendingDeliveries');
  }

  Future<void> _handleOrderAction(BuildContext context, Future<void> Function() action) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await action();

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
  }

  Future<void> _onReject(String userId, String orderId,String year, String month,
      String orderUserName,
      String orderUserAddress,String orderUserNumber,DateTime orderTime,String orderID,
      String orderTotalPrice,int orderQuantity) async {
    Map<String, dynamic> dataToUpdate = {
      'orderVisible': false,
    };
    Map<String, dynamic> newOrderDetail = {
      'orderId': orderID,
      'rejectedAt': Timestamp.now(),
      'name': orderUserName,
      'address': orderUserAddress,
      'number': orderUserNumber,
      'orderTime': orderTime,
      'quantity': orderQuantity,
      'totalPrice': orderTotalPrice,
      'completed':false,
      'pending':false,
      'returned':false,
      'canceled':true,
    };
await _updateUserData(newOrderDetail);
    await updateOrderData(userId, orderId, year,month,true,dataToUpdate);
    await _incrementDeliveryCount('canceledDeliveries');
  }

  Future<void> _onYes(String userId, String orderId,String year, String month,
      String orderUserName,
      String orderUserAddress,String orderUserNumber,DateTime orderTime,String orderID,
      String orderTotalPrice,int orderQuantity) async {
    Map<String, dynamic> dataToUpdate = {
      'paymentAt': Timestamp.now(),
      'deliveredAt':Timestamp.now(),
      'deliveryStatus': true,
      'paymentStatus': true,
    };
    Map<String, dynamic> updatedOrderDetail = {
      'orderId': orderID,
      'deliveredAt': Timestamp.now(),
      'name': orderUserName,
      'address': orderUserAddress,
      'number': orderUserNumber,
      'orderTime': orderTime,
      'quantity': orderQuantity,
      'totalPrice': orderTotalPrice,
      'completed':true,
      'pending':false,
      'returned':false,
      'canceled':false,
    };

    await updateOrderData(userId, orderId,year,month,true, dataToUpdate);
    await _updateUserData(updatedOrderDetail);
    await _incrementDeliveryCount('completedDeliveries');
    await _decrementDeliveryCount('pendingDeliveries');

  }

  Future<void> _onNo(String userId, String orderId,String year,month,
      String orderUserName,
      String orderUserAddress,String orderUserNumber,DateTime orderTime,String orderID,
      String orderTotalPrice,int orderQuantity) async {
    // Implement the required functionality for 'No'
    Map<String, dynamic> dataToUpdate = {
      'returnedAt': Timestamp.now(),

      'orderReturn':true,
      // 'orderStatus':true,
      // 'orderVisible':true,


    };
    Map<String, dynamic> updatedOrderDetail = {
      'orderId': orderID,
      'returnedAt': Timestamp.now(),
      'name': orderUserName,
      'address': orderUserAddress,
      'number': orderUserNumber,
      'orderTime': orderTime,
      'quantity': orderQuantity,
      'totalPrice': orderTotalPrice,
      'completed':false,
      'pending':false,
      'returned':true,
      'canceled':false,
    };
await updateOrderData(userId, orderId, year, month, true, dataToUpdate);
    await _incrementDeliveryCount('returnDeliveries');
    await _decrementDeliveryCount('pendingDeliveries');
    // await FirebaseFirestore.instance.collection('users').doc(userId).update(
    //     {'hasOrdered':true});
await _updateUserData(updatedOrderDetail);
  }

  Future<void> _incrementDeliveryCount(String field) async {
    String? number = SharedPreferencesHelper.getString('number');

    if (number != null) {
      await FirebaseFirestore.instance
          .collection('Delivery User')
          .doc(number).collection('User Info').doc('Orders')
          .update({field: FieldValue.increment(1)});
    } else {
      throw Exception('Delivery user number not found');
    }
  }Future<void> _decrementDeliveryCount(String field) async {
    String? number = SharedPreferencesHelper.getString('number');

    if (number != null) {
      await FirebaseFirestore.instance
          .collection('Delivery User')
          .doc(number).collection('User Info').doc('Orders')
          .update({field: FieldValue.increment(-1)});
    } else {
      throw Exception('Delivery user number not found');
    }
  }
  // Future<void> _orderData(List<Map<String, dynamic>> data) async {
  //   String? number = SharedPreferencesHelper.getString('number');
  //
  //   if (number!= null) {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('Delivery User')
  //         .doc(number)
  //         .collection('User Info')
  //         .doc('Orders')
  //         .get();
  //
  //     List<Map<String, dynamic>> allOrderDetails = List<Map<String, dynamic>>.from(snapshot.get('allOrderDetails'));
  //
  //     allOrderDetails.addAll(data);
  //
  //     await FirebaseFirestore.instance
  //         .collection('Delivery User')
  //         .doc(number)
  //         .collection('User Info')
  //         .doc('Orders')
  //         .update({'allOrderDetails': allOrderDetails});
  //   } else {
  //     throw Exception('Delivery user number not found');
  //   }
  // }

  Future<void> _orderData(Map<String, dynamic> newOrderDetail) async {
    String? number = SharedPreferencesHelper.getString('number');
    if (number == null) throw Exception('Delivery user number not found');

    DocumentReference docRef = FirebaseFirestore.instance
        .collection('Delivery User')
        .doc(number)
        .collection('User Info')
        .doc('Orders');

    DocumentSnapshot docSnapshot = await docRef.get();
    List<dynamic> allOrderDetails = docSnapshot.exists
        ? (docSnapshot.data() as Map<String, dynamic>)['allOrderDetails'] ?? []
        : [];

    allOrderDetails.add(newOrderDetail);
    await docRef.set({'allOrderDetails': allOrderDetails}, SetOptions(merge: true));
  }



}

// Future<void> updateOrderData(String userId, String orderId, Map<String, dynamic> data) async {
//   String currentYear = DateTime.now().year.toString();
//   String currentMonth = DateTime.now().month.toString();
//
//   String documentPath = 'users/$userId/orders/$currentYear/$currentMonth/$orderId';
//
//   await FirebaseFirestore.instance.doc(documentPath)
//   // .collection('user').doc(userId).collection(year).doc(month)
//       .update(data);
// }
Future<void> updateOrderData(String userId, String orderId,String year,String month,bool hasOrdered, Map<String, dynamic> data) async {

    String documentPath = 'users/$userId/orders/$year/$month/$orderId';

    await FirebaseFirestore.instance.doc(documentPath).update(data);
    await FirebaseFirestore.instance.collection('users').doc(userId).update(
        {'hasOrdered':hasOrdered});

}

Future<void> _updateUserData(Map<String, dynamic> updatedOrderDetail) async {
  // Get the delivery user number from shared preferences
  String? number = SharedPreferencesHelper.getString('number');
  if (number == null) throw Exception('Delivery user number not found');

  // Reference to the Orders document in Firestore
  DocumentReference docRef = FirebaseFirestore.instance
      .collection('Delivery User')
      .doc(number)
      .collection('User Info')
      .doc('Orders');

  // Fetch the document snapshot
  DocumentSnapshot docSnapshot = await docRef.get();

  // Initialize allOrderDetails list
  List<dynamic> allOrderDetails = docSnapshot.exists
      ? (docSnapshot.data() as Map<String, dynamic>)['allOrderDetails'] ?? []
      : [];

  // Find the index of the order to update
  int index = allOrderDetails.indexWhere((order) => order['orderId'] == updatedOrderDetail['orderId']);

  if (index != -1) {
    // Update the existing order
    allOrderDetails[index] = updatedOrderDetail;
    print('Order updated: ${updatedOrderDetail['orderId']}');
  } else {
    // If the order is not found, add it to the list
    allOrderDetails.add(updatedOrderDetail);
    print('Order added: ${updatedOrderDetail['orderId']}');
  }

  // Use set() with merge: true to create the document if it does not exist
  await docRef.set({'allOrderDetails': allOrderDetails}, SetOptions(merge: true));
  print('Orders document updated in Firestore');
}


// Stream<Map<String, List<DocumentSnapshot<Object?>>>> _getAllUsersOrdersStream(
//     bool orderVisible,bool orderReturn,bool paymentStatus,bool orderStatus,bool deliveryStatus) async* {
//   Stream<QuerySnapshot<Object?>> usersStream = FirebaseFirestore.instance.collection('users').where('hasOrdered', isEqualTo: true).snapshots();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? number = prefs.getString('number');
//
//   if (number == null) {
//     throw Exception('Delivery user number not found');
//   }
//
//   DocumentSnapshot deliveryUserDoc = await FirebaseFirestore.instance
//       .collection('Delivery User')
//       .doc(number)
//       .collection('User Info')
//       .doc('Profile')
//       .get();
//
//   yield* usersStream.asyncExpand((usersSnapshot) {
//     List<Stream<Map<String, List<DocumentSnapshot>>>> orderStreams = usersSnapshot.docs.map((userDoc) {
//       String city = deliveryUserDoc['city'];
//       String state = deliveryUserDoc['state'];
//
//       // Get the current date
//       DateTime now = DateTime.now();
//
//       // Create a list of DateTime objects for the current month and the two previous months
//       List<DateTime> months = [
//         DateTime(now.year, now.month),
//         DateTime(now.year, now.month - 1),
//         DateTime(now.year, now.month - 2),
//       ];
//
//       // Create a stream for each month
//       List<Stream<Map<String, List<DocumentSnapshot>>>> monthStreams = months.map((date) {
//         String year = date.year.toString();
//         String month = date.month.toString();
//         String monthName = DateFormat.MMMM().format(date);
//         print('Fetching orders for $monthName $year');
//
//         return userDoc.reference
//             .collection('orders')
//             .doc(year)
//             .collection(month)
//             // .where('deliveryStatus', isEqualTo: false)
//             // .where('orderStatus', isEqualTo: true)
//             // .where('paymentStatus', isEqualTo: false)
//             // .where('orderReturn', isEqualTo: false)
//         // .where('orderVisible',isEqualTo: true)
//             .snapshots()
//             .map((orderSnapshot) {
//           print('Fetched ${orderSnapshot.docs.length} orders for $monthName $year');
//
//           return {monthName: orderSnapshot.docs};
//             });
//       }).toList();
//
//       // Combine the streams for the different months
//       return CombineLatestStream.list(monthStreams).map((listOfMonthOrders) {
//         Map<String, List<DocumentSnapshot>> ordersMap = {};
//         for (var monthOrders in listOfMonthOrders) {
//           ordersMap.addAll(monthOrders);
//         }
//         print('Combined orders map for user: $ordersMap');
//         return ordersMap;
//       });
//     }).toList();
//
//     return CombineLatestStream.list(orderStreams).map((listOfOrdersMaps) {
//       Map<String, List<DocumentSnapshot>> ordersMap = {};
//       for (var ordersMapEntry in listOfOrdersMaps) {
//         ordersMap.addAll(ordersMapEntry);
//       }
//
//       print('Final combined orders map: $ordersMap');
//
//       return ordersMap;
//     });
//   });
// }


// Stream<Map<String, List<DocumentSnapshot<Object?>>>> _getAllUsersOrdersStream(
//     bool orderVisible, bool orderReturn, bool paymentStatus, bool orderStatus, bool deliveryStatus,bool hasOrdered) async* {
//   Stream<QuerySnapshot<Object?>> usersStream = FirebaseFirestore.instance.collection('users').where('hasOrdered', isEqualTo: hasOrdered).snapshots();
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? number = SharedPreferencesHelper.getString('number');
//
//   if (number == null) {
//     throw Exception('Delivery user number not found');
//   }
//
//   DocumentSnapshot deliveryUserDoc = await FirebaseFirestore.instance
//       .collection('Delivery User')
//       .doc(number)
//       .collection('User Info')
//       .doc('Profile')
//       .get();
//
//   yield* usersStream.asyncExpand((usersSnapshot) {
//     List<Stream<Map<String, List<DocumentSnapshot>>>> orderStreams = usersSnapshot.docs.map((userDoc) {
//       String city = deliveryUserDoc['city'];
//       String state = deliveryUserDoc['state'];
//
//       // Get the current date
//       DateTime now = DateTime.now();
//
//       // Create a list of DateTime objects for the current month and the two previous months
//       List<DateTime> months = [
//         DateTime(now.year, now.month),
//         DateTime(now.year, now.month - 1),
//         DateTime(now.year, now.month - 2),
//       ];
//
//       // Create a stream for each month
//       List<Stream<Map<String, List<DocumentSnapshot>>>> monthStreams = months.map((date) {
//         String year = date.year.toString();
//         String month = date.month.toString();
//         String monthName = DateFormat.MMMM().format(date);
//         print('Fetching orders for $monthName $year');
//
//         return userDoc.reference
//             .collection('orders')
//             .doc(year)
//             .collection(month)
//         // .where('city'.toLowerCase(),isEqualTo:city.toLowerCase())
//         // .where('state'.toLowerCase(),isEqualTo:state.toLowerCase())
//             .where('deliveryStatus', isEqualTo: deliveryStatus)
//             .where('orderStatus', isEqualTo: orderStatus)
//             .where('paymentStatus', isEqualTo: paymentStatus)
//             .where('orderReturn', isEqualTo: orderReturn)
//         // .where('orderVisible', isEqualTo: orderVisible)
//             .snapshots()
//             .map((orderSnapshot) {
//           print('Fetched ${orderSnapshot.docs.length} orders for $monthName $year');
//
//           return {monthName: orderSnapshot.docs};
//         });
//       }).toList();
//
//       // Combine the streams for the different months
//       return CombineLatestStream.list(monthStreams).map((listOfMonthOrders) {
//         Map<String, List<DocumentSnapshot>> ordersMap = {};
//         for (var monthOrders in listOfMonthOrders) {
//           monthOrders.forEach((month, orders) {
//             if (!ordersMap.containsKey(month)) {
//               ordersMap[month] = [];
//             }
//             ordersMap[month]!.addAll(orders);
//           });
//         }
//         print('Combined orders map for user: $ordersMap');
//         return ordersMap;
//       });
//     }).toList();
//
//     // Combine the streams for all users
//     return CombineLatestStream.list(orderStreams).map((listOfOrdersMaps) {
//       Map<String, List<DocumentSnapshot>> combinedOrdersMap = {};
//       for (var userOrdersMap in listOfOrdersMaps) {
//         userOrdersMap.forEach((month, orders) {
//           if (!combinedOrdersMap.containsKey(month)) {
//             combinedOrdersMap[month] = [];
//           }
//           combinedOrdersMap[month]!.addAll(orders);
//         });
//       }
//
//       print('Final combined orders map: $combinedOrdersMap');
//
//       return combinedOrdersMap;
//     });
//   });
// }

Stream<Map<String, List<DocumentSnapshot<Object?>>>> _getAllUsersOrdersStream(
    bool orderVisible, bool orderReturn, bool paymentStatus, bool orderStatus, bool deliveryStatus, bool hasOrdered) async* {

  // Stream to get all users who have ordered, based on the 'hasOrdered' flag
  Stream<QuerySnapshot<Object?>> usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('hasOrdered', isEqualTo: hasOrdered)
      .snapshots();

  // Retrieve the delivery user number from shared preferences
  String? number = SharedPreferencesHelper.getString('number');

  if (number == null) {
    throw Exception('Delivery user number not found');
  }

  // Fetch the delivery user's profile document
  DocumentSnapshot deliveryUserDoc = await FirebaseFirestore.instance
      .collection('Delivery User')
      .doc(number)
      .collection('User Info')
      .doc('Profile')
      .get();

  // Expand the stream of users to streams of orders for each user
  yield* usersStream.asyncExpand((usersSnapshot) {
    List<Stream<Map<String, List<DocumentSnapshot>>>> orderStreams = usersSnapshot.docs.map((userDoc) {
      DateTime now = DateTime.now();

      // List of months to fetch orders from: current month and two previous months
      List<DateTime> months = [
        DateTime(now.year, now.month),
        DateTime(now.year, now.month - 1),
        DateTime(now.year, now.month - 2),
      ];

      // Create a stream for orders for each month
      List<Stream<Map<String, List<DocumentSnapshot>>>> monthStreams = months.map((date) {
        String year = date.year.toString();
        String month = date.month.toString();
        String monthName = DateFormat.MMMM().format(date);
        print('Fetching orders for $monthName $year');

        // Initialize the query with required filters
        Query<Object?> query = userDoc.reference
            .collection('orders')
            .doc(year)
            .collection(month)
            .where('deliveryStatus', isEqualTo: deliveryStatus)
            .where('orderStatus', isEqualTo: orderStatus)
            .where('paymentStatus', isEqualTo: paymentStatus)
            .where('orderReturn', isEqualTo: orderReturn);

        // Fetch the orders and apply additional filtering for 'orderVisible' in Dart code
        return query.snapshots().map((orderSnapshot) {
          print('Fetched ${orderSnapshot.docs.length} orders for $monthName $year');

          List<DocumentSnapshot> filteredDocs = orderSnapshot.docs.where((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Check if 'orderVisible' exists and matches the provided value
            return !data.containsKey('orderVisible') || data['orderVisible'] == orderVisible;
          }).toList();

          // Return orders for the current month
          return {monthName: filteredDocs};
        });
      }).toList();

      // Combine the streams for orders from different months into one
      return CombineLatestStream.list(monthStreams).map((listOfMonthOrders) {
        Map<String, List<DocumentSnapshot>> ordersMap = {};
        for (var monthOrders in listOfMonthOrders) {
          monthOrders.forEach((month, orders) {
            if (!ordersMap.containsKey(month)) {
              ordersMap[month] = [];
            }
            ordersMap[month]!.addAll(orders);
          });
        }
        print('Combined orders map for user: $ordersMap');
        return ordersMap;
      });
    }).toList();

    // Combine the streams of orders from different users into one
    return CombineLatestStream.list(orderStreams).map((listOfOrdersMaps) {
      Map<String, List<DocumentSnapshot>> combinedOrdersMap = {};
      for (var userOrdersMap in listOfOrdersMaps) {
        userOrdersMap.forEach((month, orders) {
          if (!combinedOrdersMap.containsKey(month)) {
            combinedOrdersMap[month] = [];
          }
          combinedOrdersMap[month]!.addAll(orders);
        });
      }

      print('Final combined orders map: $combinedOrdersMap');

      return combinedOrdersMap;
    });
  });
}



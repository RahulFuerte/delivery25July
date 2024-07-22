import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../Utils/Global/global.dart';

class OrdersBloc {
  final String status;
  final bool orderVisible, orderReturn, paymentStatus, orderStatus, deliveryStatus;

  OrdersBloc({
    required this.status,
    required this.orderVisible,
    required this.orderReturn,
    required this.paymentStatus,
    required this.orderStatus,
    required this.deliveryStatus,
  });

  Future<Map<String, dynamic>> _getDeliveryUserData() async {
    String? number = SharedPreferencesHelper.getString('number');
    if (number == null) {
      throw Exception('Delivery user number not found');
    }

    DocumentSnapshot deliveryUserDoc = await FirebaseFirestore.instance
        .collection('Delivery User')
        .doc(number)
        .collection('User Info')
        .doc('Profile')
        .get();

    return deliveryUserDoc.data() as Map<String, dynamic>;
  }

  Stream<Map<String, List<DocumentSnapshot>>> getAllUsersOrdersStream() async* {
    String? number = SharedPreferencesHelper.getString('number');
    if (number == null) {
      throw Exception('Delivery user number not found');
    }

    Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('users').where('hasOrdered', isEqualTo: true).snapshots();

    yield* usersStream.asyncExpand((usersSnapshot) {
      return CombineLatestStream.list(usersSnapshot.docs.map((userDoc) {
        return CombineLatestStream.list(_getMonthStreams(userDoc));
      })).map((listOfOrdersMaps) {
        Map<String, List<DocumentSnapshot>> combinedOrdersMap = {};
        for (var userOrdersMap in listOfOrdersMaps) {
          for (var monthOrders in userOrdersMap) {
            monthOrders.forEach((month, orders) {
              combinedOrdersMap[month] ??= [];
              combinedOrdersMap[month]!.addAll(orders);
            });
          }
        }
        return combinedOrdersMap;
      });
    });
  }

  List<Stream<Map<String, List<DocumentSnapshot>>>> _getMonthStreams(DocumentSnapshot userDoc) {
    DateTime now = DateTime.now();
    return List.generate(3, (i) {
      DateTime date = DateTime(now.year, now.month - i);
      String year = date.year.toString();
      String month = date.month.toString();
      String monthName = DateFormat.MMMM().format(date);
      return userDoc.reference
          .collection('orders')
          .doc(year)
          .collection(month)
          .where('deliveryStatus', isEqualTo: deliveryStatus)
          .where('orderStatus', isEqualTo: orderStatus)
          .where('paymentStatus', isEqualTo: paymentStatus)
          .where('orderReturn', isEqualTo: orderReturn)
          .snapshots()
          .map((orderSnapshot) => {monthName: orderSnapshot.docs});
    });
  }

  Future<void> handleOrderAction(BuildContext context, Future<void> Function() action) async {
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

  Future<void> onAccept(String userId, String orderId, Map<String, dynamic> data) async {
    Map<String, dynamic> deliveryUserData = await _getDeliveryUserData();
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

    Map<String, dynamic> orderData = {
      'orderId': orderId,
      'acceptedAt': Timestamp.now(),
      'name': data['userName'],
      'address': data['userAddress'],
      'number': data['userUid'],
      'orderTime': data['orderDate'],
      'quantity': data['orderItems'].length,
      'totalPrice': data['orderItems'].fold(0, (total, item) => total + item['productTotalPrice']),
    };

    await _orderData(orderData);
    await updateOrderData(userId, orderId, dataToUpdate);
    await _incrementDeliveryCount('pendingDeliveries');
  }

  Future<void> onReject(String userId, String orderId, String year, String month) async {
    Map<String, dynamic> dataToUpdate = {'orderVisible': false};
    await updateOrderData(userId, orderId, dataToUpdate);
    await _incrementDeliveryCount('canceledDeliveries');
  }

  Future<void> onYes(String userId, String orderId) async {
    Map<String, dynamic> dataToUpdate = {
      'paymentAt': Timestamp.now(),
      'deliveryStatus': true,
      'paymentStatus': true,
    };
    await updateOrderData(userId, orderId, dataToUpdate);
    await _incrementDeliveryCount('completedDeliveries');
  }

  Future<void> _incrementDeliveryCount(String field) async {
    String? number = SharedPreferencesHelper.getString('number');
    if (number != null) {
      await FirebaseFirestore.instance
          .collection('Delivery User')
          .doc(number)
          .collection('User Info')
          .doc('Orders')
          .set({field: FieldValue.increment(1)}, SetOptions(merge: true));
    } else {
      throw Exception('Delivery user number not found');
    }
  }

  Future<void> _orderData(Map<String, dynamic> data) async {
    String? number = SharedPreferencesHelper.getString('number');
    if (number != null) {
      await FirebaseFirestore.instance
          .collection('Delivery User')
          .doc(number)
          .collection('User Info')
          .doc('Orders')
          .set(data, SetOptions(merge: true));
    } else {
      throw Exception('Delivery user number not found');
    }
  }

  Future<void> updateOrderData(String userId, String orderId, Map<String, dynamic> data) async {
    DateTime now = DateTime.now();
    String documentPath = 'users/$userId/orders/${now.year}/${now.month}/$orderId';
    await FirebaseFirestore.instance.doc(documentPath).update(data);
  }
}


class OrdersList2 extends StatelessWidget {
  final OrdersBloc ordersBloc;

  const OrdersList2({super.key, required this.ordersBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, List<DocumentSnapshot>>>(
      stream: ordersBloc.getAllUsersOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.entries.map((entry) {
            return _buildMonthSection(context, entry.key, entry.value);
          }).toList(),
        );
      },
    );
  }

  Widget _buildMonthSection(BuildContext context, String monthName, List<DocumentSnapshot> orders) {
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
        ...orders.map((order) => _buildOrderCard(context, order)),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, DocumentSnapshot order) {
    Map<String, dynamic> data = order.data() as Map<String, dynamic>;
    int totalQuantity = (data['orderItems'] as List).fold(0, (total, item) => total + item['productQuantity']as int);
    double totalPrice = (data['orderItems'] as List).fold(0.0, (total, item) => total + item['productTotalPrice']);

    String year = DateFormat.y().format(data['orderDate'].toDate());
    String month = DateFormat.M().format(data['orderDate'].toDate());
    String orderId = order.id;

    return OrderCar(
      userId: order.reference.parent.parent!.id,
      orderId: orderId,
      data: data,
      year: year,
      month: month,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
      onAccept: () => ordersBloc.handleOrderAction(context, () => ordersBloc.onAccept(order.reference.parent.parent!.id, orderId, data)),
      onReject: () => ordersBloc.handleOrderAction(context, () => ordersBloc.onReject(order.reference.parent.parent!.id, orderId, year, month)),
      onYes: () => ordersBloc.handleOrderAction(context, () => ordersBloc.onYes(order.reference.parent.parent!.id, orderId)),
    );
  }
}


class OrderCar extends StatelessWidget {
  final String userId, orderId, year, month;
  final Map<String, dynamic> data;
  final int totalQuantity;
  final double totalPrice;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onYes;

  const OrderCar({
    super.key,
    required this.userId,
    required this.orderId,
    required this.data,
    required this.year,
    required this.month,
    required this.totalQuantity,
    required this.totalPrice,
    required this.onAccept,
    required this.onReject,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text('Total Quantity: $totalQuantity'),
            Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: onReject,
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: onYes,
                  child: const Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

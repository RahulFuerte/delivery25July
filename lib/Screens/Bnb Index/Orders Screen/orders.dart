import 'package:delivery/Screens/Bnb%20Index/Orders%20Screen/order_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart';
import 'order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Orders',
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white70,
                fontSize: 30,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelStyle: const TextStyle(
                fontSize: 14.1,
                color: m,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              // isScrollable: true,
              controller: _tabController,
              indicatorWeight: .7,
              indicator: BoxDecoration(
                // color:Colors.white70,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white70, width: 1.5),
              ),
              tabs: const [
                Tab(
                  text: 'New\nOrders',
                ),
                Tab(text: 'Pending'),
                Tab(text: 'Delivered'),
                Tab(text: 'Return'),
                // _buildTab('N', 0)
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: TabBarView(
            controller: _tabController,
            children:  const [
              OrdersList1(
                hasOrdered: true,
                status: 'new order',
                orderReturn: false,
                paymentStatus: false,
                orderStatus: true,
                deliveryStatus: false,
                orderVisible: true,
              ),
              OrdersList1(
                hasOrdered:true,
                status: 'pending',
                orderReturn: false,
                paymentStatus: false,
                orderStatus: false,
                deliveryStatus: false,
                orderVisible: true,
              ),
              OrdersList1(
                hasOrdered: true,
                status: 'delivered',
                orderReturn: false,
                paymentStatus: true,
                orderStatus: false,
                deliveryStatus: true,
                orderVisible: true,
              ),
              OrdersList1(
                hasOrdered: true,
                status: 'return',
                orderReturn: true,
                paymentStatus: false,
                orderStatus: false,
                deliveryStatus: false,
                orderVisible: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white70 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final String status;
  final FirestoreService _firestoreService = FirestoreService();
  final bool orderReturn, paymentStatus, orderStatus, deliveryStatus;

  OrdersList(
      {super.key,
      required this.status,
      required this.orderReturn,
      required this.paymentStatus,
      required this.orderStatus,
      required this.deliveryStatus});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _getAllUsersOrdersStream(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders available'));
        }
        // If there are no errors and we are done loading, display the data
        return ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                snapshot.data![index].data() as Map<String, dynamic>;
            List<dynamic> orderItems = data['orderItems'] ?? [];
            // List<Map<String, dynamic>> orderItem = List<Map<String, dynamic>>.from(data['orderItems'] ?? []);

            // Calculate total quantity and total price
            int totalQuantity = 0;
            double totalPrice = 0.0;
            for (var item in orderItems) {
              Map<String, dynamic> itemData = item as Map<String, dynamic>;
              totalQuantity += itemData['productQuantity'] as int;
              totalPrice += (itemData['productTotalPrice'] as num).toDouble();
              // String time = 'Order Time: ${data['orderAt'].toDate()}';
            }
            String orderId = snapshot.data![index].id;

            return Column(
              children: [
                OrderCard(
                  userId: data['userUid'],
                  orderId: data['orderId'],
                  key: ValueKey(data['orderId']),
                  // Unique key for each order card
                  name: data['userName'],
                  address: data['userAddress'],
                  dateTime: data['orderDate'].toDate(),
                  status: status,
                  totalPrice: totalPrice.toStringAsFixed(2),
                  totalQty: totalQuantity,
                  onAccept: () => _handleOrderAction(context,
                      () => _onAccept(context, data['userUid'], orderId)),
                  onReject: () => _handleOrderAction(context,
                      () => _onReject(context, data['userUid'], orderId)),
                  onNo: () => _handleOrderAction(
                      context, () => _onNo(context, data['userUid'], orderId)),
                  onYes: () => _handleOrderAction(
                      context, () => _onYes(context, data['userUid'], orderId)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onAccept(
      BuildContext context, String userId, String orderId) async {
    try {
      await _firestoreService.updateOrderStatus(userId, orderId,
          {'orderStatus': false, 'acceptedAt': Timestamp.now()});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? number = prefs.getString('number');
      await _firestoreService.incrementDeliveryCount(
          number!, 'pendingDeliveries');
      context.mounted
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Order accepted')))
          : null;
    } catch (e) {
      context.mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to accept order: $e')))
          : null;
    }
  }

  Future<void> _onReject(
      BuildContext context, String userId, String orderId) async {
    try {
      await _firestoreService
          .updateOrderStatus(userId, orderId, {'orderVisible': false});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? number = prefs.getString('number');
      await _firestoreService.incrementDeliveryCount(
          number!, 'canceledDeliveries');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order rejected')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to reject order: $e')));
    }
  }

  Future<void> _onYes(
      BuildContext context, String userId, String orderId) async {
    try {
      await _firestoreService.updateOrderStatus(
          userId, orderId, {'deliveryStatus': true, 'paymentStatus': true});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? number = prefs.getString('number');
      await _firestoreService.incrementDeliveryCount(
          number!, 'completedDeliveries');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order marked as completed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark order as completed: $e')));
    }
  }

  Future<void> _onNo(
      BuildContext context, String userId, String orderId) async {
    try {
      await _firestoreService.updateOrderStatus(
          userId, orderId, {'deliveryStatus': true, 'paymentStatus': true});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? number = prefs.getString('number');
      await _firestoreService.incrementDeliveryCount(
          number!, 'completedDeliveries');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order marked as completed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark order as completed: $e')));
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('MMMM d, yyyy - HH:mm').format(timestamp.toDate());
  }

  Stream<List<DocumentSnapshot<Object?>>> _getAllUsersOrdersStream() async* {
    Stream<QuerySnapshot<Object?>> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('hasOrdered', isEqualTo: true)
        .snapshots();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    String? number = prefs.getString('number');
    DocumentSnapshot deliveryUserDoc = await FirebaseFirestore.instance
        .collection('Delivery User')
        .doc(number)
        .collection('User Info')
        .doc('Profile')
        .get();

    yield* usersStream.asyncExpand((usersSnapshot) {
      List<Stream<List<DocumentSnapshot>>> orderStreams =
          usersSnapshot.docs.map((userDoc) {
        String city = deliveryUserDoc['city'];
        String state = deliveryUserDoc['state'];
        print('$city,$state');
        String year = DateTime.now().year.toString();
        String month = DateTime.now().month.toString();

        return userDoc.reference
            .collection('orders')
            .doc(year)
            .collection(month)
            // .where('city',isEqualTo: city.toLowerCase())
            // .where('city',isEqualTo: city.toUpperCase())
            // .where('state',isEqualTo: state.toLowerCase())
            // .where('state',isEqualTo: state.toUpperCase())
            //     .where('deliveryStatus', isEqualTo: false)
            //     .where('orderStatus', isEqualTo: true)
            //     .where('paymentStatus', isEqualTo: false)
            //     .where('orderReturn', isEqualTo: false)

            .snapshots()
            .map((orderSnapshot) => orderSnapshot.docs);
      }).toList();

      return CombineLatestStream.list(orderStreams).map((listOfOrderLists) {
        return listOfOrderLists.expand((orderList) => orderList).toList();
      });
    });
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String year = DateTime.now().year.toString();
  String month = DateTime.now().month.toString();

  Future<void> updateOrderStatus(
      String userId, String orderId, Map<String, dynamic> data) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(year)
          .collection(month)
          .doc(orderId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> incrementDeliveryCount(String number, String field) async {
    try {
      await _db
          .collection('Delivery User')
          .doc(number)
          .collection('User Info')
          .doc('Profile')
          .update({field: FieldValue.increment(1)});
    } catch (e) {
      throw Exception('Failed to increment delivery count: $e');
    }
  }

  Stream<List<DocumentSnapshot<Object?>>> getAllUsersOrdersStream(
      bool deliveryStatus,
      bool orderStatus,
      bool paymentStatus,
      bool orderReturn,
      String month) async* {
    Stream<QuerySnapshot<Object?>> usersStream = _db
        .collection('users')
        .where('hasOrdered', isEqualTo: true)
        .snapshots();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? number = prefs.getString('number');
    DocumentSnapshot deliveryUserDoc = await _db
        .collection('Delivery User')
        .doc(number)
        .collection('User Info')
        .doc('Profile')
        .get();

    yield* usersStream.asyncExpand((usersSnapshot) {
      List<Stream<List<DocumentSnapshot>>> orderStreams =
          usersSnapshot.docs.map((userDoc) {
        String city = deliveryUserDoc['city'];
        String state = deliveryUserDoc['state'];
        // print('$city,$state');

        // String year = DateTime.now().year.toString();

        return userDoc.reference
            .collection('orders')
            .doc(year)
            .collection(month)
            .where('deliveryStatus', isEqualTo: deliveryStatus)
            .where('orderStatus', isEqualTo: orderStatus)
            .where('paymentStatus', isEqualTo: paymentStatus)
            .where('orderReturn', isEqualTo: orderReturn)
            .snapshots()
            .map((orderSnapshot) => orderSnapshot.docs);
      }).toList();

      return CombineLatestStream.list(orderStreams).map((listOfOrderLists) {
        return listOfOrderLists.expand((orderList) => orderList).toList();
      });
    });
  }
}

Future<void> _handleOrderAction(
    BuildContext context, Future<void> Function() action) async {
  try {
    // Show loading indicator or a similar feedback
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await action();

    // Dismiss loading indicator
    Navigator.pop(context);
  } catch (e) {
    // Dismiss loading indicator
    Navigator.pop(context);

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('An error occurred: $e'),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Screens/Bnb%20Index/Orders%20Screen/order_list.dart';
import 'package:flutter/material.dart';

import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart';
import 'completed.dart';
import 'pending.dart';
import 'canceled.dart';
import 'returned.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(backgroundColor: m,
//         // forceMaterialTransparency: true,
//         title: Text('DashBoard'),
//         centerTitle: true,
//       ),
//       body:SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(20,10,20,10),
//         child: Column(children: [
//           Card(color: Colors.white54,
//               child: GridView.count(crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           shrinkWrap: true,
//           children: [Container(color: Colors.red),Container(color: Colors.blue),Container(color: Colors.green),Container(color: Colors.yellow)])),
//         Gap.h(20),
//           Text("New Orders",style: textTheme.bodyMedium,)
//
//         ],),
//
//       )
//     );
//   }
// }
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: textTheme.titleLarge?.copyWith(color: Colors.white70),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.notifications_none_sharp),
          )
        ],
        backgroundColor: m,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: getDeliveryCountsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('Loading....');
                        default:
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            // var data = snapshot.data!.data() as Map<String, dynamic>;
                            int completeDeliveryCount = 0;
                            int pendingDeliveryCount = 0;
                            int cancelDeliveryCount = 0;
                            int returnDeliveryCount = 0;
                            return buildGridView(
                                context,
                                completeDeliveryCount,
                                pendingDeliveryCount,
                                cancelDeliveryCount,
                                returnDeliveryCount);
                          }

                          var data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          int completeDeliveryCount =
                              data['completedDeliveries'] ?? 0;
                          int pendingDeliveryCount =
                              data['pendingDeliveries'] ?? 0;
                          int cancelDeliveryCount =
                              data['canceledDeliveries'] ?? 0;
                          int returnDeliveryCount =
                              data['returnDeliveries'] ?? 0;
                          return buildGridView(
                              context,
                              completeDeliveryCount,
                              pendingDeliveryCount,
                              cancelDeliveryCount,
                              returnDeliveryCount);
                      }
                    },
                  )),
            ),
            Gap.h(30),
            Text(
              'New Orders',
              style: textTheme.headlineMedium,
            ),
            Gap.h(20),
            const OrdersList1(
              hasOrdered: true,
              status: 'new order',
              orderReturn: false,
              paymentStatus: false,
              orderStatus: true,
              deliveryStatus: false,
              orderVisible: true,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _BottomNavigationBar(),
    );
  }

  GridView buildGridView(
      BuildContext context,
      int completeDeliveryCount,
      int pendingDeliveryCount,
      int cancelDeliveryCount,
      int returnDeliveryCount) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 5,
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: () => push(context, const Completed()),
          child: _DeliveryCard(
            icon: Icons.check_circle_outline,
            title: 'Complete Delivery',
            count: completeDeliveryCount,
            color: Colors.green.shade50,
          ),
        ),
        GestureDetector(
          onTap: () => push(context, const Pending()),
          child: _DeliveryCard(
            icon: Icons.delivery_dining,
            title: 'Pending Delivery',
            count: pendingDeliveryCount,
            color: Colors.orange.shade50,
          ),
        ),
        GestureDetector(
          onTap: () => push(context, const Canceled()),
          child: _DeliveryCard(
            icon: Icons.cancel_outlined,
            title: 'Cancel Delivery',
            count: cancelDeliveryCount,
            color: Colors.red.shade50,
          ),
        ),
        GestureDetector(
          onTap: () => push(context, const Returned()),
          child: _DeliveryCard(
            icon: Icons.swap_horiz,
            title: 'Return Delivery',
            count: returnDeliveryCount,
            color: Colors.blue.shade50,
          ),
        ),
      ],
    );
  }
}

class _DeliveryStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _DeliveryCard(
            icon: Icons.check_circle_outline,
            title: 'Complete Delivery',
            count: 27,
            color: Colors.green,
          ),
          _DeliveryCard(
            icon: Icons.delivery_dining,
            title: 'Pending Delivery',
            count: 10,
            color: Colors.orange,
          ),
          _DeliveryCard(
            icon: Icons.cancel_outlined,
            title: 'Cancel Delivery',
            count: 5,
            color: Colors.red,
          ),
          _DeliveryCard(
            icon: Icons.swap_horiz,
            title: 'Return Delivery',
            count: 16,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;

  const _DeliveryCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      child: Container(
        // color: color,
        alignment: Alignment.center,
        // padding:const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            Text(
              title,
              softWrap: true,
              style: const TextStyle(
                fontSize: 14.5,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Stream<DocumentSnapshot> getDeliveryCountsStream() async* {
  String? number = SharedPreferencesHelper.getString('number');
  if (number != null) {
    yield* FirebaseFirestore.instance
        .collection('Delivery User')
        .doc(number)
        .collection('User Info')
        .doc('Orders')
        .snapshots();
  } else {
    yield* const Stream<DocumentSnapshot>.empty();
  }
}

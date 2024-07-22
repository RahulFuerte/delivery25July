// import 'package:flutter/material.dart';
//
// import '../../../Utils/utils.dart';
//
// class OrderCard extends StatelessWidget {
//   final String name;
//   final String address;
//   final String dateTime;
//   final String status;
//
//   const OrderCard({super.key,
//
//     required this.name,
//     required this.address,
//     required this.dateTime,
//     required this.status,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // margin: const EdgeInsets.all(20),
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//
//             Gap.w(10),
//             // Order Details and Buttons
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Using ListTile for details
//                   ListTile(
//                     isThreeLine: true,
//                     contentPadding: EdgeInsets.zero,
//                     title: Text(
//                       name,
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Gap.h( 5),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                             Gap.w(5),
//                             Expanded(
//                               child: Text(
//                                 address,
//                                 style: const TextStyle(fontSize: 14, color: Colors.grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Gap.h( 5),
//                         Row(
//                           children: [
//                             const Icon(Icons.access_time, size: 16, color: Colors.grey),
//                             Gap.w(5),
//                             SizedBox(width: 200,
//                               child: Text( softWrap: true,
//                                 maxLines: 2,
//                                 dateTime,
//                                 // "${"${dateTime.toLocal()}".split(' ')[0]} ",
//                                     // " ${"${dateTime.toLocal()}".split(' ')[1]}",
//                                 // "${dateTime.toLocal()}".split(' ')[0] + " " + "${dateTime.toLocal()}".split(' ')[1],
//                                 style: const TextStyle(fontSize: 14, color: Colors.grey),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Gap.h( 5),
//                   // Buttons based on status
//                   Center(child: _buildActionButtons(status)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(String status) {
//     switch (status) {
//       case 'new order':
//         return Row(
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                   minimumSize: Size(100, 40),
//                   backgroundColor: Colors.green),
//               child: const Text('Accept'),
//             ),
//             Gap.w(10),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                   minimumSize: Size(100, 40),
//
//                   backgroundColor: Colors.red),
//               child: const Text('Reject'),
//             ),
//           ],
//         );
//       case 'pending':
//         return Row(
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                   minimumSize: Size(100, 40),
//
//                   backgroundColor: Colors.green),
//               child: const Text('Yes'),
//             ),
//             Gap.w(10),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                   minimumSize: Size(100, 40),
//                   backgroundColor: Colors.red),
//               child: const Text('No'),
//             ),
//           ],
//         );
//       case 'delivered':
//         return ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//               minimumSize: Size(100, 40),
//               backgroundColor: Colors.grey),
//           child: const Text('Delivered'),
//         );
//       case 'return':
//         return ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//               minimumSize: Size(100, 40),
//               backgroundColor: Colors.grey),
//           child: const Text('Returned'),
//         );
//       default:
//         return const SizedBox.shrink();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart'; // Import for date formatting

class OrderCard extends StatelessWidget {
  final String name,orderId,userId;
  final String address;
  final DateTime dateTime;
  final String status;
  final int totalQty;
  // final List<Map<String, dynamic>> orderItems; // List of order items
  final String totalPrice;


  final VoidCallback onAccept,onReject,onYes,onNo;
  // Total order price
  // final String paymentStatus;
  // final String deliveryMode;

  const OrderCard({
    super.key,
    required this.name,
    required this.address,
    required this.dateTime,
    required this.status,
    // required this.orderItems,
    required this.totalPrice, required this.totalQty, required this.onAccept, required this.onReject, required this.onYes, required this.onNo, required this.orderId, required this.userId,
    // required this.paymentStatus,
    // required this.deliveryMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              isThreeLine: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 2),
              title: Row(
                children:[
                  const Icon(Icons.person,size: 16,),
                  Gap.w(5),
                  Text(
                  name.toUpperCase(),
                  style: textTheme.titleLarge,
                ),
                const Spacer(),
                // Icon(Icons.favorite_border,size: 16,),
                ]
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wallet,size: 16,),
                      Gap.w(5),
                      Text('Order Id: $orderId'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.black),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          softWrap: true,
                          address,
                          style: textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone_android, size: 16, color: Colors.black),
                      const SizedBox(width: 5),
                      Text(userId,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Gap.h(5),

                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.black),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('MMMM d, yyyy - HH:mm').format(dateTime),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Gap.h(5),
                  Row(
                    children: [
                      Text('Quantity: $totalQty',style:const TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold) ,),
                      const SizedBox(width: 10),
                      Text('Total Price: ₹$totalPrice',

                        style: const TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),

                        // overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  _buildActionButtons(status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status) {
    switch (status) {
      case 'new order':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                backgroundColor: Colors.green.shade300,
              ),
              child: const Text('Accept'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onReject,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                backgroundColor: Colors.white,
                side:const BorderSide(width: 1 ,color: Colors.red)
              ),
              child: Text('Reject',style: textTheme.bodyLarge?.copyWith(color: Colors.red),),
            ),
          ],
        );
      case 'pending':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onYes,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                backgroundColor: Colors.green.shade300,
              ),
              child: const Text('Yes'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onNo,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                  backgroundColor: Colors.white,
                  side:const BorderSide(width: 1 ,color: Colors.red)
              ),
              child: const Text('No',style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      case 'delivered':
        return Center(
          child: ElevatedButton(
            onPressed: () {
              // Handle delivered action
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              backgroundColor: Colors.grey,
            ),
            child: const Text('Delivered'),
          ),
        );
      case 'return':
        return Center(
          child: ElevatedButton(
            onPressed: () {
              // Handle return action
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
              backgroundColor: Colors.grey,
            ),
            child: const Text('Returned'),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

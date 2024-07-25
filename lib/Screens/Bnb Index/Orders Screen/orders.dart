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
            children:   [
              OrderCard(
                userId: Text('userUid'),
                orderId: Text('orderId'),
                name: Text('userName'),
                address: Text('userAddress'),
                dateTime: DateTime.now(),
                status: 'new order',
                totalPrice: 56,
                totalQty: totalQuantity,
                onAccept: () {},

                onReject: (){},
                onNo: (){},
                onYes: (){},
              ), OrderCard(
                userId: Text('userUid'),
                orderId: Text('orderId'),
                name: Text('userName'),
                address: Text('userAddress'),
                dateTime: DateTime.now(),
                status: 'pending',
                totalPrice: 56,
                totalQty: totalQuantity,
                onAccept: () {},

                onReject: (){},
                onNo: (){},
                onYes: (){},
              ), OrderCard(
                userId: Text('userUid'),
                orderId: Text('orderId'),
                name: Text('userName'),
                address: Text('userAddress'),
                dateTime: DateTime.now(),
                status: 'delivered',
                totalPrice: 56,
                totalQty: totalQuantity,
                onAccept: () {},

                onReject: (){},
                onNo: (){},
                onYes: (){},
              ), OrderCard(
                userId: Text('userUid'),
                orderId: Text('orderId'),
                name: Text('userName'),
                address: Text('userAddress'),
                dateTime: DateTime.now(),
                status: 'return',
                totalPrice: 56,
                totalQty: totalQuantity,
                onAccept: () {},

                onReject: (){},
                onNo: (){},
                onYes: (){},
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



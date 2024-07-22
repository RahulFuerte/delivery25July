import 'package:delivery/Screens/Bnb%20Index/Orders%20Screen/orders.dart';
import 'package:delivery/Screens/Bnb%20Index/Profile%20Screen/profile.dart';
import 'package:delivery/Utils/utils.dart';
import 'package:flutter/material.dart';

import 'Histrory Screen/history.dart';
import 'Home Screen/home.dart';

class BnbIndex extends StatefulWidget {
  const BnbIndex({super.key});

  @override
  State<BnbIndex> createState() => _BnbIndexState();
}

class _BnbIndexState extends State<BnbIndex> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
     const DashboardScreen(),
    const OrdersPage(),
    const History(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // color: Colors.blue,
      shadowColor:Colors.black,
      height: 68,
      child: Container(
// height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.shopping_bag, 'Orders', 1),
            _buildNavItem(Icons.history, 'History', 2),
            _buildNavItem(Icons.person, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: index == currentIndex ? m : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: index == currentIndex ? m : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Orders Screen'),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}

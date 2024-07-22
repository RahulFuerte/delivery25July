import 'dart:math';

import 'package:delivery/Screens/splash1.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:delivery/Utils/Theme%20Data/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/Authentication Screens/Phone Auth Screen/phone_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesHelper().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    textTheme = Theme
        .of(context)
        .textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comprehensive Theme Demo',
      theme: comprehensiveThemeData,
      home: const Splash1(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comprehensive Theme Demo'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.star)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildTabContent(context),
            buildTabContent(context),
            buildTabContent(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget buildTabContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text('This is a comprehensive theme demo!',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {}, child: const Text('Custom Themed Button')),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Custom Themed Button')),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {}, child: const Text('Custom Themed TextButton')),
          const SizedBox(height: 20),
          OutlinedButton(
              onPressed: () {},
              child: const Text('Custom Themed OutlinedButton')),
          const SizedBox(height: 20),
          ToggleButtons(
              isSelected: const [true, false, false],
              onPressed: (int index) {},
              children: const <Widget>[
                Icon(Icons.looks_one),
                Icon(Icons.looks_two),
                Icon(Icons.looks_3)
              ]),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Custom Themed TextField',
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.star),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Custom Themed Card'),
            ),
          ),
          const SizedBox(height: 20),
          const Chip(
            label: Text('Custom Themed Chip'),
          ),
          const SizedBox(height: 20),
          Slider(
            value: 50,
            min: 0,
            max: 100,
            divisions: 10,
            label: '50',
            onChanged: (double value) {},
          ),
          const SizedBox(height: 20),
          const Tooltip(
            message: 'Custom Themed Tooltip',
            child: Icon(Icons.info),
          ),
          const SizedBox(height: 20),
          PopupMenuButton<String>(
            onSelected: (String result) {},
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Value1',
                child: Text('Value 1'),
              ),
              const PopupMenuItem<String>(
                value: 'Value2',
                child: Text('Value 2'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Switch(
            value: true,
            onChanged: (bool value) {},
          ),
          const SizedBox(height: 20),
          Radio<int>(
            value: 1,
            groupValue: 1,
            onChanged: (int? value) {},
          ),
          const SizedBox(height: 20),
          Checkbox(
            value: true,
            onChanged: (bool? value) {},
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Custom Themed Dialog'),
                    content: const Text('This is a custom themed dialog.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Show Dialog'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Custom Themed SnackBar'),
                ),
              );
            },
            child: const Text('Show SnackBar'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Theme
                        .of(context)
                        .bottomSheetTheme
                        .backgroundColor,
                    child: const Center(
                      child: Text('Custom Themed BottomSheet'),
                    ),
                  );
                },
              );
            },
            child: const Text('Show BottomSheet'),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(minutes: 1),
      vsync: this,
    );
    _rotationAnimation =
    Tween<double>(begin: 0, end: 2 * pi).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _scaleAnimation =
    Tween<double>(begin: 0.5, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PhoneAuth()),
          );
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(
              value: _scaleAnimation.value,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
//
// class SplashScreen1 extends StatefulWidget {
//   @override
//   _SplashScreen1State createState() => _SplashScreen1State();
// }

// class _SplashScreen1State extends State<SplashScreen1> {
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//       splash: Center(
//         child: Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(60),
//           ),
//           child: Image.asset(
//             'assets/images/logo.png',
//             width: 80,
//             height: 80,
//           ),
//         ),
//       ),
//       nextScreen: const PhoneAuth(),
//       splashTransition: SplashTransition.rotationTransition,
//       duration: 2000,
//     );
//   }
// }

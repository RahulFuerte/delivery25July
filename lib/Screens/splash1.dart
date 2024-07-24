import 'dart:async';

import 'package:delivery/Screens/Authentication%20Screens/Phone%20Auth%20Screen/phone_auth.dart';
import 'package:delivery/Screens/Bnb%20Index/bnb_index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> with TickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    Timer(
      const Duration(seconds: 3),
      () => replace(context,
          auth.currentUser != null ? const BnbIndex() :
          const PhoneAuth()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: m,
      body: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.start,
          direction: Axis.vertical,
          // runSpacing:100,
          spacing: 50,
          alignment: WrapAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.1415,
                  child: AnimatedOpacity(
                    opacity: _controller.value,
                    duration: const Duration(seconds: 1),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          // Replace with your logo image path
                          // width: 250,
                          // height: 250,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            FadeTransition(
              opacity: _animation,
              child: RichText(
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Welcome!\n',
                    style: title.titleLarge?.copyWith(color: Colors.white70),
                  ),
                  TextSpan(
                      text: 'We are glad to see you',
                      style: title.bodySmall?.copyWith(color: Colors.white70))
                ]),
              ),
            ),

// FadeTransition(opacity: _animation,child: Column(children: [const CircularProgressIndicator(),
//
//   Text('Loading...',style: title.bodyLarge?.copyWith(color: Colors.white70),)],),)
          ],
        ),
      ),
    );
  }
}

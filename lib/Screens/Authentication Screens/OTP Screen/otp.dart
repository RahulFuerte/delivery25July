import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Screens/Authentication%20Screens/Phone%20Auth%20Screen/phone_auth.dart';
import 'package:delivery/Screens/Bnb%20Index/bnb_index.dart';
import 'package:delivery/Screens/Registeration%20Screens/User%20Info/Personal%20Info/personal_info.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:delivery/Utils/utils.dart';
import 'package:delivery/Widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Otp extends StatefulWidget {
  final String verificationId, phone;

  const Otp({super.key, required this.verificationId, required this.phone});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 30;
  bool _isResendAvailable = false, _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _isResendAvailable = false;
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendAvailable = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    _startTimer();
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to Resend OTP: ${e.message}')));
      },
      codeSent: (String verificationId, int? resendToken) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('OTP Resent')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    String otp = _otpControllers.map((controller) => controller.text).join();
    print(otp);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Phone number verified successfully')));
        // SharedPreferences prefs = await SharedPreferences.getInstance();

        await SharedPreferencesHelper.setString('number', widget.phone);
        bool userExists = await checkIfUserExists(widget.phone);

        if (userExists) {
          // Get user data
          Map<String, dynamic>? userData = await getUserData(widget.phone);

          if (userData != null) {
            // Save user data to SharedPreferences
            await saveUserDataToSharedPreferences(userData);

            // Navigate to the home page if the user exists
            mounted?remove(context, const BnbIndex()):null;
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }
        mounted?remove(context, userExists?const BnbIndex(): PersonalInfo(number: widget.phone)):null;
      }
    } catch (e) {
      if (mounted) {
        if (kDebugMode) {
          print('Failed to verify OTP: $e');
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Center(child: Text('Please enter OTP/ Invalid OTP'))));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearAllBoxes() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: m,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Center(
            child: Column(children: [
              Lottie.asset(
                'assets/animations/otp.json',
                height: 300,
                width: 300,
              ),
              Text(
                'Please verify your account by entering the OTP set to ${widget.phone}.',
                style: textTheme.titleMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              Gap.h(10),
              Text(
                'Enter your OTP',
                style: textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
              Gap.h(15),
              Stack(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    ...List.generate(6, (index) => _buildOtpBox(index)),
                    // IconButton(
                    //     icon: const CircleAvatar(
                    //         radius: 10,
                    //         backgroundColor: Colors.red,
                    //         child: Center(
                    //           child: Icon(
                    //             Icons.clear,
                    //             color: Colors.white,
                    //             size: 15,
                    //           ),
                    //         )),
                    //     onPressed: _otpControllers.clear)
                  ]),
                  Positioned(
                    top: 11,
                    right: -.1,
                    child: GestureDetector(
                        onTap: _clearAllBoxes,
                        child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Center(
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 15,
                              ),
                            ))),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '$_secondsRemaining seconds',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    "Didn't receive OTP?",
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  InkWell(
                      onTap: () => _isResendAvailable ? _resendOtp : null,
                      child: Text(
                        'Resend',
                        style: textTheme.bodyMedium?.copyWith(
                            color:
                                _isResendAvailable ? Colors.blue : Colors.grey),
                      ))
                ],
              ),
              Gap.h(20),
              Text(
                'If the OTP is invalid. Please check or edit the phone number and resend the OTP ',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => push(context, const PhoneAuth()),
                  child: Text(
                    'Click here to edit number',
                    style: textTheme.bodyMedium?.copyWith(
                        color: Colors.orangeAccent,
                        fontStyle: FontStyle.italic),
                    // textAlign: TextAlign.left,
                  ),
                ),
              ),
            ]),
          ),
        ),
        bottomNavigationBar: buildBottomButton(
            context, textTheme, 'Next', _isLoading, _verifyOtp)
        // ElevatedButton(onPressed: _verifyOtp, child: const Text('Next')),
        );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        validator: (value){
          // final _otpControllers. =value;
          _otpControllers.isEmpty?'Please Enter your OTP':null;
          return null;
        },
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 2)),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < _otpControllers.length - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
            // Clear the previous OTP boxes if the current one is cleared
            for (int i = index; i < _otpControllers.length; i++) {
              _otpControllers[i].clear();
            }
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1)
        ],
      ),
    );
  }
}

Future<void> saveUserDataToSharedPreferences(
    Map<String, dynamic> userData) async {
  await SharedPreferencesHelper.setString('name', userData['name'] ?? '');
  await SharedPreferencesHelper.setString('dob', userData['dob'] ?? '');
  await SharedPreferencesHelper.setString('email', userData['email'] ?? '');
  await SharedPreferencesHelper.setString('gender', userData['gender'] ?? '');
  await SharedPreferencesHelper.setString('panNo', userData['panNo'] ?? '');
  await SharedPreferencesHelper.setString('aadhaarNo', userData['aadhaarNo'] ?? '');
  await SharedPreferencesHelper.setString('profileImage', userData['profileImage'] ?? '');
  await SharedPreferencesHelper.setString('city', userData['city'] ?? '');
  await SharedPreferencesHelper.setString('state', userData['state'] ?? '');
  await SharedPreferencesHelper.setString('address', userData['address'] ?? '');
}

Future<bool> checkIfUserExists(String phoneNumber) async {
  try {
    // Construct the reference to the document
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
    await FirebaseFirestore.instance
        .collection('Delivery User') // Replace with your collection name
        .doc(phoneNumber) // Assuming phone number is the document ID
        .collection('User Info')
        .doc('Profile')
        .get();

    return docSnapshot.exists;
  } catch (e) {
    // Handle any errors here
    print('Error checking user existence: $e');
    return false; // Assuming user doesn't exist in case of an error
  }
}

Future<Map<String, dynamic>?> getUserData(String phoneN) async {
  final docSnapshot = await FirebaseFirestore.instance
      .collection('Delivery User')
      .doc(phoneN)
      .collection('User Info')
      .doc('Profile')
      .get();

  if (docSnapshot.exists) {
    return docSnapshot.data() as Map<String, dynamic>;
  } else {
    return null;
  }
}

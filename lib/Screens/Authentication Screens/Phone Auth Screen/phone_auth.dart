
import 'package:country_code_picker/country_code_picker.dart';
import 'package:delivery/Screens/Authentication%20Screens/OTP%20Screen/otp.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:delivery/Widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/utils.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

Future<SharedPreferences> prefs = SharedPreferences.getInstance();

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+91';
  bool _isValidNumber = false;
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;

  void _validatePhoneNumber(String value) {
    setState(() {
      _isValidNumber = value.length == 10 && RegExp(r'^[6789]').hasMatch(value);
      if (value.length == 10) _focusNode.unfocus();
    });
  }

  void _clearPhoneNumber() {
    _phoneController.clear();
    setState(() {
      // _isValidNumber = true;
    });
  }

//   Future<void> _sendOtp() async {
//     if (_isValidNumber) {
//       setState(() {
//         _isLoading = true;
//       });
//       final phone = '$_countryCode${_phoneController.text}';
//       bool userExists = await checkIfUserExists(phone);
// //
//         if (userExists && mounted) {
//           // Navigate to the home page if the user exists
//           remove(context, const BnbIndex());
//           setState(() {
//             _isLoading = false;
//           });
//           return;
//         }
//       try {
//         await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: phone,
//           verificationCompleted: (PhoneAuthCredential credential) {},
//           verificationFailed: (FirebaseAuthException e) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text('Failed to verify Phone Number:${e.message}'),
//             ));
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             push(context, Otp(verificationId: verificationId, phone: phone));
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {},
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid phone number')),
//       );
//     }
//   }

  Future<void> _sendOtp() async {
    if (_isValidNumber) {
      setState(() {
        _isLoading = true;
      });

      final phone = '$_countryCode${_phoneController.text}';
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return loadingAnimation();

        },
      );

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to verify Phone Number: ${e.message}'),
            ));
          },
          codeSent: (String verificationId, int? resendToken) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('OTP send to $phone'),
            ));
            push(context, Otp(verificationId: verificationId, phone: phone));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }



  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: m,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 10),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/phone.json'),
                Text(
                  'Phone Verification',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                Gap.h(10),
                Text(
                  'We need to register your phone before\ngetting started!',
                  style: textTheme.titleSmall?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                Gap.h(20),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height / 17,
                  padding: const EdgeInsets.symmetric(horizontal: .1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CountryCodePicker(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        flagWidth: 45,
                        // showOnlyCountryWhenClosed: true,
                        showCountryOnly: true,
                        showFlagDialog: true,
                        showFlag: true,
                        // showDropDownButton: true,
                        hideMainText: true,
                        // alignLeft: true,
                        // onInit:(countryCode){
                        //   setState(() {
                        //     _countryCode = countryCode.toString();
                        //   });
                        // },
                        onChanged: (countryCode) {
                          setState(() {
                            _countryCode = countryCode.toString();
                          });
                        },
                        initialSelection: 'IN',
                        favorite: const ['IN'],
                      ),
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          thickness: 1,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            focusNode: _focusNode,
                            textAlignVertical: TextAlignVertical.top,
                            // scrollPadding: ,
                            controller: _phoneController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintTextDirection: TextDirection.ltr,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 0, 0, 5),
                              hintText: 'Enter phone number',
                              border: InputBorder.none,
                              hintStyle: textTheme.bodyMedium,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              // suffixIcon:
                            ),
                            onChanged: _validatePhoneNumber,
                          ),
                        ),
                      ),
                      _phoneController.text.isNotEmpty
                          ? !_isValidNumber
                              ? IconButton(
                                  icon: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      )),
                                  onPressed: _clearPhoneNumber,
                                )
                              : const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildBottomButton(
          context,
          textTheme,
          'Next',
          _isLoading,
          _isValidNumber
              ? _sendOtp
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid phone number')),
                  );
                },
        ));
  }
}

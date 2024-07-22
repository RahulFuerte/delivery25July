import 'package:csc_picker/csc_picker.dart';
import 'package:delivery/Screens/Registeration%20Screens/User%20Info/Documents%20Info/aadhaar_pan.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:delivery/Utils/utils.dart';
import 'package:delivery/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManualAddressPage extends StatefulWidget {
  final XFile? profileImageUrl;
  final String? name;
  final String? dob;
  final String? email;
  final String? number;
  final String? gender;

  const ManualAddressPage({
    super.key,
    this.name,
    this.dob,
    this.email,
    this.profileImageUrl,
    this.number,
    this.gender,
  });

  @override
  State<ManualAddressPage> createState() => _ManualAddressPageState();
}

class _ManualAddressPageState extends State<ManualAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  String countryValue = '', stateValue = '', cityValue = '';
  String? landmark;
  bool _isLoading = false;
  bool _isValid = true; // Initialized to true to avoid initial error message

  Future<void> _handleButton() async {
    print('Button pressed');
    print('Address: ${_addressController.text}');
    print('Landmark: ${_landmarkController.text}');
    print('Country: $countryValue');
    print('State: $stateValue');
    print('City: $cityValue');

    if (_formKey.currentState!.validate() &&
        countryValue.isNotEmpty &&
        stateValue.isNotEmpty &&
        cityValue.isNotEmpty) {
      setState(() {
        _isValid = true;
        _isLoading = true;
      });
      print('Form is valid');

      try {
        // Your form submission logic here
        // await pushPage(
        //   context,
        //   AadhaarPanDetails(
        //     name: widget.name,
        //     profileImageUrl: widget.profileImageUrl,
        //     email: widget.email,
        //     number: widget.number,
        //     city: cityValue,
        //     country: countryValue,
        //     state: stateValue,
        //     dob: widget.dob,
        //     address: _addressController.text,
        //   ),
        // );
        print('Navigation successful');
      } catch (e) {
        // Handle any errors here
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
        print('Loading finished');
      }
    } else {
      setState(() {
        _isValid = false;
      });
      print('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: m,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Address Verification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gap(50),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: 'Address ',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                gap(10),
                textFormField(
                    context: context,
                    labelText: 'Address',
                    controller: _addressController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    }),

                gap(20),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: 'Landmark',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                gap(10),

                textFormField(
                    context: context,
                    labelText: 'Landmark',
                    controller: _landmarkController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Landmark';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      landmark = value;
                    }),

                gap(20),
                CSCPicker(
                  selectedItemStyle: const TextStyle(color: Colors.white70),
                  dropdownDecoration: BoxDecoration(
                    // border: BoxBorder.lerp(a, b, t),
                    // color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  disabledDropdownDecoration: BoxDecoration(
                      // color: Colors.,

                      borderRadius: BorderRadius.circular(5)),
                  layout: Layout.vertical,
                  defaultCountry: CscCountry.India,
                  showCities: true,
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value ?? '';
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value ?? '';
                    });
                  },
                ),
                gap(20),
                // Center(
                //   child: myButton(
                //     text: 'Next',
                //     onPressed: _handleButton,
                //     isLoading: _isLoading,
                //     isValid: _isValid,
                //   ),
                // ),

                if (!_isValid)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Please fill out the form correctly.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          buildBottomButton(context, textTheme, 'Next', _isLoading, () {
        print('this is landmark:$landmark,,${_landmarkController.text}');

        var address= '${_addressController.text}, ${_landmarkController.text}';

        print(address);
        push(
            context,
            AadhaarPanDetails(
              name: widget.name,
              number: widget.number,
              email: widget.email,
              profileImage: widget.profileImageUrl,
              address: address,
              state: stateValue,
              city: cityValue,
              country: countryValue,
              dob: widget.dob,
              gender: widget.gender,


            ));
      }),
    );
  }

//   Future<void> pushPage(BuildContext context, Widget page) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => page),
//     );
//     print('Pushing page: $page');
//   }
// }

  Widget myButton({
    required String text,
    required VoidCallback onPressed,
    required bool isLoading,
    required bool isValid,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ElevatedButton(
      onPressed: isLoading || !isValid ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(350, 50),
        elevation: 10,
        backgroundColor: backgroundColor ??
            (isLoading || !isValid ? Colors.grey : Colors.blue),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.0,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? Colors.white,
              ),
            ),
    );
  }

  Widget gap(double height) {
    return SizedBox(height: height);
  }
}

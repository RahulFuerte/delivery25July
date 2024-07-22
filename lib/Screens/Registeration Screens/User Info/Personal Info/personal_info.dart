import 'dart:io';

import 'package:delivery/Function/Image%20Picker%20Options/image_picker_Options.dart';
import 'package:delivery/Screens/Registeration%20Screens/User%20Info/Address%20Info/bothAddress.dart';
import 'package:delivery/Utils/Global/global.dart';
import 'package:delivery/Utils/utils.dart';
import 'package:delivery/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  final String number;

  const PersonalInfo({super.key, required this.number});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  String? _name,_dob,_email,_gender;
  bool _isLoading = false;
  XFile? selectedProfileImage;



  final TextEditingController _dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: m, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.white70, // Background color of calendar
              onSurface: Colors.black, // Text color of the dates
            ),
            dialogBackgroundColor:
                Colors.blue, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dob = DateFormat('dd/MM/yyyy').format(picked);
        _dobController.text = _dob!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: m,
      appBar: AppBar(
        toolbarOpacity: 0,
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          'Get to Know You',
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gap.h(20),
              GestureDetector(
                onTap: () async {
                  final XFile? pickedImage = await showImagePickOption(context);
                  if (pickedImage != null) {
                    selectedProfileImage = pickedImage;
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: selectedProfileImage != null
                      ? FileImage(File(selectedProfileImage!.path))
                      : const AssetImage('assets/images/uploadIcon.png'),
                  // child: selectedProfileImage != null
                  //     ? Image.file(File(selectedProfileImage!.path))
                  //     : const Icon(Icons.person, size: 40),
                ),
              ),
              const SizedBox(height: 60),
              textFormField(
                context: context,
                labelText: 'Enter your name',
                sIcon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),

              Gap.h(20),
              textFormField(
                context: context,
                  controller: _dobController,
                  labelText: 'Date of Birth',
                  readOnly: true,
                  sIcon: const Icon(Icons.calendar_today),
                  onSaved: (value) {
                    _dob = value;
                  },
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  }),

              Gap.h(20),
              textFormField(
                context: context,
                labelText: 'Email',
                sIcon: const Icon(Icons.email),
                onSaved: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$',
                          caseSensitive: false)
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              Gap.h(20),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text(
                    'Male',
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  Text('Female',
                    style:
                    textTheme.bodyMedium?.copyWith(color: Colors.white70),),
                ],
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar:
      buildBottomButton(context, textTheme, 'Next', _isLoading, () async {
        if (_formKey.currentState!.validate() ) {
          setState(() {
            _isLoading = true;
          });
          _formKey.currentState!.save();
          // Simulate a network call
          await Future.delayed(const Duration(seconds: 2));
          // Do something with the data
          print('Name: $_name');
          print('Date of Birth: $_dob');
          print('Email: $_email');
          print('Gender: $_gender');
          Navigator.push(context,MaterialPageRoute(builder: (context)=> BothAddress(
              profileImage: selectedProfileImage,name: _name!,dob: _dob!, number: widget.number,email: _email!,gender:_gender!
            )));

          setState(() {
            _isLoading = false;
          });
        }
      }),
    );
  }
}

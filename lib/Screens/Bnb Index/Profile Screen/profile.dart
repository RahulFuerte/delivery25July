import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart';
import '../../Authentication Screens/Phone Auth Screen/phone_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Delivery User');
  FirebaseAuth auth = FirebaseAuth.instance;


  String _profileImage = '';
  bool _isEditing = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  // Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // void _loadUserData() async {
  //   String? number = '+919999999999';
  //   // final documentPath = 'Delivery User/$number/User Info/Profile';
  //   final userCollection = FirebaseFirestore.instance;
  //   final docRef = userCollection.collection('Delivery User').doc(number).collection('User Info').doc('Profile');
  //
  //   // final docRef = userCollection.doc(documentPath);
  //
  //
  //   try {
  //     final docSnap = await docRef.get();
  //
  //     final userDoc = await _usersCollection.doc(number).collection('User Info').doc('Profile').get();
  //     if (userDoc.exists) {
  //       final data = docSnap.data() as Map<String,dynamic>;
  //       print('Data: $data');
  //
  //       final userData = userDoc.data() as Map<String, dynamic>;
  //
  //       setState(() {
  //
  //         _profileImage = userData['profileImage'];
  //         _nameController.text = userData['name'];
  //         _ageController.text = userData['age'].toString();
  //         _addressController.text = userData['address'];
  //         _cityController.text = userData['city'];
  //         // _profileImage =data['profileImage'];
  //         // _nameController.text =data['name'];
  //         // _ageController.text =data['dob'].toString();
  //         // _addressController.text =data['address'];
  //         // _cityController.text =data['city'];
  //       });
  //       print('User data loaded successfully:');
  //       print('Profile Image: $_profileImage');
  //       print('Name: ${_nameController.text}');
  //       print('Age: ${_ageController.text}');
  //       print('Address: ${_addressController.text}');
  //       print('City: ${_cityController.text}');
  //     } else {
  //       print('User document does not exist');
  //       print('User document does not exist at path: ${docRef.path}');
  //       //Delivery User/+919999999999/User Info/Profile
  //       //Delivery User/+919999999999/User Info/Profile;
  // // var Delivery User/+919999999999/User Info/Profile
  //
  //
  //
  //   }
  //   } catch (e) {
  //     print('Error loading user data: $e');
  //   }
  // }

  void _loadUserData() async {

    String? number = SharedPreferencesHelper.getString('number');
    print(number);
    final docRef = _usersCollection.doc(number).collection('User Info').doc('Profile');

    try {
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final userData = docSnap.data() as Map<String, dynamic>;

        setState(() {
          _profileImage =SharedPreferencesHelper.getString('profileImage')??userData['profileImage'];

          _nameController.text = SharedPreferencesHelper.getString('name')??userData['name'];
          _ageController.text = SharedPreferencesHelper.getString('dob')??userData['dob'].toString();
          _addressController.text = SharedPreferencesHelper.getString('address')??userData['address'];
          _cityController.text = SharedPreferencesHelper.getString('city')??userData['city'];
        });


      }
      else {
        print('User document does not exist');
        print('User document does not exist at path: ${docRef.path}');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }


  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await _usersCollection.doc('user_id').update({
          'profileImage': _profileImage,
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'address': _addressController.text,
          'city': _cityController.text,
        });

        setState(() {
          _isEditing = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

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
            (isLoading || !isValid ? Colors.white60 : m),
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
              selectionColor: Colors.white,
              style: TextStyle(
                  fontSize: 16,
                  color:
                      textColor ?? (isValid ? Colors.white : Colors.white60)),
            ),
    );
  }

  Widget textField({
    required BuildContext context,
    required TextInputType keyboardType,
     VoidCallback? onChanged,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    String? errorText,
    Widget? sIcon,
    bool enabled = true,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: (value) => onChanged!(),
      controller: controller,
      enabled: enabled,
      style: const TextStyle(
        color: m,
        fontSize: 20,
        overflow: TextOverflow.fade,
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color:Colors.brown),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color:m),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: m),
        floatingLabelStyle: const TextStyle(color:m),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(color: m),
        suffixIcon: sIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sign Out',style: textTheme.headlineMedium,),
                    content: Text('Are you sure you want to sign out?',style: textTheme.bodyLarge,),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('No',style: TextStyle(color: m),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          auth.signOut();
                          remove(context, const PhoneAuth());
                        },
                        child: const Text('Yes',style: TextStyle(color: m)),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),

        )],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _profileImage.isNotEmpty?
              GestureDetector(
                onTap: (){},
                child: CircleAvatar(

                      radius: 50,
                  backgroundImage:
                  NetworkImage(_profileImage,scale: 1)
                ),
              ):const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/uploadIcon.png'),
              ),
              Gap.h(30),
              textField(
                context: context,
                keyboardType: TextInputType.name,
                // onChanged: ,
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter your name',
                // errorText: null,
                sIcon: const Icon(Icons.person),
                enabled: _isEditing,
              ),
              Gap.h(20),

              textField(
                context: context,
                keyboardType: TextInputType.number,
                // onChanged: () {},
                controller: _ageController,
                labelText: 'Date of Birth',
                hintText: 'Enter your age',
                // errorText: null,
                sIcon: const Icon(Icons.cake),
                enabled: _isEditing,
              ),
              Gap.h(20),

              textField(
                context: context,
                keyboardType: TextInputType.streetAddress,
                // onChanged: () {},
                controller: _addressController,
                labelText: 'Address',
                hintText: 'Enter your address',
                // errorText: null,
                sIcon: const Icon(Icons.home),
                enabled: _isEditing,
              ),
                  Gap.h(20),
              textFormField(
                context: context,
                keyboardType: TextInputType.text,
                // onChanged: () {},
                controller: _cityController,
                labelText: 'City',
                hintText: 'Enter your city',
                // errorText: nul
                sIcon: const Icon(Icons.location_city),
                enabled: _isEditing,
              ),
              Gap.h(20),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isEditing
            ? myButton(
          text: 'Save Changes',
          onPressed: _saveChanges,
          isLoading: _isLoading,
          isValid: true,
        )
            : myButton(
          text: 'Edit',
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          isLoading: _isLoading,
          isValid: true,
        ),
      ),
    );
  }
}

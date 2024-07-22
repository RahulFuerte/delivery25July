// import 'dart:io';
//
// import 'package:delivery/Function/Firebase/upload_image.dart';
// import 'package:delivery/Function/Image%20Picker%20Options/image_picker_Options.dart';
// import 'package:delivery/Screens/Bnb%20Index/bnb_index.dart';
// import 'package:delivery/Utils/Global/global.dart';
// import 'package:delivery/Utils/utils.dart';
// import 'package:delivery/Widgets/widgets.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../Function/Firebase/upload_data.dart';
//
// // import 'package:mobile/Pages/Bottom%20Navigation%20Pages/Indexing/bnb_indexing.dart';
// // import 'package:mobile/functions/show_image_option.dart';
// // import 'package:mobile/widgets/button_widget.dart';
// //
// // import '../../../../firebase/data_upload.dart';
// // import '../../../../firebase/image_upload.dart';
// // import '../../../../utils/utils.dart';
//
// class AadhaarPanDetails extends StatefulWidget {
//   final String? gender,name,dob,email,address,city,state,country,number;
// final XFile? profileImage;
//   const AadhaarPanDetails({
//     super.key,
//     this.name,
//     this.dob,
//     this.email,
//     this.profileImage,
//     this.address,
//     this.city,
//     this.state,
//     this.country,
//     this.number,
//     this.gender
//   });
//
//   @override
//   State<AadhaarPanDetails> createState() => _AadhaarPanDetailsState();
// }
//
// class _AadhaarPanDetailsState extends State<AadhaarPanDetails> {
//   final _formKey = GlobalKey<FormState>();
//
//   String? _aadhaarNo, _panNo;
//   bool _isValid = false;
//   bool _isLoading = false;
//   bool _isUploading = false;
//   XFile? selectedPanImage;
//   XFile? selectedAadhaarFrontImage;
//   XFile? selectedAadhaarBackImage;
//
//   String? panImageUrl,profileImageUrl;
//   String? aadhaarFrontImageUrl;
//   String? aadhaarBackImageUrl;
//
//   // void _storeUserData() {
//   //   storeUserData(
//   //     id: '${widget.number}',
//   //     name: '${widget.name}',
//   //     address: '${widget.address}',
//   //     profileImage: '${widget.profileImageUrl}',
//   //     panNo: _panNo!,
//   //     panImage: panImageUrl ?? '',
//   //     aadhaarNo: _aadhaarNo!,
//   //     aadhaarFrontImage: aadhaarFrontImageUrl ?? '',
//   //     aadhaarBackImage: aadhaarBackImageUrl ?? '',
//   //     city: '${widget.city}',
//   //     state: '${widget.state}',
//   //   );
//   // }
//
//   bool panValidate(String value) {
//     String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
//     RegExp regex = RegExp(pattern);
//     return regex.hasMatch(value);
//   }
//
//   RegExp aadhaarRegExp = RegExp(r'^[0-9]{12}$');
//
//   bool aadhaarValidate(String value) {
//     return aadhaarRegExp.hasMatch(value);
//   }
//
//   Future<void> _uploadImages() async {
//     setState(() {
//       _isUploading = true;
//     });
//
//     try {
//       if (selectedPanImage != null) {
//         panImageUrl = await uploadImageToFirebaseStorage(
//             selectedPanImage!, '${widget.number}', context, 'PAN Image');
//       }
//       if (selectedAadhaarFrontImage != null && mounted) {
//         aadhaarFrontImageUrl = await uploadImageToFirebaseStorage(
//             selectedAadhaarFrontImage!,
//             '${widget.number}',
//             context,
//             'Aadhaar Front Image');
//       }
//       if (selectedAadhaarBackImage != null && mounted) {
//         aadhaarBackImageUrl = await uploadImageToFirebaseStorage(
//             selectedAadhaarBackImage!,
//             '${widget.number}',
//             context,
//             'Aadhaar Back Image');
//
//       }
//       if (widget.profileImage != null && mounted){
//         profileImageUrl = await uploadImageToFirebaseStorage(widget.profileImage!, widget.number!, context, 'Profile Image');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error uploading images: $e');
//       }
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }
//
//   Future<void> uploadUserData() async {
//     try {
//       Map<String, dynamic> userData = {
//         'id': '${widget.number}',
//             'name': '${widget.name}',
//             'address': '${widget.address}',
//             'profileImage': profileImageUrl ??'',
//             'panNo': _panNo!,
//             'panImage': panImageUrl ?? '',
//             'aadhaarNo': _aadhaarNo!,
//             'aadhaarFrontImage': aadhaarFrontImageUrl ?? '',
//             'aadhaarBackImage': aadhaarBackImageUrl ?? '',
//             'city': '${widget.city}',
//             'state': '${widget.state}',
//       };
//
//       await uploadDataToFirebase(collectionName: 'Delivery Users',number:widget.number,name:'User Info', data: userData);
//     } catch (e) {
//       print('Error uploading user data: $e');
//     }
//   }
//   Future<void> _handleFormSubmit() async {
//     if (_formKey.currentState!.validate()) {
//       // Unfocus all text fields to dismiss the keyboard
//       FocusScope.of(context).unfocus();
//
//       _formKey.currentState!.save();
//
//       if (aadhaarValidate(_aadhaarNo!) && panValidate(_panNo!)) {
//         setState(() {
//           _isLoading = true;
//         });
//
//         try {
//           await _uploadImages();
//           // _storeUserData();
//           uploadUserData();
//           if (mounted) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const BnbIndex()),
//             );
//           }
//         } catch (e) {
//           if (kDebugMode) {
//             print('Error uploading images: $e');
//           }
//         } finally {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _validateForm() {
//     setState(() {
//       _isValid = _formKey.currentState?.validate() ?? false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: m,
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_outlined,
//           ),
//         ),
//         title: const Text('Aadhaar Pan Details'),
//       ),
//       body:
//           // gContainer(
//           //     context,
//           SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//         scrollDirection: Axis.vertical,
//         child: Form(
//           key: _formKey,
//           onChanged: _validateForm,
//           child: Column(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   aadhaarPanTextField(
//                     context,
//                     onChanged: (value) => _validateForm(),
//                     keyboardType: TextInputType.text,
//                     onSaved: (value) => _panNo = value,
//                     labelText: 'PAN No.',
//                     hintText: 'ABCDE1234F',
//                     validator: (value) {
//                       if (!panValidate(value!)) {
//                         return 'Invalid PAN Number';
//                       }
//                       return null;
//                     },
//                   ),
//                   Gap.h(30),
//                   _imageUploadWidget(
//                     context,
//                     hintText: 'Upload PAN image',
//                     selectedImage: selectedPanImage,
//                     onSelectImage: (image) {
//                       setState(() {
//                         selectedPanImage = image;
//                       });
//                     },
//                   ),
//                   Gap.h(20),
//                 ],
//               ),
//               column(context),
//               Gap.h(20),
//               // Align(
//               //   alignment: Alignment.center,
//               //   child: selectedPanImage != null &&
//               //           selectedAadhaarBackImage != null &&
//               //           selectedAadhaarFrontImage != null
//               //       ? ElevatedButton(
//               //           onPressed: _uploadImages,
//               //           child: _isUploading
//               //               ? const SizedBox(
//               //                   width: 24,
//               //                   height: 24,
//               //                   child: CircularProgressIndicator(
//               //                     valueColor: AlwaysStoppedAnimation<Color>(
//               //                         Colors.white),
//               //                     strokeWidth: 2.0,
//               //                   ),
//               //                 )
//               //               : const Text("Upload Images"),
//               //         )
//               //       : null,
//               // ),
//               // Gap.h(50),
//               // myButton(
//               //   text: 'Submit',
//               //   onPressed:
//               //       _isLoading || !_isValid ? null : _handleFormSubmit,
//               //   isLoading: _isLoading,
//               //   isValid: _isValid,
//               // ),
//             ],
//           ),
//         ),
//       ),
//       // ),
//       bottomNavigationBar:
//           buildBottomButton( context,textTheme, 'Submit', _isLoading, () {_handleFormSubmit();
//         remove(context, const BnbIndex());
//       }),
//     );
//   }
//
//

//

import 'dart:io';
import 'package:delivery/Widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Function/Firebase/upload_data.dart';
import '../../../../Function/Firebase/upload_image.dart';
import '../../../../Function/Image Picker Options/image_picker_Options.dart';
import '../../../../Utils/Global/global.dart';
import '../../../../Utils/utils.dart';
import '../../../Bnb Index/bnb_index.dart';



class AadhaarPanDetails extends StatefulWidget {
  final String? gender, name, dob, email, address, city, state, country, number;
  final XFile? profileImage;
  const AadhaarPanDetails({
    super.key,
    this.name,
    this.dob,
    this.email,
    this.profileImage,
    this.address,
    this.city,
    this.state,
    this.country,
    this.number,
    this.gender,
  });

  @override
  State<AadhaarPanDetails> createState() => _AadhaarPanDetailsState();
}

class _AadhaarPanDetailsState extends State<AadhaarPanDetails> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _afocusNode = FocusNode();
  final FocusNode _pfocusNode = FocusNode();

  String? _aadhaarNo, _panNo;
  final bool _isValid = false;
  bool _isLoading = false;
  bool _isUploading = false;
  XFile? selectedPanImage;
  XFile? selectedAadhaarFrontImage;
  XFile? selectedAadhaarBackImage;

  String? panImageUrl, profileImageUrl;
  String? aadhaarFrontImageUrl;
  String? aadhaarBackImageUrl;

  @override
  void initState() {
    super.initState();
  }

 

  bool panValidate(String value) {
    String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  RegExp aadhaarRegExp = RegExp(r'^[0-9]{12}$');

  bool aadhaarValidate(String value) {
    return aadhaarRegExp.hasMatch(value);
  }

  Future<void> _uploadImages() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (selectedPanImage != null) {
        panImageUrl = await uploadImageToFirebaseStorage(
            selectedPanImage!, '${widget.number}', context, 'PAN Image');
      }
      if (selectedAadhaarFrontImage != null) {
        aadhaarFrontImageUrl = await uploadImageToFirebaseStorage(
            selectedAadhaarFrontImage!,
            '${widget.number}',
            context,
            'Aadhaar Image');
      }
      if (selectedAadhaarBackImage != null) {
        aadhaarBackImageUrl = await uploadImageToFirebaseStorage(
            selectedAadhaarBackImage!,
            '${widget.number}',
            context,
            'Aadhaar Image');
      }
      if (widget.profileImage != null) {
        profileImageUrl = await uploadImageToFirebaseStorage(
            widget.profileImage!, widget.number!, context, 'Profile Image');
      }
    } catch (e) {
      print('Error uploading images: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> uploadUserData() async {
    try {
      Map<String, dynamic> userData = {
        'id': '${widget.number}',
        'name': '${widget.name}',
        'address': '${widget.address}',
        'profileImage': profileImageUrl ?? '',
        'panNo': _panNo!,
        'panImage': panImageUrl ?? '',
        'aadhaarNo': _aadhaarNo!,
        'aadhaarImages': [aadhaarFrontImageUrl, aadhaarBackImageUrl],
        'dob': '${widget.dob}',
        'email': '${widget.email}',
        'gender': '${widget.gender}',
        'state': '${widget.state}',
        'country': '${widget.country}',
        'city': '${widget.city}'
      };
      await uploadDataToFirebase(
        collectionName: 'Delivery User',
        number: '${widget.number}',
        name: 'User Info',
        sName: 'Profile',
        data: userData,
      );
    } catch (e) {
      print('Error uploading user data: $e');
    }
  }

  Future<void> _handleFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Unfocus all text fields to dismiss the keyboard
      FocusScope.of(context).unfocus();

      _formKey.currentState!.save();

      if (aadhaarValidate(_aadhaarNo!) && panValidate(_panNo!)) {
        setState(() {
          _isLoading = true;
        });

        try {
          await _uploadImages();
          await uploadUserData();
          if (mounted) {
            remove(context, const BnbIndex());
          }
        } catch (e) {
          print('Error uploading images or data: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
@override
  void dispose() {
    _afocusNode.dispose();
    _pfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: m,
      appBar: AppBar(
        title: const Text('Aadhaar & PAN Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    aadhaarPanTextField(
                      context,
                      focusNode: _pfocusNode,
                      onChanged: (value) => panValidate(value),
                      keyboardType: TextInputType.text,
                      onSaved: (value) => _panNo = value,
                      labelText: 'PAN No.',
                      hintText: 'ABCDE1234F',
                      validator: (value) {
                        if (!panValidate(value!)) {
                          return 'Invalid PAN Number';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ]
                    ),
                    Gap.h(30),
                    _imageUploadWidget(
                      context,
                      hintText: 'Upload PAN image',
                      selectedImage: selectedPanImage,
                      onSelectImage: (image) {
                        setState(() {
                          selectedPanImage = image;
                        });
                      },
                    ),
                    Gap.h(20),
                  ],
                ),
                column(context),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     labelText: 'Aadhaar Number',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your Aadhaar number';
                //     } else if (!aadhaarValidate(value)) {
                //       return 'Please enter a valid Aadhaar number';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     _aadhaarNo = value;
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     labelText: 'PAN Number',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your PAN number';
                //     } else if (!panValidate(value)) {
                //       return 'Please enter a valid PAN number';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     _panNo = value;
                //   },
                // ),
                // const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: _handleFormSubmit,
                //   child: const Text('Submit'),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomButton(
          context, textTheme, 'Submit', _isLoading, () => _handleFormSubmit()),
    );
  }

  Column column(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        aadhaarPanTextField(
          focusNode: _afocusNode,
          inputFormatters: [LengthLimitingTextInputFormatter(12),
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          context,
          onSaved: (value) => _aadhaarNo = value,
          labelText: 'Aadhaar No.',
          hintText: '1234 5678 9012',
          validator: (value) {
            if (!aadhaarValidate(value!)) {
              return 'Invalid Aadhaar Number';
            }
            return null;
          },
          onChanged: (value) => aadhaarValidate(value),
        ),
        Gap.h(8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              TextSpan(
                text: ' As per your Aadhaar Card',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        Gap.h(30),
        _imageUploadWidget(
          context,
          hintText: 'Upload Aadhaar front image',
          selectedImage: selectedAadhaarFrontImage,
          onSelectImage: (image) {
            setState(() {
              selectedAadhaarFrontImage = image;
            });
          },
        ),
        Gap.h(20),
        _imageUploadWidget(
          context,
          hintText: 'Upload Aadhaar back image',
          selectedImage: selectedAadhaarBackImage,
          onSelectImage: (image) {
            setState(() {
              selectedAadhaarBackImage = image;
            });
          },
        ),
      ],
    );
  }
}

Widget _imageUploadWidget(
  BuildContext context, {
  required String hintText,
  required XFile? selectedImage,
  required void Function(XFile?) onSelectImage,
}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () async {
        final XFile? pickedImage = await showImagePickOption(context);
        if (pickedImage != null) {
          onSelectImage(pickedImage);
        }
      },
      child: Column(
        children: [
          DottedBorder(
            color: Colors.white,
            strokeWidth: 2,
            dashPattern: const [7, 5],
            borderType: BorderType.RRect,
            child: Container(
              color: Colors.white24,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 8,
              height: 150,
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: selectedImage != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(selectedImage.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * .72,
                            height: 120,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onSelectImage(null);
                          },
                          icon: const Icon(
                            Icons.close_sharp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/images/uploadIcon.png",
                          ),
                          backgroundColor: Colors.grey,
                        ),
                        Text(
                          hintText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black54),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget aadhaarPanTextField(BuildContext context,

    {required void Function(String?) onSaved,
      FocusNode? focusNode,
    required String labelText,
    required String hintText,
    required String? Function(String?)? validator,
    required TextInputType keyboardType,
    required Function(dynamic value) onChanged,
    List<TextInputFormatter>? inputFormatters}) {
  return TextFormField(
    focusNode:focusNode,
    textCapitalization:TextCapitalization.characters,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    keyboardType: keyboardType,
    onSaved: onSaved,
    validator: validator,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      overflow: TextOverflow.fade,
    ),
    decoration: InputDecoration(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white60),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.white60),
      floatingLabelStyle: const TextStyle(color: Colors.white),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white60),
    ),
  );
}

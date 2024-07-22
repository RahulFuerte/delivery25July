import 'package:delivery/Screens/Registeration%20Screens/User%20Info/Address%20Info/manual_address.dart';
import 'package:delivery/Utils/utils.dart';
import 'package:delivery/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Utils/Global/global.dart';

class BothAddress extends StatefulWidget {
  final String number,name,dob,email,gender;
  final XFile? profileImage;
  const BothAddress({super.key,
    required this.number, required this.name, required this.dob, required this.email, this.profileImage,  required this.gender
  });

  @override
  State<BothAddress> createState() => _BothAddressState();
}

class _BothAddressState extends State<BothAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: m,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            textFormField(context:context,labelText: 'Search',pIcon: const Icon(Icons.search,color: Colors.white70,)),
            Gap.h(20),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                Gap.w(5),
                Text('Pick your Address form Current Location',style: textTheme.bodyMedium?.copyWith(color: Colors.white70),)
              ],
            ),
            Gap.h(10),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => push(context, ManualAddressPage(profileImageUrl: widget.profileImage,name: widget.name,number: widget.number,dob: widget.dob,
              email: widget.email,gender: widget.gender,)),
              child: Row(
                children: [
                  const Icon(Icons.add),
                  Gap.w(5),
                  Text('Enter your address manually',style:textTheme.bodyMedium?.copyWith(color: Colors.white70) ,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

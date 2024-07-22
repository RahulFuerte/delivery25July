import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/utils.dart';

Future<XFile?> showImagePickOption(BuildContext context) async {
  return await showModalBottomSheet<XFile?>(
    context: context,
    builder: (builder) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera,imageQuality: 25);
                  if (image != null) {
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to pick image from camera!'),
                            duration: Duration(seconds: 5)),
                      );
                    }
                  }
                },
                child: const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 50,
                        color: m,
                      ),
                      Text("Camera"),
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(color: Colors.black),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);
                  if (image != null) {
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to pick image from gallery!'),
                            duration: Duration(seconds: 2)),
                      );
                    }
                  }
                },
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 50,
                        color: m,
                      ),
                      Text("Gallery")
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

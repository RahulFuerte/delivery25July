import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/Global/global.dart';

Widget buildBottomButton(BuildContext context,TextTheme textTheme, String text,
    bool isLoading, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      child: isLoading
          ? const SizedBox(
        height: 30,
        width: 30,

            child: CircularProgressIndicator(
                    // value: 4?,
            strokeWidth:2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
          )
          : Text(text),
    ),
  );
}

Widget textFormField({
  required BuildContext context,
  required String labelText,
  FocusNode? focusNode,
void Function()? onTap,
  String? hintText,
  TextEditingController? controller,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  void Function(String?)? onSaved,
  Widget? sIcon,
  Widget? pIcon,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  bool readOnly = false,  bool? enabled,
}) {
  return TextFormField(
    enabled: enabled,
    onTap: onTap,
    cursorColor: Colors.white,
    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
    focusNode: focusNode,
    textCapitalization: TextCapitalization.words,
    onSaved: onSaved,
    controller: controller,
    readOnly: readOnly,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: sIcon,
        prefixIcon: pIcon),
  );
}

import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  required Color color,
  required String text,
  required void Function() function,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: function,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
    );

Widget defaultTextFormField({

  required TextEditingController controller,
  required TextInputType keyboardType,
  required String labelText,
  required IconData prefixIcon,
  required FormFieldValidator<String> validate,
  IconData? suffixIcon,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool isPassword = false,
  double radius =10.0,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      onChanged: onChanged,
      onTap: onTap,
      validator: validate,
      onFieldSubmitted: onSubmitted,
    );

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constant_colors.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final GestureTapCallback? onTap;
  final String? Function(String?)? validation;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final bool isNumberField;
  final bool isReadOnly;
  final String? icon;
  final String? initialValue;
  final double paddingHorizontal;
  final double marginBottom;
  final List<TextInputFormatter>? formatters;
  final TextEditingController? controller;
  final TextDirection? textDirection;
  Iterable<String>? autofillHints;

  CustomInput(
      {super.key,
      required this.hintText,
      this.onChanged,
      this.onTap,
      this.textInputAction = TextInputAction.next,
      this.isPasswordField = false,
      this.focusNode,
      this.isNumberField = false,
      this.isReadOnly = false,
      this.controller,
      this.validation,
      this.icon,
      this.initialValue,
      this.paddingHorizontal = 8.0,
      this.formatters,
      this.autofillHints,
      this.textDirection,
      this.marginBottom = 19});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        decoration: BoxDecoration(
            // color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType:
              isNumberField ? TextInputType.number : TextInputType.text,
          focusNode: focusNode,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: isReadOnly,
          validator: validation,          
          textInputAction: textInputAction,
          textDirection: textDirection,
          inputFormatters: formatters ?? [],
          obscureText: isPasswordField,
          autofillHints: autofillHints,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 22.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(icon!),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                      ],
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().greyFive),
                  borderRadius: BorderRadius.circular(9)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().primaryColor)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().warningColor)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ConstantColors().primaryColor)),
              hintText: hintText,
              hintTextDirection: textDirection,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: 18)),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:qixer_seller/utils/constant_colors.dart';

class TextareaField extends StatelessWidget {
  const TextareaField(
      {Key? key, required this.notesController, required this.hintText})
      : super(key: key);
  final notesController;
  final hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: notesController,
        maxLines: 6,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18)));
  }
}

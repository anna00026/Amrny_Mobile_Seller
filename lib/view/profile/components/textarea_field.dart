import 'package:flutter/material.dart';
import 'package:amrny_seller/utils/constant_colors.dart';

class TextareaField extends StatefulWidget {
  const TextareaField({
    Key? key,
    this.notesController,
    required this.hintText,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final TextEditingController? notesController;
  final String hintText;
  final String? value;
  final Function(String)? onChanged;

  @override
  TextareaFieldState createState() => TextareaFieldState();
}

class TextareaFieldState extends State<TextareaField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Use the provided controller or create a new one
    _controller = widget.notesController ?? TextEditingController();
    // Set the initial text if provided
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    // Dispose the controller if it was created here
    if (widget.notesController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: 6,
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors().greyFive),
          borderRadius: BorderRadius.circular(9),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors().primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors().warningColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ConstantColors().primaryColor),
        ),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      ),
    );
  }
}

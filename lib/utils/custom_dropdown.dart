import 'package:flutter/material.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';

class CustomDropdown extends StatelessWidget {
  String hintText;
  List listData;
  String? value;
  void Function(dynamic)? onChanged;
  CustomDropdown(this.hintText, this.listData, this.onChanged,
      {this.value, Key? key})
      : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: cc.borderColor,
          width: 1,
        ),
      ),
      child: DropdownButton(
        hint: Text(
          hintText,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: cc.greyParagraph,
                fontSize: 14,
              ),
        ),
        underline: Container(),
        isExpanded: true,
        elevation: 0,
        isDense: true,
        value: value,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: cc.greyParagraph,
              fontSize: 14,
            ),
        icon: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: cc.greyParagraph,
        ),
        onChanged: onChanged,
        items: (listData).map((value) {
          return DropdownMenuItem(
            alignment: rtlProvider.direction == 'left'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            value: value,
            child: SizedBox(
              // width: screenWidth - 140,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child:
                    Text(asProvider.getString(value).toString().capitalize()),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

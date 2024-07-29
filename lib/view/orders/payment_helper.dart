import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/responsive.dart';

class PaymentHelper {
  ConstantColors cc = ConstantColors();

  bRow(String icon, String title, String text, {bool lastBorder = true}) {
    return Column(
      children: [
        Row(
          children: [
            //icon
            SizedBox(
              width: 125,
              child: Row(children: [
                icon != 'null'
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            icon,
                            height: 19,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                        ],
                      )
                    : Container(),
                Flexible(
                  child: Text(
                    asProvider.getString(title),
                    style: TextStyle(
                      color: cc.greyFour,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ]),
            ),

            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        lastBorder == true
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                child: CommonHelper().dividerCommon(),
              )
            : Container()
      ],
    );
  }

  detailsPanelRow(String title, int quantity, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        quantity != 0
            ? Expanded(
                flex: 1,
                child: Text(
                  'x$quantity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ))
            : Container(),
        Consumer<RtlService>(
          builder: (context, rtlP, child) => Expanded(
            flex: 1,
            child: Text(
              rtlP.currencyDirection == 'left'
                  ? "${rtlP.currency}$price"
                  : "$price${rtlP.currency}",
              textAlign:
                  rtlP.direction == 'ltr' ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  colorCapsule(String title, String capsuleText, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
          decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            capsuleText,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        )
      ],
    );
  }
}

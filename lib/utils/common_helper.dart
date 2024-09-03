import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';

import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';

class CommonHelper {
  ConstantColors cc = ConstantColors();
  //common appbar
  appbarCommon(String title, BuildContext context, VoidCallback pressed,
      {actions}) {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: cc.greyPrimary),
      title: Consumer<AppStringService>(
        builder: (context, ln, child) => Text(
          ln.getString(title),
          style: TextStyle(
              color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: pressed,
        child: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
      ),
      actions: actions,
    );
  }

  //common orange button =======>
  buttonPrimary(String title, VoidCallback pressed,
      {isloading = false, bgColor, double paddingVertical = 18}) {
    return InkWell(
      onTap: pressed,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: paddingVertical),
          decoration: BoxDecoration(
              color: bgColor ?? cc.primaryColor,
              borderRadius: BorderRadius.circular(8)),
          child: isloading == false
              ? Text(
                  asProvider.getString(title),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              : OthersHelper().showLoading(Colors.white)),
    );
  }

  borderButtonPrimary(String title, VoidCallback pressed) {
    return InkWell(
      onTap: pressed,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
              border: Border.all(color: cc.primaryColor),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            asProvider.getString(title),
            style: TextStyle(
              color: cc.primaryColor,
              fontSize: 14,
            ),
          )),
    );
  }

  labelCommon(String title,
      {double lineHeight = 1.3, double marginBotton = 15}) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBotton),
      child: Text(
        asProvider.getString(title),
        style: TextStyle(
          color: cc.greyThree,
          fontSize: 14,
          height: lineHeight,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  paragraphCommon(String title, TextAlign textAlign,
      {color,
      double fontsize = 14,
      fontweight = FontWeight.w400,
      double lineHeight = 1.4}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          asProvider.getString(title),
          textAlign: textAlign,
          style: TextStyle(
            color: color ?? cc.greyParagraph,
            height: lineHeight,
            fontSize: fontsize,
            fontWeight: fontweight,
          ),
        )
      ],
    );
  }

  titleCommon(String title, {double fontsize = 18, lineheight = 1.5, color}) {
    return Text(
      asProvider.getString(title),
      style: TextStyle(
          color: color ?? cc.greyPrimary,
          fontSize: fontsize,
          height: lineheight,
          fontWeight: FontWeight.bold),
    );
  }

  dividerCommon() {
    return Divider(
      thickness: 1,
      height: 2,
      color: cc.borderColor,
    );
  }

  checkCircle() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: const Icon(
        Icons.check,
        size: 13,
        color: Colors.white,
      ),
      decoration: BoxDecoration(shape: BoxShape.circle, color: cc.primaryColor),
    );
  }

  profileImage(String imageLink, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: imageLink,
        placeholder: (context, url) {
          return Image.asset('assets/images/loading_image.png');
        },
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/icon.png',
            color: Colors.white.withOpacity(.5),
            colorBlendMode: BlendMode.overlay,
          ),
        )),
      ),
    );
  }

  //no order found
  nothingfound(BuildContext context, String title) {
    return Container(
        height: MediaQuery.of(context).size.height - 120,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 26,
              color: cc.greyFour,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              title,
              style: TextStyle(color: cc.greyFour),
            ),
          ],
        ));
  }
}

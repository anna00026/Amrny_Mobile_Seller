import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/rtl_service.dart';

import '../services/app_string_service.dart';

late bool isIos;
late AppStringService asProvider;
late RtlService rtlProvider;
var _chatBuyerId;

setChatBuyerId(value) {
  _chatBuyerId = value;
}

String? get chatBuyerId {
  return _chatBuyerId?.toString();
}

// late double screenWidth;
// late double screenHeight;

// getScreenSize(BuildContext context) {
//   screenWidth = MediaQuery.of(context).size.width;
//   screenHeight = MediaQuery.of(context).size.height;
// }

screenSizeAndPlatform(BuildContext context) {
  // getScreenSize(context);
  checkPlatform();
}
//responsive screen codes ========>

var fourinchScreenHeight = 610;
var fourinchScreenWidth = 385;

checkPlatform() {
  if (Platform.isAndroid) {
    isIos = false;
  } else if (Platform.isIOS) {
    isIos = true;
  }
}

initializeLNProvider(BuildContext context) {
  asProvider = Provider.of<AppStringService>(context, listen: false);
  rtlProvider = Provider.of<RtlService>(context, listen: false);
}

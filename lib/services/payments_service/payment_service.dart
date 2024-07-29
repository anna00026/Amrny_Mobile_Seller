// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';

class PaymentService with ChangeNotifier {
  bool isloading = false;

  var orderId;
  var successUrl;
  var cancelUrl;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  bool depositeFromCurrent = false;

  setDepositeFromCurrent(bool status) {
    depositeFromCurrent = status;
    notifyListeners();
  }
}

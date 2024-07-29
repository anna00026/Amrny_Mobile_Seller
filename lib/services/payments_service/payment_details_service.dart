// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';

class PaymentDetailsService with ChangeNotifier {
  var selectedPayment;

  var totalAmount;

  setSelectedPayment(newPayment) {
    selectedPayment = newPayment;
    notifyListeners();
  }

  setTotalAmount(newAmount) {
    totalAmount = newAmount;
    notifyListeners();
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/view/payments/paytm_payment.dart';

class PaytmService {
  payByPaytm(BuildContext context,
      {bool reniewSubscription = false, bool isFromWalletDeposite = false}) {
    //========>
    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    var amount;

    if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;
    }

    //paytm not implemented neither for place order nor extra accept,

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaytmPayment(
          isFromWalletDeposite: isFromWalletDeposite,
          reniewSubscription: reniewSubscription,
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_gateway_list_service.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/view/payments/zitopay_payment_page.dart';

class ZitopayService {
  payByZitopay(BuildContext context,
      {bool isFromWalletDeposite = false, bool reniewSubscription = false}) {
    //========>
    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    var amount;

    if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;
    } else if (reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();
    }
    var userName =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .zitopayUserName;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ZitopayPaymentPage(
            amount: amount,
            userName: userName,
            isFromWalletDeposite: isFromWalletDeposite,
            reniewSubscription: reniewSubscription),
      ),
    );
  }
}

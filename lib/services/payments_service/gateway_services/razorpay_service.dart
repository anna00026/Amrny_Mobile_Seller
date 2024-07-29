// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/view/payments/razorpay_payment_page.dart';

class RazorpayService {
  payByRazorpay(BuildContext context,
      {bool reniewSubscription = false, bool isFromWalletDeposite = false}) {
    //========>
    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    var amount;

    String name;
    String phone;
    String email;

    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .name ??
        'test';
    phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .phone ??
        '111111111';
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .email ??
        'test@test.com';
    if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;
      amount = double.parse(amount).toStringAsFixed(1);
    } else if (reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();
      amount = double.parse(amount).toStringAsFixed(1);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => RazorpayPaymentPage(
            amount: amount,
            name: name,
            phone: phone,
            email: email,
            isFromWalletDeposite: isFromWalletDeposite,
            reniewSubscription: reniewSubscription),
      ),
    );
  }
}

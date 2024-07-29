// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/view/payments/cinetpay_payment.dart';

class CinetPayService {
  payByCinetpay(BuildContext context,
      {bool isFromWalletDeposite = false, bool reniewSubscription = false}) {
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
    } else if (reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CinetPayPayment(
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

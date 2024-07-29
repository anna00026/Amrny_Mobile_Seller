// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/view/payments/mollie_payment.dart';

class MollieService {
  payByMollie(BuildContext context,
      {bool reniewSubscription = false, bool isFromWalletDeposite = false}) {
    var amount;

    String name;
    String phone;
    String email;
    var orderId;

    Provider.of<PaymentService>(context, listen: false).setLoadingTrue();

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
      amount = double.parse(amount).toStringAsFixed(2);

      orderId = 'wallet' +
          Provider.of<WalletService>(context, listen: false)
              .walletHistoryId
              .toString();
    } else if (reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();
      amount = double.parse(amount).toStringAsFixed(2);
      orderId = "subs" "${DateTime.now().hour}" "${DateTime.now().year}";
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MolliePayment(
          amount: amount,
          name: name,
          phone: phone,
          email: email,
          orderId: orderId,
          isFromWalletDeposite: isFromWalletDeposite,
          reniewSubscription: reniewSubscription,
        ),
      ),
    );
  }
}

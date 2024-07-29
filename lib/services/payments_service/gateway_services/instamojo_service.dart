import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/view/payments/instamojo_payment_page.dart';

class InstamojoService {
  payByInstamojo(BuildContext context,
      {bool isFromWalletDeposite = false, bool reniewSubscription = false}) {
    String amount = '';

    String name;
    String email;

    name = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .name ??
        'test';

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
        builder: (BuildContext context) => InstamojoPaymentPage(
            amount: amount,
            name: name,
            email: email,
            isFromWalletDeposite: isFromWalletDeposite,
            reniewSubscription: reniewSubscription),
      ),
    );
  }
}

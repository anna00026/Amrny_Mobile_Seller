import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_gateway_list_service.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/others_helper.dart';
import '../../rtl_service.dart';

class FlutterwaveService {
  // String phone = '35435413513513';
  // String email = 'test@test.com';

  String currency = 'USD';
  // String amount = '200';

  payByFlutterwave(BuildContext context,
      {bool reniewSubscription = false, bool isFromWalletDeposite = false}) {
    _handlePaymentInitialization(
        context, reniewSubscription, isFromWalletDeposite);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => const FlutterwavePaymentPage(),
    //   ),
    // );
  }

  _handlePaymentInitialization(
      BuildContext context, reniewSubscription, isFromWalletDeposite) async {
    final rtlProvider = Provider.of<RtlService>(context, listen: false);
    String amount = '';

    String name;
    String phone;
    String email;

    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

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

    // String publicKey = 'FLWPUBK_TEST-86cce2ec43c63e09a517290a8347fcab-X';
    String publicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .publicKey ??
            '';

    // final style = FlutterwaveStyle(
    //   appBarText: "Flutterwave payment",
    //   buttonColor: Colors.blue,
    //   buttonTextStyle: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 16,
    //   ),
    //   appBarColor: Colors.blue,
    //   dialogCancelTextStyle: const TextStyle(
    //     color: Colors.grey,
    //     fontSize: 17,
    //   ),
    //   dialogContinueTextStyle: const TextStyle(
    //     color: Colors.blue,
    //     fontSize: 17,
    //   ),
    //   mainBackgroundColor: Colors.white,
    //   mainTextStyle:
    //       const TextStyle(color: Colors.black, fontSize: 17, letterSpacing: 2),
    //   dialogBackgroundColor: Colors.white,
    //   appBarIcon: const Icon(Icons.arrow_back, color: Colors.white),
    //   buttonText: "Pay ${rtlProvider.currency}$amount",
    //   appBarTitleTextStyle: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 18,
    //   ),
    // );

    final Customer customer =
        Customer(name: "FLW Developer", phoneNumber: phone, email: email);

    final subAccounts = [
      SubAccount(
          id: "RS_1A3278129B808CB588B53A14608169AD",
          transactionChargeType: "flat",
          transactionPercentage: 25),
      SubAccount(
          id: "RS_C7C265B8E4B16C2D472475D7F9F4426A",
          transactionChargeType: "flat",
          transactionPercentage: 50)
    ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        // style: style,
        publicKey: publicKey,
        currency: rtlProvider.currency,
        txRef: const Uuid().v1(),
        amount: amount,
        customer: customer,
        subAccounts: subAccounts,
        paymentOptions: "card, payattitude",
        customization: Customization(title: "Test Payment"),
        redirectUrl: "https://www.google.com",
        isTestMode: false);
    var response = await flutterwave.charge();

    if (response.success != false) {
      showLoading(response.status!, context);
      print('flutterwave payment successfull');
      if (isFromWalletDeposite) {
        Provider.of<WalletService>(context, listen: false)
            .makeDepositeToWalletSuccess(context);
      } else if (reniewSubscription) {
        Provider.of<SubscriptionService>(context, listen: false)
            .reniewSubscription(
          context,
        );
      }
      // print("${response.toJson()}");
    } else {
      inFailed(context);
      //User cancelled the payment
      // showLoading("No Response!");
    }
  }

  Future<void> showLoading(String message, context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}

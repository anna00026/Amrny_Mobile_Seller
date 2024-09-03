import 'dart:convert';

// import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/payments_service/payment_gateway_list_service.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/utils/others_helper.dart';

import '../../rtl_service.dart';

class CashfreeService {
  getTokenAndPay(BuildContext context,
      {bool reniewSubscription = false,
      bool isFromWalletDeposite = false}) async {
    //========>

    String amount = '';

    String name;
    String phone;
    String email;
    String orderId = '';
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

      orderId = 'wallet' +
          Provider.of<WalletService>(context, listen: false)
              .walletHistoryId
              .toString();
    } else if (reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();
      orderId = "subs" "${DateTime.now().day}" "${DateTime.now().year}";
    }

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      'x-client-id':
          Provider.of<PaymentGatewayListService>(context, listen: false)
              .publicKey
              .toString(),
      'x-client-secret':
          Provider.of<PaymentGatewayListService>(context, listen: false)
              .secretKey
              .toString(),
      "Content-Type": "application/json"
    };

    String orderCurrency =
        Provider.of<RtlService>(context, listen: false).currencyCode;
    var data = jsonEncode({
      'orderId': orderId,
      'orderAmount': amount,
      'orderCurrency': orderCurrency
    });

    var response = await http.post(
      Uri.parse(
          'https://test.cashfree.com/api/v2/cftoken/order'), // change url to https://api.cashfree.com/api/v2/cftoken/order when in production
      body: data,
      headers: header,
    );
    print(response.body);

    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    if (jsonDecode(response.body)['status'] == "OK") {
      cashFreePay(
          jsonDecode(response.body)['cftoken'],
          orderId,
          orderCurrency,
          context,
          amount,
          name,
          phone,
          email,
          reniewSubscription,
          isFromWalletDeposite);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
    // if()
  }

  cashFreePay(token, orderId, orderCurrency, BuildContext context, amount, name,
      phone, email, reniewSubscription, isFromWalletDeposite) {
    //Replace with actual values
    //has to be unique every time
    String stage = "TEST"; // PROD when in production mode// TEST when in test

    String tokenData = token; //generate token data from server

    String appId = "94527832f47d6e74fa6ca5e3c72549";

    String notifyUrl = "";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": amount,
      "customerName": name,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": phone,
      "customerEmail": email,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    // CashfreePGSDK.doPayment(
    //   inputParams,
    // ).then((value) {
    //   print('cashfree payment result $value');
    //   if (value != null) {
    //     if (value['txStatus'] == "SUCCESS") {
    //       print('Cashfree Payment successfull. Do something here');

    //       if (isFromWalletDeposite) {
    //         Provider.of<WalletService>(context, listen: false)
    //             .makeDepositeToWalletSuccess(context);
    //       } else if (reniewSubscription) {
    //         Provider.of<SubscriptionService>(context, listen: false)
    //             .reniewSubscription(
    //           context,
    //         );
    //       }
    //     } else {
    //       inFailed(context);
    //     }
    //   }
    // });
  }
}

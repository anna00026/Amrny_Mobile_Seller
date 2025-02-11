// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/others_helper.dart';

class PayfastPayment extends StatelessWidget {
  PayfastPayment(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      required this.isFromWalletDeposite,
      required this.reniewSubscription})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;
  final isFromWalletDeposite;
  final reniewSubscription;

  String? url;
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 600), () {
      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payfast'),
        leading: InkWell(
          onTap: () {
            showPaymentWarning(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          showPaymentWarning(context);
          return Future.value(false);
        },
        child: FutureBuilder(
            future: waitForIt(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                inFailed(context);
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              if (snapshot.hasError) {
                inFailed(context);
                print(snapshot.error);
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              return WebView(
                onWebResourceError: (error) {
                  inFailed(context);
                },
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (value) async {
                  if (value.contains('finish')) {
                    bool paySuccess = await verifyPayment(value);
                    if (paySuccess) {
                      if (isFromWalletDeposite) {
                        await Provider.of<WalletService>(context, listen: false)
                            .makeDepositeToWalletSuccess(context);
                      } else if (reniewSubscription) {
                        Provider.of<SubscriptionService>(context, listen: false)
                            .reniewSubscription(
                          context,
                        );
                      }
                      return;
                    }
                    inFailed(context);
                  }
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) {
    final merchantId =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .publicKey;

    final merchantKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .secretKey;
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    // final merchantId = '10024000';

    // final merchantKey = '77jcu5v4ufdod';

    url =
        'https://sandbox.payfast.co.za/eng/process?merchant_id=$merchantId&merchant_key=$merchantKey&amount=$amount&currency=$currencyCode&item_name=GrenmartGroceries';
    //   return;
    // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}

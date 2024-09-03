// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/others_helper.dart';

class MolliePayment extends StatelessWidget {
  MolliePayment(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      required this.orderId,
      required this.isFromWalletDeposite,
      required this.reniewSubscription})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;
  final isFromWalletDeposite;
  final reniewSubscription;
  final orderId;

  String? url;
  String? statusURl;
  @override
  Widget build(BuildContext context) {
    var successUrl =
        Provider.of<PaymentService>(context, listen: false).successUrl ??
            'https://www.google.com/';

    Future.delayed(const Duration(microseconds: 600), () {
      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mollie'),
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
            future: waitForIt(context, successUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (value) async {
                  var redirectUrl = successUrl;

                  if (value.contains(redirectUrl)) {
                    String status = await verifyPayment(context);
                    if (status == 'paid') {
                      if (isFromWalletDeposite) {
                        Provider.of<WalletService>(context, listen: false)
                            .makeDepositeToWalletSuccess(context);
                      } else if (reniewSubscription) {
                        Provider.of<SubscriptionService>(context, listen: false)
                            .reniewSubscription(
                          context,
                        );
                      }
                    }
                    if (status == 'open') {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text(
                                  asProvider.getString('Payment cancelled!')),
                              content: Text(asProvider
                                  .getString('Payment has been cancelled.')),
                            );
                          });
                    }
                    if (status == 'failed') {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title:
                                  Text(asProvider.getString('Payment failed!')),
                            );
                          });
                    }
                    if (status == 'expired') {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title:
                                  Text(asProvider.getString('Payment failed!')),
                              content: Text(asProvider
                                  .getString('Payment has been expired.')),
                            );
                          });
                    }
                  }
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context, successUrl) async {
    final publicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .publicKey;

    // final publicKey = 'test_fVk76gNbAp6ryrtRjfAVvzjxSHxC2v';

    final url = Uri.parse('https://api.mollie.com/v2/payments');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "amount": {"value": amount, "currency": currencyCode},
          "description": "Amrny payment",
          "redirectUrl": successUrl,
          "webhookUrl": successUrl, "metadata": 'mollieAmrny$orderId',
          // "method": "creditcard",
        }));
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['_links']['checkout']['href'];
      print('url link is ${this.url}');
      statusURl = jsonDecode(response.body)['_links']['self']['href'];
      print(statusURl);
      return;
    } else {
      print(response.body);
    }

    return true;
  }

  verifyPayment(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
            .publicKey;

    // final publicKey = 'test_fVk76gNbAp6ryrtRjfAVvzjxSHxC2v';

    final url = Uri.parse(statusURl as String);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.get(url, headers: header);
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }
}

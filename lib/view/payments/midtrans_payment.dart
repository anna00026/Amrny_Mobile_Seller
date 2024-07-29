// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_gateway_list_service.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../services/rtl_service.dart';
import '../../utils/others_helper.dart';

class MidtransPayment extends StatelessWidget {
  MidtransPayment(
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
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 600), () {
      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Midtrans'),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Loding failed.'),
                );
              }
              return WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (value) async {
                  if (value.contains('success')) {
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
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final url =
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');

    final clientKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .publicKey ??
            '';
    final serverKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .secretKey ??
            '';
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$serverKey:$clientKey'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "transaction_details": {
            "order_id": DateTime.now().toString(),
            "gross_amount": amount,
            'currency': currencyCode
          },
          "credit_card": {"secure": true},
          "customer_details": {
            "first_name": name,
            "email": email,
            "phone": phone,
          }
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['redirect_url'];
      return;
    }

    return true;
  }
}

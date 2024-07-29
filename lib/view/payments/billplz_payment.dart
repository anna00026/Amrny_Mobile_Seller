// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/common_helper.dart';

class BillplzPayment extends StatelessWidget {
  BillplzPayment(
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
      appBar: CommonHelper().appbarCommon('BillPlz', context, () {
        showPaymentWarning(context);
      }),
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
                // onWebViewCreated: ((controller) {
                //   _controller = controller;
                // }),
                onWebResourceError: (error) => inFailed(context),
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (value) async {
                  verifyPayment(
                      value, context, isFromWalletDeposite, reniewSubscription);
                },
              );
            }),
      ),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  waitForIt(BuildContext context) async {
    // String orderId =
    //     Provider.of<PlaceOrderService>(context, listen: false).orderId;

    final url = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
    final username =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .publicKey ??
            '';
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    final collectionName =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .billPlzCollectionName ??
            '';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$username'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "collection_id": collectionName,
          "description": "Qixer payment",
          "email": email,
          "name": name,
          "currency": currencyCode,
          "amount": "${double.parse(amount) * 100}",
          "reference_1_label": "Bank Code",
          "reference_1": "BP-FKR01",
          "callback_url": "http://www.xgenious.com"
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)["url"];
      return;
    }

    return true;
  }
}

Future verifyPayment(String url, BuildContext context, isFromWalletDeposite,
    reniewSubscription) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.body.contains('paid')) {
    if (isFromWalletDeposite) {
      Provider.of<WalletService>(context, listen: false)
          .makeDepositeToWalletSuccess(context);
    } else if (reniewSubscription) {
      Provider.of<SubscriptionService>(context, listen: false)
          .reniewSubscription(
        context,
      );
    }
    return;
  }
  if (response.body.contains('your payment was not')) {
    OthersHelper().showSnackBar(context, 'Payment failed', Colors.red);
    Navigator.pop(context);
    return;
  }
}

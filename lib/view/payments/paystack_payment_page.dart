import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/others_helper.dart';

class PaystackPaymentPage extends StatelessWidget {
  PaystackPaymentPage(
      {Key? key,
      required this.isFromWalletDeposite,
      required this.reniewSubscription})
      : super(key: key);

  String? url;
  final isFromWalletDeposite;
  final reniewSubscription;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 600), () {
      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
    });
    ConstantColors cc = ConstantColors();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paystack'),
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
        child: WillPopScope(
          onWillPop: () async {
            await showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content:
                        const Text('Your payment proccess will be terminated.'),
                    actions: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: cc.primaryColor),
                        ),
                      )
                    ],
                  );
                });
            return false;
          },
          child: FutureBuilder(
              future:
                  waitForIt(context, isFromWalletDeposite, reniewSubscription),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return const Center(
                    child: Text('Loding failed.'),
                  );
                }
                // if (snapshot.hasError) {
                //   print(snapshot.error);
                //   return const Center(
                //     child: Text('Loding failed.'),
                //   );
                // }
                return WebView(
                  // onWebViewCreated: ((controller) {
                  //   _controller = controller;
                  // }),
                  onWebResourceError: (error) => inFailed(context),
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (value) async {
                    // final title = await _controller.currentUrl();
                    // print(title);
                    print('on finished.........................$value');
                    final uri = Uri.parse(value);
                    final response = await http.get(uri);
                    // if (response.body.contains('PAYMENT ID')) {

                    if (response.body.contains('Payment Successful')) {
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
                    if (response.body.contains('Declined')) {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title:
                                  Text(asProvider.getString('Payment failed!')),
                              content: Text(asProvider
                                  .getString('Payment has been cancelled.')),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(color: cc.primaryColor),
                                  ),
                                )
                              ],
                            );
                          });
                    }
                  },
                  navigationDelegate: (navRequest) async {
                    print(
                        'nav req to .......................${navRequest.url}');
                    if (navRequest.url.contains('success')) {
                      if (isFromWalletDeposite) {
                        await Provider.of<WalletService>(context, listen: false)
                            .makeDepositeToWalletSuccess(context);
                      } else if (reniewSubscription) {
                        Provider.of<SubscriptionService>(context, listen: false)
                            .reniewSubscription(
                          context,
                        );
                      }
                      return NavigationDecision.prevent;
                    }
                    if (navRequest.url.contains('failed')) {
                      inFailed(context);
                    }
                    return NavigationDecision.navigate;
                  },

                  // javascriptChannels: <JavascriptChannel>[
                  //   // Set Javascript Channel to WebView
                  //   JavascriptChannel(
                  //       name: 'same',
                  //       onMessageReceived: (javMessage) {
                  //         print(javMessage.message);
                  //         print('...........................................');
                  //       }),
                  // ].toSet(),
                );
              }),
        ),
      ),
    );
  }

  Future<void> waitForIt(
      BuildContext context, isFromWalletDeposite, reniewSubscription) async {
    final uri = Uri.parse('https://api.paystack.co/transaction/initialize');

    String paystackSecretKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .secretKey ??
            '';

    var amount;

    String name;
    String phone;
    String email;
    String orderId = '';
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
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    if (isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;
      amount = double.parse(amount).toStringAsFixed(0);
      amount = int.parse(amount);

      orderId = DateTime.now().toString();
    } else if (reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();

      amount = double.parse(amount).toStringAsFixed(0);
      amount = int.parse(amount);

      orderId = "subs" "${DateTime.now().day}" "${DateTime.now().year}";
    }

    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $paystackSecretKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };

    // final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": amount,
          "currency": currencyCode,
          "email": email,
          "reference_id": orderId.toString(),
          "callback_url": "http://success.com",
          "metadata": {"cancel_action": "http://failed.com"}
        }));
    print(response.body);
    if (response.statusCode == 200) {
      url = jsonDecode(response.body)['data']['authorization_url'];
      print(url);
      return;
    }

    // print(response.statusCode);
    // if (response.statusCode == 201) {
    // this.url =
    //     'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantKey}&amount=$amount&item_name=GrenmartGroceries';
    // //   return;
    // // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaytmPayment extends StatefulWidget {
  const PaytmPayment(
      {Key? key,
      required this.isFromWalletDeposite,
      required this.reniewSubscription})
      : super(key: key);

  final isFromWalletDeposite;
  final reniewSubscription;

  @override
  State<PaytmPayment> createState() => _PaytmPaymentState();
}

class _PaytmPaymentState extends State<PaytmPayment> {
  WebViewController? _controller;
  var successUrl;
  var failedUrl;

  @override
  void initState() {
    super.initState();
    successUrl = 'https://paytm.com/';
    failedUrl = 'https://paytm.com/';
  }

  String? html;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paytm'),
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
        child: WebView(
          onWebViewCreated: (controller) {
            _controller = controller;

            // var paytmHtmlString = 'https://paytm.com/';

            // controller.loadHtmlString(paytmHtmlString);
          },
          initialUrl: successUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) async {
            print('current url is ${request.url}');
            print('success url is $successUrl');
            print('failed url is $failedUrl');
            if (request.url.contains(successUrl)) {
              //if payment is success, then the page is refreshing twice.
              //which is causing the screen pop twice.
              //So, this alreadySuccess = true trick will prevent that

              print('payment success');
              if (widget.isFromWalletDeposite) {
                Provider.of<WalletService>(context, listen: false)
                    .makeDepositeToWalletSuccess(context);
              } else if (widget.reniewSubscription) {
                Provider.of<SubscriptionService>(context, listen: false)
                    .reniewSubscription(
                  context,
                );
              }

              return NavigationDecision.prevent;
            }
            if (request.url.contains('order-cancel-static')) {
              print('payment failed');
              OthersHelper()
                  .showSnackBar(context, 'Payment failed', Colors.red);
              inFailed(context);

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}

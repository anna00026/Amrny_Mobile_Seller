// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';

class MercadopagoPaymentPage extends StatefulWidget {
  const MercadopagoPaymentPage({
    Key? key,
    required this.isFromWalletDeposite,
    required this.reniewSubscription,
  }) : super(key: key);

  final bool isFromWalletDeposite;
  final bool reniewSubscription;

  @override
  State<MercadopagoPaymentPage> createState() => _MercadopagoPaymentPageState();
}

class _MercadopagoPaymentPageState extends State<MercadopagoPaymentPage> {
  @override
  void initState() {
    super.initState();
  }

  late String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercado pago'),
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
            future: getPaymentUrl(context),
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
                onWebResourceError: (error) => showDialog(
                    context: context,
                    builder: (ctx) {
                      return const AlertDialog(
                        title: Text('Loading failed!'),
                        content: Text('Failed to load payment page.'),
                        actions: [],
                      );
                    }),
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) async {
                  if (request.url.contains('https://www.google.com/')) {
                    print('payment success');
                    if (widget.isFromWalletDeposite) {
                      await Provider.of<WalletService>(context, listen: false)
                          .makeDepositeToWalletSuccess(context);
                    } else if (widget.reniewSubscription) {
                      Provider.of<SubscriptionService>(context, listen: false)
                          .reniewSubscription(
                        context,
                      );
                    }

                    return NavigationDecision.prevent;
                  }
                  if (request.url.contains('https://www.facebook.com/')) {
                    print('payment failed');
                    OthersHelper()
                        .showSnackBar(context, 'Payment failed', Colors.red);
                    inFailed(context);

                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              );
            }),
      ),
    );
  }

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    var amount;

    String orderId;
    String email;
    email = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .email ??
        'test@test.com';

    if (widget.isFromWalletDeposite) {
      amount = Provider.of<WalletService>(context, listen: false).amountToAdd;
      amount = double.parse(amount);
      orderId = DateTime.now().toString();
    } else if (widget.reniewSubscription) {
      amount = Provider.of<SubscriptionService>(context, listen: false)
          .subsData
          .price
          .toString();
      amount = double.parse(amount);
      orderId = "${DateTime.now().day}" "${DateTime.now().year}";
    }

    String mercadoKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .secretKey ??
            '';
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": "Amrny",
          "description": "Amrny payment",
          "quantity": 1,
          "currency_id": currencyCode,
          "unit_price": amount
        }
      ],
      'back_urls': {
        "success": 'https://www.google.com/',
        "failure": 'https://www.facebook.com',
        "pending": 'https://www.facebook.com'
      },
      'auto_return': 'approved',
      "payer": {"email": email}
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=$mercadoKey'),
        headers: header,
        body: data);

    print(response.body);

    // print(response.body);
    if (response.statusCode == 201) {
      url = jsonDecode(response.body)['init_point'];

      return;
    }
    return '';
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'dart:async';

import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/others_helper.dart';

class InstamojoPaymentPage extends StatefulWidget {
  const InstamojoPaymentPage(
      {Key? key,
      required this.amount,
      required this.name,
      required this.email,
      required this.isFromWalletDeposite,
      required this.reniewSubscription})
      : super(key: key);

  final amount;
  final name;
  final isFromWalletDeposite;
  final reniewSubscription;
  final email;
  @override
  _InstamojoPaymentPageState createState() => _InstamojoPaymentPageState();
}

bool isLoading = true; //this can be declared outside the class

class _InstamojoPaymentPageState extends State<InstamojoPaymentPage> {
  late String selectedUrl;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    createRequest(context); //creating the HTTP request
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 600), () {
      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
    });

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              showPaymentWarning(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.blueGrey,
        title: const Text("Pay"),
      ),
      body: WillPopScope(
        onWillPop: () {
          showPaymentWarning(context);
          return Future.value(false);
        },
        child: Container(
          child: Center(
            child: isLoading
                ? //check loadind status
                const CircularProgressIndicator() //if true
                : InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.tryParse(selectedUrl),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {},
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (_, Uri? uri, __) {
                      String url = uri.toString();
                      // print(uri);
                      // uri containts newly loaded url
                      if (mounted) {
                        if (url.contains('https://www.google.com/')) {
                          //Take the payment_id parameter of the url.
                          String? paymentRequestId =
                              uri?.queryParameters['payment_id'];
                          // print("value is: " +paymentRequestId);
                          //calling this method to check payment status
                          _checkPaymentStatus(paymentRequestId!);
                        }
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {
    // var header = {
    //       "Accept": "application/json",
    //       "Content-Type": "application/x-www-form-urlencoded",
    //       "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
    //       "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
    //     };

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Api-Key":
          Provider.of<PaymentGatewayListService>(context, listen: false)
              .publicKey
              .toString(),
      "X-Auth-Token":
          Provider.of<PaymentGatewayListService>(context, listen: false)
              .secretKey
              .toString()
    };

    var response = await http.get(
        Uri.parse("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: header);

    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print('instamojo payment successfull');

        if (widget.isFromWalletDeposite) {
          Provider.of<WalletService>(context, listen: false)
              .makeDepositeToWalletSuccess(context);
        } else if (widget.reniewSubscription) {
          Provider.of<SubscriptionService>(context, listen: false)
              .reniewSubscription(
            context,
          );
        }

//payment is successful.
      } else {
        print('failed');

        inFailed(context);
//payment failed or pending.
      }
    } else {
      inFailed(context);
      print("PAYMENT STATUS FAILED");
    }
  }

  Future createRequest(BuildContext context) async {
    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;
    Map<String, String> body = {
      "amount": widget.amount, //amount to be paid
      "purpose": "Amrny pay",
      "buyer_name": widget.name,
      "email": widget.email,
      "allow_repeated_payments": "true",
      "send_email": "true",
      'currency': currencyCode,
      "send_sms": "false",
      "redirect_url": "https://www.google.com/",
      //Where to redirect after a successful payment.
      "webhook": "https://www.google.com/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.parse("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
          "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
        },
        body: body);
    print(jsonDecode(resp.body));
    if (jsonDecode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      setState(() {
        isLoading = false; //setting state to false after data loaded

        selectedUrl =
            json.decode(resp.body)["payment_request"]['longurl'].toString() +
                "?embed=form";
      });
      print(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }
}

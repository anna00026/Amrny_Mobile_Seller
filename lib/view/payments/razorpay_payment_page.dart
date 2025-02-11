// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/view/orders/payment_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../services/payments_service/payment_gateway_list_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/others_helper.dart';

class RazorpayPaymentPage extends StatefulWidget {
  const RazorpayPaymentPage(
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

  @override
  _RazorpayPaymentPageState createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    // amount = Provider.of<BookConfirmationService>(context, listen: false)
    //     .totalPriceAfterAllcalculation
    //     .toString();
    initializeRazorPay();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    launchRazorPay(context);
  }

  void launchRazorPay(BuildContext context) {
    double amountToPay = double.parse(widget.amount) * 100;

    // var options = {
    //   'key': 'rzp_test_FSFnXQOqPP1YbJ',
    //   'amount': "$amountToPay",
    //   'name': name,
    //   'description': ' ',
    //   'prefill': {'contact': phone, 'email': email}
    // };

    final currencyCode =
        Provider.of<RtlService>(context, listen: false).currencyCode;

    var options = {
      'key': Provider.of<PaymentGatewayListService>(context, listen: false)
              .publicKey ??
          '',
      'amount': "$amountToPay",
      'name': widget.name,
      'currency': currencyCode,
      'description': ' ',
      'prefill': {'contact': widget.phone, 'email': widget.email}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");

    if (widget.isFromWalletDeposite) {
      Provider.of<WalletService>(context, listen: false)
          .makeDepositeToWalletSuccess(context);
    } else if (widget.reniewSubscription) {
      Provider.of<SubscriptionService>(context, listen: false)
          .reniewSubscription(
        context,
      );
    }

    // print(
    //     "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payemt Failed");
    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
    inFailed(context);
    // print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // print("Payment Failed");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay"),
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
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 20, left: 25, right: 25),
                  child: PaymentHelper()
                      .detailsPanelRow('Total', 0, widget.amount),
                ),
                // textField(size, "Name", false, name),
                // textField(size, "Phone no.", false, phoneNo),
                // textField(size, "Email", false, email),
                // textField(size, "Description", false, description),
                // textField(size, "amount", true, amount),
                // ElevatedButton(
                //   onPressed: launchRazorPay,
                //   child: const Text("Pay Now"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(Size size, String text, bool isNumerical,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 50),
      child: SizedBox(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          controller: controller,
          keyboardType: isNumerical ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: text,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/responsive.dart';

import '../services/app_string_service.dart';
import '../services/payments_service/payment_service.dart';
import '../view/home/home.dart';
import 'common_helper.dart';

class OthersHelper with ChangeNotifier {
  ConstantColors cc = ConstantColors();
  int deliveryCharge = 60;

  showLoading(Color color) {
    return SpinKitThreeBounce(
      color: color,
      size: 16.0,
    );
  }

  showError(BuildContext context, {String message = "Something went wrong"}) {
    return Container(
        height: MediaQuery.of(context).size.height - 180,
        alignment: Alignment.center,
        child: Text(asProvider.getString(message)));
  }

  void showToast(String msg, Color? color) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: asProvider.getString(msg),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // snackbar
  showSnackBar(BuildContext context, String msg, color) {
    var snackBar = SnackBar(
      content: Text(asProvider.getString(msg)),
      backgroundColor: color,
      duration: const Duration(milliseconds: 2000),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void toastShort(String msg, Color color) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: asProvider.getString(msg),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

commonRefreshFooter(BuildContext context) {
  final asProvider = Provider.of<AppStringService>(context, listen: false);
  ConstantColors cc = ConstantColors();
  return CustomFooter(
    builder: (context, mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = const Text("");
      } else if (mode == LoadStatus.loading) {
        body = OthersHelper().showLoading(cc.greyFour);
      } else if (mode == LoadStatus.failed) {
        body = Text(asProvider.getString("Load Failed"),
            style: TextStyle(color: cc.greyFour));
      } else if (mode == LoadStatus.canLoading) {
        body = Text(asProvider.getString("Release to load more"),
            style: TextStyle(color: cc.greyFour));
      } else {
        body = Text(asProvider.getString("No more Data"),
            style: TextStyle(color: cc.greyFour));
      }
      return SizedBox(
        height: 55.0,
        child: Center(child: body),
      );
    },
  );
}

showPaymentWarning(context, {isFromEventBook = false}) async {
  final asProvider = Provider.of<AppStringService>(context, listen: false);
  await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(asProvider.getString('Are you sure?')),
          content: Text(
              asProvider.getString('Your payment process will be terminated.')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                inFailed(context);
              },
              child: Text(
                asProvider.getString('Yes'),
                style: TextStyle(color: ConstantColors().primaryColor),
              ),
            )
          ],
        );
      });
}

inFailed(BuildContext context) async {
  OthersHelper().showToast('Wallet deposit failed', Colors.black);

  // await fetchWalletBalance(context);

  await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(asProvider.getString('')),
          content: SizedBox(
            height: 136,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/payment_failed.png',
                  height: 100,
                ),
                const SizedBox(height: 12),
                Text(asProvider.getString('Payment failed!')),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CommonHelper()
                  .borderButtonPrimary(asProvider.getString('Go to home'), () {
                Navigator.pop(context);
              }),
            )
          ],
        );
      });
  Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Homepage()),
      (Route<dynamic> route) => false);
}

String loadingImageUrl = 'https://i.postimg.cc/3RKkSRDb/loading_image.png';

String userloadingImageUrl =
    'https://i.postimg.cc/ZYQp5Xv1/blank-profile-picture-gb26b7fbdf-1280.png';

String get baseApi => '$siteLink/api/v1';
String siteLink = 'https://amrny.com';

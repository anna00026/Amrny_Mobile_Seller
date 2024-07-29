import 'package:flutter/material.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';

class ReniewSubscriptionSuccessPage extends StatefulWidget {
  const ReniewSubscriptionSuccessPage({
    Key? key,
  }) : super(key: key);

  @override
  _ReniewSubscriptionSuccessPageState createState() =>
      _ReniewSubscriptionSuccessPageState();
}

class _ReniewSubscriptionSuccessPageState
    extends State<ReniewSubscriptionSuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  final cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Success', context, () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          child: Container(
            height: screenHeight(context) - 180,
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: cc.successColor,
                    size: 85,
                  ),
                  sizedBoxCustom(7),
                  Text(
                    'Subscription renewed',
                    style: TextStyle(
                        color: cc.greyFour,
                        fontSize: 21,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
        )));
  }
}

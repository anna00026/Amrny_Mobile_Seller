import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';

class SubscriptionHistoryPage extends StatefulWidget {
  const SubscriptionHistoryPage({Key? key}) : super(key: key);

  @override
  _SubscriptionHistoryPageState createState() =>
      _SubscriptionHistoryPageState();
}

class _SubscriptionHistoryPageState extends State<SubscriptionHistoryPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SubscriptionService>(context, listen: false)
        .fetchSubscriptionHistory(context);
  }

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Subscriptions', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<SubscriptionService>(
          builder: (context, provider, child) => Consumer<SubscriptionService>(
            builder: (context, provider, child) =>
                provider.hasSubsHistory == true
                    ? provider.subsHistoryList.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenPadding, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0;
                                    i < provider.subsHistoryList.length;
                                    i++)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonHelper().titleCommon(
                                                    '${provider.subsHistoryList[i].type} ' +
                                                        asProvider.getString(
                                                            'subscription'),
                                                    fontsize: 15),
                                                sizedBoxCustom(8),
                                                Text(
                                                  asProvider.getString(
                                                          "Start date") +
                                                      ": ${formatDate(provider.subsHistoryList[i].createdAt)}",
                                                  style: TextStyle(
                                                    color: cc.greyFour,
                                                    fontSize: 14,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                sizedBoxCustom(6),
                                                Text(
                                                  asProvider.getString(
                                                          "Expire date") +
                                                      ": ${formatDate(provider.subsHistoryList[i].expireDate)}",
                                                  style: TextStyle(
                                                    color: cc.greyFour,
                                                    fontSize: 14,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        // Icon(
                                        //   Icons.arrow_forward_ios,
                                        //   size: 16,
                                        //   color: cc.greyFour,
                                        // )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : Container(
                            height: screenHeight(context) - 140,
                            alignment: Alignment.center,
                            child: OthersHelper().showLoading(cc.primaryColor),
                          )
                    : Container(
                        height: screenHeight(context) - 120,
                        alignment: Alignment.center,
                        child: Text(asProvider.getString('No history found')),
                      ),
          ),
        ),
      ),
    );
  }
}

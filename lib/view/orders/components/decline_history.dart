import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/orders_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/responsive.dart';

class DeclineHistory extends StatelessWidget {
  const DeclineHistory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return Consumer<OrdersService>(
      builder: (context, provider, child) => provider.declineHistory != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 25),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHelper()
                      .titleCommon(asProvider.getString('Decline history')),
                  for (int i = 0;
                      i < provider.declineHistory['decline_histories'].length;
                      i++)
                    Container(
                      margin: const EdgeInsets.only(top: 13),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHelper().titleCommon(
                                asProvider.getString("Decline reason") +
                                    ":  ${provider.declineHistory['decline_histories'][i]['decline_reason']}",
                                fontsize: 14,
                                lineheight: 1.5),
                            sizedBoxCustom(8),
                            CommonHelper().titleCommon(
                                asProvider.getString('Buyer details') + ':',
                                fontsize: 14,
                                color: cc.successColor),
                            sizedBoxCustom(8),
                            CommonHelper().paragraphCommon(
                                asProvider.getString('Name') +
                                    ': ${provider.declineHistory['buyer_details'][0]['name']}',
                                TextAlign.left),
                            sizedBoxCustom(4),
                            CommonHelper().paragraphCommon(
                                asProvider.getString('Email') +
                                    ': ${provider.declineHistory['buyer_details'][0]['email']}',
                                TextAlign.left),
                            sizedBoxCustom(4),
                            CommonHelper().paragraphCommon(
                                asProvider.getString('Phone') +
                                    ': ${provider.declineHistory['buyer_details'][0]['phone']}',
                                TextAlign.left),
                            sizedBoxCustom(20),
                            CommonHelper().dividerCommon()
                          ]),
                    )
                ],
              ),
            )
          : Container(),
    );
  }
}

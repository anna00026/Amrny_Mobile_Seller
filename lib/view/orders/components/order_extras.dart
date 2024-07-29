import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/order_details_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/orders/orders_helper.dart';

import '../../../utils/responsive.dart';

class OrderExtras extends StatelessWidget {
  const OrderExtras({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final orderId;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsService>(
      builder: (context, provider, child) => provider.orderExtra.isNotEmpty
          ? Container(
              margin: const EdgeInsets.only(bottom: 25),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHelper().titleCommon('Extras'),
                  const SizedBox(
                    height: 20,
                  ),
                  for (int i = 0; i < provider.orderExtra.length; i++)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CommonHelper().titleCommon(
                                    provider.orderExtra[i].title.toString(),
                                    fontsize: 14),
                              ),

                              // delete button
                              //0=pending,1=accept,2=decline

                              if (provider.orderExtra[i].status.toString() ==
                                  "0")
                                InkWell(
                                  onTap: () {
                                    OrdersHelper().deleteExtraPopup(context,
                                        extraId: provider.orderExtra[i].id,
                                        orderId: orderId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(height: 4),
                          OrdersHelper().statusCapsule(
                              (asProvider.getString(extraStatus(
                                      provider.orderExtra[i].status)) as String)
                                  .capitalize(),
                              extraColor(provider.orderExtra[i].status)),
                          const SizedBox(height: 4),
                          CommonHelper().paragraphCommon(
                              asProvider.getString("Unit price") +
                                  ': ${rtlProvider.currency}${provider.orderExtra[i].price.toStringAsFixed(2)}    ${asProvider.getString("Quantity")}: ${provider.orderExtra[i].quantity}',
                              TextAlign.left),
                          const SizedBox(
                            height: 4,
                          ),
                          CommonHelper().paragraphCommon(
                              asProvider.getString("Total") +
                                  ': ${rtlProvider.currency}${provider.orderExtra[i].total.toStringAsFixed(2)}',
                              TextAlign.left),
                          sizedBoxCustom(10),
                          CommonHelper().dividerCommon(),
                          sizedBoxCustom(10),
                        ]),
                ],
              ),
            )
          : Container(),
    );
  }

  extraStatus(status) {
    String statusString = '';
    switch (status.toString()) {
      case "1":
        statusString = "complete";
        break;
      case "2":
        statusString = "declined";
        break;
      default:
        statusString = "pending";
    }
    return statusString;
  }

  extraColor(status) {
    ConstantColors cc = ConstantColors();
    Color statusColor;
    switch (status.toString()) {
      case "1":
        statusColor = cc.successColor;
        break;
      case "2":
        statusColor = cc.warningColor;
        break;
      default:
        statusColor = cc.greyFour;
    }
    return statusColor;
  }
}

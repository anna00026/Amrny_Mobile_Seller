import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/orders_service.dart';

import '../../utils/common_helper.dart';
import '../../utils/constant_styles.dart';
import '../../utils/custom_dropdown.dart';
import '../../utils/responsive.dart';

class OrderSorting extends StatelessWidget {
  static const routeName = '';
  const OrderSorting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersService>(builder: (context, oProvider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonHelper().labelCommon(asProvider.getString('Order') + ' ',
                    marginBotton: 0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.3,
                  child: CustomDropdown(
                    asProvider.getString("Select status"),
                    oProvider.orderStatusOptions,
                    (p0) {
                      oProvider.setOrderSort(p0);
                      oProvider.fetchAllOrders(isrefresh: true);
                    },
                    value: oProvider.selectedOrderSort,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                CommonHelper().labelCommon(
                    asProvider.getString('Payment') + '  ',
                    marginBotton: 0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.3,
                  child: CustomDropdown(
                    asProvider.getString("Select status"),
                    oProvider.paymentStatusOptions,
                    (p0) {
                      oProvider.setPaymentSort(p0);
                      oProvider.fetchAllOrders(isrefresh: true);
                    },
                    value: oProvider.selectedPaymentSort,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

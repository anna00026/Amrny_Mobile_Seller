import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/order_details_service.dart';
import 'package:amrny_seller/services/orders_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/orders/payment_helper.dart';

class OrderStatus extends StatelessWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<OrderDetailsService>(
        builder: (context, provider, child) => Column(
          children: [
            Consumer<OrdersService>(
              builder: (context, oProvider, child) => Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHelper().titleCommon(ln.getString('Order Status')),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: PaymentHelper().bRow(
                            'null',
                            ln.getString('Order status'),
                            asProvider.getString(provider.orderStatus ?? "") ??
                                "",
                            lastBorder: false),
                      ),

                      //===========>
                      if (provider.orderStatus != 'Completed')
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: CommonHelper().buttonPrimary(
                              ln.getString(
                                  'Request buyer to mark this order complete'),
                              () {
                            if (oProvider.markLoading) {
                              return;
                            }

                            oProvider.requestToComplete(
                              context,
                              orderId: provider.orderDetails.id,
                              buyerId: provider.orderDetails.buyerId,
                            );
                          }, isloading: oProvider.markLoading),
                        )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/order_details_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/view/orders/payment_helper.dart';

class BuyerDetails extends StatelessWidget {
  const BuyerDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<OrderDetailsService>(
        builder: (context, provider, child) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().titleCommon(ln.getString('Buyer Details')),
                    const SizedBox(
                      height: 25,
                    ),
                    //Service row

                    Container(
                      child: PaymentHelper().bRow('null', ln.getString('Name'),
                          provider.orderDetails.buyerDetails.name),
                    ),

                    Container(
                      child: PaymentHelper().bRow('null', ln.getString('Email'),
                          provider.orderDetails.buyerDetails.email ?? ''),
                    ),

                    Container(
                      child: PaymentHelper().bRow('null', ln.getString('Phone'),
                          provider.orderDetails.buyerDetails.phone ?? ''),
                    ),
                    provider.orderDetails.isOrderOnline == 0
                        ? Container(
                            child: PaymentHelper().bRow(
                                'null',
                                ln.getString('Post code'),
                                provider.orderDetails.buyerDetails.postCode ??
                                    ''),
                          )
                        : Container(),
                    provider.orderDetails.isOrderOnline == 0
                        ? Container(
                            child: PaymentHelper().bRow(
                                'null',
                                ln.getString('Address'),
                                provider.orderDetails.buyerDetails.address ??
                                    '',
                                lastBorder: false),
                          )
                        : Container(),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

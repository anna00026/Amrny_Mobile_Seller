import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/order_details_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/orders/orders_helper.dart';
import 'package:amrny_seller/view/orders/payment_helper.dart';

class AmountDetails extends StatelessWidget {
  const AmountDetails({Key? key}) : super(key: key);

  double parseCurrencyValue(String val) {
    return double.tryParse(val.replaceAll("SR", "")) ?? 0;
  }
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
                    CommonHelper().titleCommon(ln.getString('Amount Details')),
                    const SizedBox(
                      height: 25,
                    ),
                    //Service row

                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          ln.getString('Package fee'),
                          provider.orderDetails.packageFee.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          ln.getString('Extra service'),
                          provider.orderDetails.extraService.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          asProvider.getString(
                              provider.orderDetails.couponCode == 'subscription'
                                  ? 'Discount'
                                  : 'Coupon'),
                          provider.orderDetails.couponAmount.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          ln.getString('Subtotal'),
                          provider.orderDetails.subTotal.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow('null', ln.getString('Tax'),
                          provider.orderDetails.tax.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow('null', ln.getString('Total'),
                          provider.orderDetails.total.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          ln.getString('Admin Charge'),
                          provider.orderDetails.commissionAmount.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          ln.getString('Freelancer'),
                          provider.orderDetails.freelancer.toString()),
                    ),

                    Container(
                      child: PaymentHelper().bRow(
                        'null',
                        ln.getString('Payment status'),
                        asProvider.getString(
                                provider.orderDetails.paymentStatus ?? '') ??
                            '',
                      ),
                    ),
                    Container(
                      child: PaymentHelper().bRow(
                          'null',
                          ln.getString('Payment method'),
                          asProvider.getString(removeUnderscore(
                              provider.orderDetails.paymentGateway ?? '-')),
                          lastBorder: false),
                    ),

                    if (provider.orderDetails.paymentStatus == 'pending' &&
                        provider.orderDetails.paymentGateway ==
                            'cash_on_delivery')
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: CommonHelper().buttonPrimary(
                            asProvider
                                .getString('Make payment status complete'), () {
                          OrdersHelper().makePaymentCompletePopup(context,
                              orderId: provider.orderDetails.id);
                        }, paddingVertical: 16),
                      )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

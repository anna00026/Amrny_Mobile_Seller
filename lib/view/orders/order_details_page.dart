import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/order_details_service.dart';
import 'package:amrny_seller/services/orders_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/orders/components/amount_details.dart';
import 'package:amrny_seller/view/orders/components/buyer_details.dart';
import 'package:amrny_seller/view/orders/components/date_schedule.dart';
import 'package:amrny_seller/view/orders/components/decline_history.dart';
import 'package:amrny_seller/view/orders/components/order_extras.dart';
import 'package:amrny_seller/view/orders/components/order_status.dart';
import 'package:amrny_seller/view/orders/orders_helper.dart';
import '../../utils/others_helper.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  _OrdersDetailsPageState createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cc.bgColor,
        appBar: CommonHelper().appbarCommon('Order Details', context, () {
          Navigator.pop(context);
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<AppStringService>(
              builder: (context, ln, child) => Consumer<OrderDetailsService>(
                builder: (context, provider, child) => provider.isLoading ==
                        false
                    ? provider.orderDetails != 'error'
                        ? Consumer<OrdersService>(
                            builder: (context, oProvider, child) => Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //Service name
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 25),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(9)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonHelper().titleCommon(ln
                                                .getString('Ordered service')),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            //Service row

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // CommonHelper().profileImage(
                                                //     'https://cdn.pixabay.com/photo/2022/07/13/22/27/butterfly-7320158__340.jpg',
                                                //     50,
                                                //     50),
                                                Text(
                                                  ln.getString("Order ID:") +
                                                      " ${provider.orderDetails.id}",
                                                  style: TextStyle(
                                                    color: cc.primaryColor,
                                                    fontSize: 14,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  provider.orderedServiceTitle ??
                                                      '',
                                                  style: TextStyle(
                                                    color: cc.greyThree,
                                                    fontSize: 14,
                                                    height: 1.4,
                                                  ),
                                                )
                                              ],
                                            )
                                          ]),
                                    ),

                                    //Buyer details
                                    const BuyerDetails(),

                                    // Date and schedule
                                    const DateSchedule(),

                                    //Amount details
                                    const AmountDetails(),

                                    // Order status
                                    const OrderStatus(),

                                    const DeclineHistory(),

                                    OrderExtras(
                                      orderId: provider.orderDetails.id,
                                    ),

                                    if (provider.orderDetails.paymentStatus ==
                                            'complete' &&
                                        provider.orderStatus != 'Completed')
                                      CommonHelper().buttonPrimary(
                                          asProvider.getString('Add extra'),
                                          () {
                                        Provider.of<OrderDetailsService>(
                                                context,
                                                listen: false)
                                            .setLoadingStatus(false);
                                        OrdersHelper().addExtraPopup(
                                            context, provider.orderDetails.id);
                                      }),

                                    const SizedBox(
                                      height: 30,
                                    ),

                                    //
                                  ]),
                            ),
                          )
                        : CommonHelper().nothingfound(
                            context, ln.getString("No details found"))
                    : Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height - 120,
                        child: OthersHelper().showLoading(cc.primaryColor)),
              ),
            ),
          ),
        ));
  }
}

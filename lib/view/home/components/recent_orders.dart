import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/order_details_service.dart';
import 'package:qixer_seller/services/recent_orders_service.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/home/components/section_title.dart';
import 'package:qixer_seller/view/orders/all_orders_page.dart';
import 'package:qixer_seller/view/orders/order_details_page.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();
    return Consumer<RtlService>(
      builder: (context, rtlP, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Consumer<RecentOrdersService>(
          builder: (context, rProvider, child) =>
              rProvider.recentOrdersData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (rProvider.recentOrdersData.recentOrders.isNotEmpty)
                          SectionTitle(
                            cc: cc,
                            title: ln.getString('Recent Orders'),
                            pressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const AllOrdersPage(),
                                ),
                              );
                            },
                          ),
                        ListView.builder(
                            itemCount:
                                rProvider.recentOrdersData.recentOrders.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<OrderDetailsService>(context,
                                          listen: false)
                                      .fetchOrderDetails(
                                          rProvider.recentOrdersData
                                              .recentOrders[index].id,
                                          context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const OrderDetailsPage(),
                                      ));
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 15),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(.2),
                                        width: 1.0,
                                      ),
                                    )),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${ln.getString("Order ID:")} ${rProvider.recentOrdersData.recentOrders[index].id}",
                                                style: TextStyle(
                                                  color: cc.primaryColor,
                                                  fontSize: 12,
                                                  height: 1.4,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                rProvider.recentOrdersData
                                                    .recentOrders[index].name
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: cc.greyFour,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${rtlP.currency}${rProvider.recentOrdersData.recentOrders[index].total}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: cc.greyFour,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }),
                      ],
                    )
                  : OthersHelper().showLoading(cc.primaryColor),
        ),
      ),
    );
  }
}

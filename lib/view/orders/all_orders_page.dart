import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/order_details_service.dart';
import 'package:qixer_seller/services/orders_service.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/orders/order_details_page.dart';
import 'package:qixer_seller/view/orders/order_sort.dart';

import 'orders_helper.dart';

class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage({Key? key}) : super(key: key);

  @override
  _AllOrdersPageState createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('All Orders', context, () {
          Navigator.pop(context);
        }),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const OrderSorting(),
              Expanded(
                child: SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: () async {
                    final result =
                        await Provider.of<OrdersService>(context, listen: false)
                            .fetchAllOrders(isrefresh: true);
                    if (result) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result =
                        await Provider.of<OrdersService>(context, listen: false)
                            .fetchAllOrders();
                    if (result) {
                      debugPrint('loadcomplete ran');
                      //loadcomplete function loads the data again
                      refreshController.loadComplete();
                    } else {
                      debugPrint('no more data');
                      refreshController.loadNoData();

                      Future.delayed(const Duration(seconds: 1), () {
                        //it will reset footer no data state to idle and will let us load again
                        refreshController.resetNoData();
                      });
                    }
                  },
                  child: SingleChildScrollView(
                      physics: physicsCommon,
                      child: Consumer<AppStringService>(
                        builder: (context, ln, child) => Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: screenPadding),
                          child: Consumer<OrdersService>(
                            builder: (context, provider, child) =>
                                provider.isLoading
                                    ? Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                200,
                                        child: OthersHelper()
                                            .showLoading(cc.primaryColor))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            if (provider.allOrdersList.isEmpty)
                                              OthersHelper().showError(context,
                                                  message: 'No order found'),
                                            for (int i = 0;
                                                i <
                                                    provider
                                                        .allOrdersList.length;
                                                i++)
                                              InkWell(
                                                onTap: () {
                                                  Provider.of<OrderDetailsService>(
                                                          context,
                                                          listen: false)
                                                      .fetchOrderDetails(
                                                          provider
                                                              .allOrdersList[i]
                                                              .id,
                                                          context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const OrderDetailsPage(),
                                                      ));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(
                                                    top: 20,
                                                    bottom: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              cc.borderColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Column(
                                                    children: [
                                                      //order id, status, popup menu
                                                      //
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                16, 5, 0, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            AutoSizeText(
                                                              ln.getString(
                                                                      'Order id') +
                                                                  ': ' +
                                                                  provider
                                                                      .allOrdersList[
                                                                          i]
                                                                      .id
                                                                      .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: cc
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                //if online service,show online capsule
                                                                provider.allOrdersList[i]
                                                                            .isOrderOnline ==
                                                                        1
                                                                    ? Container(
                                                                        margin: const EdgeInsets.only(
                                                                            right:
                                                                                10),
                                                                        child: OrdersHelper().statusCapsule(
                                                                            ln.getString('Online'),
                                                                            cc.primaryColor),
                                                                      )
                                                                    : Container(),

                                                                OrdersHelper().statusCapsule(
                                                                    asProvider.getString(OrderDetailsService().getOrderStatus(provider
                                                                        .allOrdersList[
                                                                            i]
                                                                        .status)),
                                                                    cc.greyFour),

                                                                //============>
                                                                //popup button
                                                                PopupMenuButton(
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context) =>
                                                                          <PopupMenuEntry>[
                                                                    for (int j =
                                                                            0;
                                                                        j < OrdersHelper().ordersPopupMenuList.length;
                                                                        j++)
                                                                      PopupMenuItem(
                                                                        onTap:
                                                                            () {
                                                                          Future.delayed(
                                                                              Duration.zero,
                                                                              () {
                                                                            //

                                                                            if (j == 0 &&
                                                                                (provider.allOrdersList[i].paymentStatus == 'complete' || provider.allOrdersList[i].status != 0)) {
                                                                              //0 means pending
                                                                              OthersHelper().showToast('You can not cancel this order', Colors.black);
                                                                              return;
                                                                            }

                                                                            OrdersHelper().navigateMyOrders(context,
                                                                                index: j,
                                                                                serviceId: provider.allOrdersList[i].serviceId,
                                                                                orderId: provider.allOrdersList[i].id);
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                            ln.getString(OrdersHelper().ordersPopupMenuList[j])),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 5, 15, 18),
                                                        child: Column(
                                                            children: [
                                                              //Divider
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            20),
                                                                child: CommonHelper()
                                                                    .dividerCommon(),
                                                              ),

                                                              //Date and schedule
                                                              provider.allOrdersList[i]
                                                                          .isOrderOnline ==
                                                                      1
                                                                  ? Container()
                                                                  : Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            OrdersHelper().orderRow(
                                                                              'assets/svg/calendar.svg',
                                                                              ln.getString('Date'),
                                                                              provider.allOrdersList[i].date == null ? asProvider.getString("No date found") : DateFormat.MMMMEEEEd(rtlProvider.langSlug.substring(0, 2)).format(provider.allOrdersList[i].date).toString(),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(vertical: 14),
                                                                              child: CommonHelper().dividerCommon(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            OrdersHelper().orderRow(
                                                                              'assets/svg/clock.svg',
                                                                              ln.getString('Schedule'),
                                                                              asProvider.getString(provider.allOrdersList[i].schedule.toString()),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.symmetric(vertical: 14),
                                                                              child: CommonHelper().dividerCommon(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),

                                                              Consumer<
                                                                  RtlService>(
                                                                builder: (context,
                                                                        rtlP,
                                                                        child) =>
                                                                    OrdersHelper()
                                                                        .orderRow(
                                                                  'assets/svg/bill.svg',
                                                                  ln.getString(
                                                                      'Billed'),
                                                                  rtlP.currencyDirection ==
                                                                          'left'
                                                                      ? '${rtlP.currency}${provider.allOrdersList[i].total}'
                                                                      : '${provider.allOrdersList[i].total}${rtlP.currency}',
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            //
                                          ]),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}

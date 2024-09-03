import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/payout_details_service.dart';
import 'package:amrny_seller/services/payout_history_service.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/view/payout/components/payout_page_appbar.dart';
import 'package:amrny_seller/view/payout/payout_details_page.dart';

import '../../utils/others_helper.dart';

class PayoutPage extends StatefulWidget {
  const PayoutPage({Key? key}) : super(key: key);

  @override
  State<PayoutPage> createState() => _PayoutPageState();
}

class _PayoutPageState extends State<PayoutPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: PayoutPageAppbar(),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<PayoutHistoryService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<PayoutHistoryService>(context, listen: false)
                  .fetchPayoutHistory(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<PayoutHistoryService>(context, listen: false)
                  .fetchPayoutHistory(context);
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
          child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Consumer<AppStringService>(
                builder: (context, ln, child) => Consumer<PayoutHistoryService>(
                  builder: (context, provider, child) => provider
                          .payoutHistoryList.isNotEmpty
                      ? Table(
                          children: [
                            TableRow(children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: cc.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13),
                                  child: const Text(
                                    'ID',
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Container(
                                  color: cc.primaryColor,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13),
                                  child: Text(
                                    ln.getString('Request date'),
                                    style: const TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                    color: cc.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(7),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13),
                                  child: Text(
                                    ln.getString('View'),
                                    style: const TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ]),
                            for (int i = 0;
                                i < provider.payoutHistoryList.length;
                                i++)
                              TableRow(
                                  decoration: BoxDecoration(
                                    color: i % 2 == 0
                                        ? Colors.white
                                        : const Color(0xffF6F6F6),
                                  ),
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 15),
                                        child: Text(
                                          '#${provider.payoutHistoryList[i].id}',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: cc.greyPrimary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 15),
                                        child: Text(
                                          '${formatDate(provider.payoutHistoryList[i].createdAt)}',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: cc.greyPrimary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    InkWell(
                                      onTap: () {
                                        Provider.of<PayoutDetailsService>(
                                                context,
                                                listen: false)
                                            .fetchPayoutDetails(provider
                                                .payoutHistoryList[i].id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const PayoutDetailsPage(),
                                            ));
                                      },
                                      child: Container(
                                          color: i % 2 == 0
                                              ? Colors.white
                                              : const Color(0xffF6F6F6),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 15),
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: cc.primaryColor,
                                          )),
                                    ),
                                    // Container(
                                    //     color: i % 2 == 0
                                    //         ? Colors.white
                                    //         : const Color(0xffF6F6F6),
                                    //     alignment: Alignment.center,
                                    //     padding: const EdgeInsets.symmetric(
                                    //         horizontal: 7, vertical: 15),
                                    //     child: Text(
                                    //       '${OrderDetailsService().getOrderStatus(provider.payoutHistoryList[i].status)}',
                                    //       style: TextStyle(
                                    //           fontSize: 15.0,
                                    //           color: cc.greyPrimary),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     )),
                                  ]),
                          ],
                        )
                      : OthersHelper().showError(context,
                          message: 'No payment history found'),
                ),
              )),
        ),
        footer: commonRefreshFooter(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/report_services/report_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';

import '../../utils/others_helper.dart';

class MyReportsListPage extends StatefulWidget {
  const MyReportsListPage({Key? key}) : super(key: key);

  @override
  _MyReportsListPageState createState() => _MyReportsListPageState();
}

class _MyReportsListPageState extends State<MyReportsListPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Reports', context, () {
          Navigator.pop(context);
          Provider.of<ReportService>(context, listen: false)
              .setReportListDefault();
        }),
        body: WillPopScope(
          onWillPop: () {
            Provider.of<ReportService>(context, listen: false)
                .setReportListDefault();

            return Future.value(true);
          },
          child: SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            enablePullDown:
                context.watch<ReportService>().currentPage > 1 ? false : true,
            onRefresh: () async {
              final result =
                  await Provider.of<ReportService>(context, listen: false)
                      .fetchReportList(context);
              if (result) {
                refreshController.refreshCompleted();
              } else {
                refreshController.refreshFailed();
              }
            },
            onLoading: () async {
              final result =
                  await Provider.of<ReportService>(context, listen: false)
                      .fetchReportList(context);
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
                builder: (context, asProvider, child) => Consumer<
                        ReportService>(
                    builder: (context, provider, child) => provider
                            .reportList.isNotEmpty
                        ? Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: screenPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0;
                                    i < provider.reportList.length;
                                    i++)
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 3,
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 3),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: cc.borderColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Ticket title

                                          Row(
                                            children: [
                                              Expanded(
                                                // width: screenWidth - 200,
                                                child:
                                                    CommonHelper().labelCommon(
                                                  asProvider.getString(
                                                          'Report id') +
                                                      ': ' +
                                                      provider.reportList[i]
                                                              ['id']
                                                          .toString(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: CommonHelper()
                                                    .buttonPrimary(
                                                        asProvider.getString(
                                                            'Chat admin'), () {
                                                  provider.goToMessagePage(
                                                      context,
                                                      provider.reportList[i]
                                                          ['subject'],
                                                      provider.reportList[i]
                                                          ['id']);
                                                }, paddingVertical: 10),
                                              )
                                            ],
                                          ),

                                          CommonHelper().labelCommon(
                                            asProvider.getString('Order id') +
                                                ': ' +
                                                provider.reportList[i]
                                                        ['orderId']
                                                    .toString(),
                                          ),
                                        ]),
                                  )
                              ],
                            ),
                          )
                        : CommonHelper().nothingfound(
                            context, asProvider.getString('No Report'))),
              ),
            ),
            footer: commonRefreshFooter(context),
          ),
        ));
  }
}

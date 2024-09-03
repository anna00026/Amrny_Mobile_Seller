import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/day_schedule_service/day_service.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/view/service_day/day_card.dart';

import '../../utils/common_helper.dart';
import '../../utils/others_helper.dart';
import '../../utils/responsive.dart';
import 'day_helper.dart';

class DayListPage extends StatelessWidget {
  static const routeName = 'day_list_page';
  const DayListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    screenSizeAndPlatform(context);
    initializeLNProvider(context);
    final dProvider = Provider.of<DayService>(context, listen: false);
    ConstantColors cc = ConstantColors();
    final sw = screenWidth(context);
    return Scaffold(
        appBar: CommonHelper().appbarCommon('Days', context, () {
          Navigator.pop(context);
        }, actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: FittedBox(
              child: IconButton(
                onPressed: () async {
                  Provider.of<DayService>(context, listen: false)
                      .fetchDynamicDays(context);
                  showCreateDayDialogue(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return cc.primaryColor;
                  }),
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                      (states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8));
                    // }
                  }),
                ),
                // child: adProvider.loadingAccountDelete
                icon: Icon(
                  Icons.add,
                  color: cc.white,
                ),
                // child: Text(asProvider.getString("Create Day")),
              ),
            ),
          )
        ]),
        body: FutureBuilder(
            future: dProvider.sellerDays.isEmpty
                ? dProvider.fetchSellerDays()
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [OthersHelper().showLoading(cc.primaryColor)],
                  ),
                );
              }
              return Consumer<DayService>(builder: (context, dProvider, child) {
                return SmartRefresher(
                  controller: refreshController,
                  // enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: () async {
                    final result =
                        await dProvider.fetchSellerDays(forceFetch: true);
                    if (result == true) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  child: dProvider.sellerDays.isEmpty
                      ? OthersHelper()
                          .showError(context, message: 'No days found')
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            final element = dProvider.sellerDays[index];
                            return DayCard(
                              dayId: element.id,
                              dayTitle: element.day,
                              scheduleList: element.schedules
                                      ?.map((e) => e.schedule)
                                      .toList() ??
                                  [],
                            );
                          },
                          separatorBuilder: (contex, index) {
                            return const SizedBox(height: 8);
                          },
                          itemCount: dProvider.sellerDays.length),
                  footer: commonRefreshFooter(context),
                );
              });
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/services/day_schedule_service/schedule_service.dart';
import 'package:amrny_seller/utils/constant_colors.dart';

import '../../utils/common_helper.dart';
import '../../utils/others_helper.dart';
import '../../utils/responsive.dart';
import 'schedule_card.dart';
import 'schedule_helper.dart';

class ScheduleListPage extends StatelessWidget {
  const ScheduleListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController();
    screenSizeAndPlatform(context);
    initializeLNProvider(context);
    ConstantColors cc = ConstantColors();

    final sProvider = Provider.of<ScheduleService>(context, listen: false);
    return Scaffold(
        appBar: CommonHelper().appbarCommon('Schedules', context, () {
          Navigator.pop(context);
        }, actions: [
          Consumer<ScheduleService>(builder: (context, sProvider, child) {
            return sProvider.schedulesList == null
                ? const SizedBox()
                : Container(
                    height: 36,
                    // width: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      onPressed: () async {
                        if (sProvider.schedulesList?.days?.isEmpty ?? true) {
                          OthersHelper().showToast(
                              "Create day to add schedule", Colors.black);
                          return;
                        }
                        showCreateScheduleDialogue(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          return cc.primaryColor;
                        }),
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder?>(
                                (states) {
                          return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8));
                          // }
                        }),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: cc.white,
                      ),
                    ),
                  );
          })
        ]),
        body: FutureBuilder(
            future: sProvider.schedulesList == null
                ? sProvider.fetchSellerSchedules()
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
              return Consumer<ScheduleService>(
                  builder: (context, sProvider, child) {
                return SmartRefresher(
                  controller: refreshController,
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: () async {
                    final result =
                        await sProvider.fetchSellerSchedules(forceFetch: true);
                    if (result == true) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    print(sProvider.schedulesList?.schedule?.nextPageUrl);
                    if (sProvider.schedulesList?.schedule?.nextPageUrl ==
                        null) {
                      refreshController.loadNoData();
                    }
                    var loadSuccess = await sProvider.fetchNextSchedules();
                    if (loadSuccess == true) {
                      refreshController.loadComplete();
                      return;
                    }
                    // else {
                    //   refreshController.loadNoData();
                    // }
                  },
                  child: sProvider.schedulesList?.schedule?.data?.isEmpty ??
                          true
                      ? OthersHelper()
                          .showError(context, message: 'No schedules found')
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            final element =
                                sProvider.schedulesList?.schedule?.data?[index];
                            return ScheduleCard(
                              scheduleId: element?.id,
                              scheduleTitle: element?.schedule,
                              dayTitle: element?.days?.day,
                              dayId: element?.days?.id,
                            );
                          },
                          separatorBuilder: (contex, index) {
                            return const SizedBox(height: 8);
                          },
                          itemCount:
                              sProvider.schedulesList?.schedule?.data?.length ??
                                  0),
                );
              });
            }));
  }
}

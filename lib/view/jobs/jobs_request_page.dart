import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/services/jobs/job_conversation_service.dart';
import 'package:amrny_seller/services/jobs/job_details_service.dart';
import 'package:amrny_seller/services/jobs/job_list_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/jobs/job_conversation_page.dart';
import 'package:amrny_seller/view/jobs/job_details_page.dart';

class JobRequestPage extends StatefulWidget {
  const JobRequestPage({Key? key}) : super(key: key);

  @override
  _AppliedJobsPageState createState() => _AppliedJobsPageState();
}

class _AppliedJobsPageState extends State<JobRequestPage> {
  @override
  void initState() {
    super.initState();
  }

  ConstantColors cc = ConstantColors();

  List menuNames = ['View details', 'Conversation'];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Applied jobs', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<JobListService>().currentPage > 1 ? false : true,
        onRefresh: () async {
          final result =
              await Provider.of<JobListService>(context, listen: false)
                  .fetchJobRequestList(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<JobListService>(context, listen: false)
                  .fetchJobRequestList(context);
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
          child: Consumer<JobListService>(
              builder: (context, provider, child) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (provider.isloading == false &&
                            provider.jobReqList.isEmpty)
                          OthersHelper().showError(context,
                              message: "You didn't apply to any job"),
                        for (int i = 0; i < provider.jobReqList.length; i++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonHelper().titleCommon(
                                            provider.jobReqList[i].job.title ??
                                                '',
                                            fontsize: 15),
                                        sizedBoxCustom(6),
                                        CommonHelper().paragraphCommon(
                                            asProvider
                                                    .getString('Buyer budget') +
                                                ': ${rtlProvider.currency}${provider.jobReqList[i].job.price ?? ''}',
                                            TextAlign.left),
                                        sizedBoxCustom(7),
                                        CommonHelper().paragraphCommon(
                                            asProvider.getString('Your offer') +
                                                ': ${rtlProvider.currency}${provider.jobReqList[i].expectedSalary ?? ''}',
                                            TextAlign.left,
                                            color: cc.primaryColor),
                                      ]),
                                ),
                                PopupMenuButton(
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry>[
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(Duration.zero, () {
                                          Provider.of<JobDetailsService>(
                                                  context,
                                                  listen: false)
                                              .setOrderDetailsLoadingStatus(
                                                  true);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  JobDetailsPage(
                                                imageLink: provider
                                                        .jobReqList[i]
                                                        .jobImage ??
                                                    '',
                                                isFromNewJobPage: false,
                                                jobId: provider
                                                    .jobReqList[i].job.id,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Text(
                                          asProvider.getString(menuNames[0])),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(Duration.zero, () {
                                          //fetch message
                                          Provider.of<JobConversationService>(
                                                  context,
                                                  listen: false)
                                              .fetchMessages(
                                                  jobRequestId: provider
                                                      .jobReqList[i].id);

                                          print(
                                              'buyer id ${provider.jobReqList[i].buyerId}');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  JobConversationPage(
                                                title: provider
                                                    .jobReqList[i].job.title,
                                                jobRequestId:
                                                    provider.jobReqList[i].id,
                                                buyerId: provider
                                                    .jobReqList[i].buyerId,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Text(
                                          asProvider.getString(menuNames[1])),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )),
        ),
        footer: commonRefreshFooter(context),
      ),
    );
  }
}

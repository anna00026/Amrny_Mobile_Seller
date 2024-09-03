import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:amrny_seller/services/jobs/all_jobs_service.dart';
import 'package:amrny_seller/services/jobs/job_details_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/jobs/job_details_page.dart';

class AllJobsPage extends StatefulWidget {
  const AllJobsPage({Key? key}) : super(key: key);

  @override
  _AllJobsPageState createState() => _AllJobsPageState();
}

class _AllJobsPageState extends State<AllJobsPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('All jobs', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          final result =
              await Provider.of<AllJobsService>(context, listen: false)
                  .fetchAllJobs(context, isrefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<AllJobsService>(context, listen: false)
                  .fetchAllJobs(context);
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
          child: Consumer<AllJobsService>(
            builder: (context, provider, child) => provider
                    .allJobsList.isNotEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < provider.allJobsList.length; i++)
                          InkWell(
                            onTap: () {
                              Provider.of<JobDetailsService>(context,
                                      listen: false)
                                  .setOrderDetailsLoadingStatus(true);

                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      JobDetailsPage(
                                    imageLink: provider.allJobsList[i].imageUrl
                                        .toString(),
                                    isFromNewJobPage: true,
                                    jobId: provider.allJobsList[i].id,
                                    isHired:
                                        provider.allJobsList[i].isHired ?? true,
                                    buttonText:
                                        provider.allJobsList[i].buttonText,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9)),
                              child: Row(
                                children: [
                                  CommonHelper().profileImage(
                                      provider.allJobsList[i].imageUrl
                                          .toString(),
                                      65,
                                      65),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper().titleCommon(
                                              provider.allJobsList[i].title ??
                                                  '',
                                              fontsize: 15),
                                          sizedBoxCustom(8),
                                          CommonHelper().paragraphCommon(
                                              asProvider.getString(
                                                      'Buyer budget') +
                                                  ': ${rtlProvider.currency}${provider.allJobsList[i].price}',
                                              TextAlign.left)
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : OthersHelper().showError(context, message: 'No jobs found'),
          ),
        ),
        footer: commonRefreshFooter(context),
      ),
    );
  }
}

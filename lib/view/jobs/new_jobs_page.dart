import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer_seller/services/jobs/job_details_service.dart';
import 'package:qixer_seller/services/jobs/new_jobs_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/jobs/job_details_page.dart';

class NewJobsPage extends StatefulWidget {
  const NewJobsPage({Key? key}) : super(key: key);

  @override
  _NewJobsPageState createState() => _NewJobsPageState();
}

class _NewJobsPageState extends State<NewJobsPage> {
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
      appBar: CommonHelper().appbarCommon('New jobs', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          final result =
              await Provider.of<NewJobsService>(context, listen: false)
                  .fetchNewJobs(context, isrefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<NewJobsService>(context, listen: false)
                  .fetchNewJobs(context);
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
          child: Consumer<NewJobsService>(
            builder: (context, provider, child) => provider
                    .newJobsList.isNotEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < provider.newJobsList.length; i++)
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
                                    imageLink: provider.imageList[i].toString(),
                                    isFromNewJobPage: true,
                                    jobId: provider.newJobsList[i].id,
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
                                      provider.imageList.length > i
                                          ? provider.imageList[i].toString()
                                          : '',
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
                                              provider.newJobsList[i].title ??
                                                  '',
                                              fontsize: 15),
                                          sizedBoxCustom(8),
                                          CommonHelper().paragraphCommon(
                                              asProvider.getString(
                                                      'Buyer budget') +
                                                  ': ${rtlProvider.currency}${provider.newJobsList[i].price}',
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
                : OthersHelper()
                    .showError(context, message: 'No new jobs found'),
          ),
        ),
        footer: commonRefreshFooter(context),
      ),
    );
  }
}

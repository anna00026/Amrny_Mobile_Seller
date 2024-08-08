import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer_seller/services/employees/employees_service.dart';
import 'package:qixer_seller/services/jobs/job_conversation_service.dart';
import 'package:qixer_seller/services/jobs/job_details_service.dart';
import 'package:qixer_seller/services/jobs/job_list_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/employees/employee_edit.dart';
import 'package:qixer_seller/view/jobs/job_conversation_page.dart';
import 'package:qixer_seller/view/jobs/job_details_page.dart';

class MyEmployeesPage extends StatefulWidget {
  const MyEmployeesPage({super.key});

  @override
  MyEmployeesPageState createState() => MyEmployeesPageState();
}

class MyEmployeesPageState extends State<MyEmployeesPage> {
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
      appBar: CommonHelper().appbarCommon('Employees', context, () {
        Navigator.pop(context);
      }, actions: [
        Container(
          height: 36,
          // width: 140,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => EmployeeEditPage(),
                      ),
                    );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return cc.primaryColor;
              }),
              shape:
                  WidgetStateProperty.resolveWith<OutlinedBorder?>((states) {
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
        )
      ]),
      backgroundColor: cc.bgColor,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<EmployeesService>().currentPage > 1 ? false : true,
        onRefresh: () async {
          final result =
              await Provider.of<EmployeesService>(context, listen: false)
                  .fetchEmployees(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<EmployeesService>(context, listen: false)
                  .fetchEmployees(context);
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
                              message: "You don't have any employees"),
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

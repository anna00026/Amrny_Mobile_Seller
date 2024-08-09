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
    return Consumer<EmployeesService>(
      builder: (context, provider, child) => Scaffold(
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
          footer: commonRefreshFooter(context),
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<EmployeesService>(
                builder: (context, provider, child) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenPadding, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (provider.isLoading == false &&
                              provider.allEmployeesList.isEmpty)
                            OthersHelper().showError(context,
                                message: "You don't have any employees"),
                          for (var employee in provider.allEmployeesList)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        EmployeeEditPage(employee: employee),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9)),
                                child: Row(
                                  children: [
                                    employee.profileImage != null
                                        ? CommonHelper().profileImage(
                                            employee.profileImage!.imgUrl!,
                                            62,
                                            62)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/avatar.png',
                                              height: 62,
                                              width: 62,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonHelper().titleCommon(
                                                employee.userDetails?.name ??
                                                    '',
                                                fontsize: 15),
                                            sizedBoxCustom(8),
                                            Row(
                                              children: [
                                                Icon(Icons.email,
                                                    size: 10,
                                                    color: cc.greyParagraph),
                                                const SizedBox(width: 5.0),
                                                CommonHelper().paragraphCommon(
                                                    employee.userDetails
                                                            ?.email ??
                                                        '',
                                                    TextAlign.left)
                                              ],
                                            ),
                                            sizedBoxCustom(2),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  size: 10,
                                                  color: cc.greyParagraph,
                                                ),
                                                const SizedBox(width: 5.0),
                                                CommonHelper().paragraphCommon(
                                                    employee.userDetails
                                                            ?.phone ??
                                                        '',
                                                    TextAlign.left)
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}

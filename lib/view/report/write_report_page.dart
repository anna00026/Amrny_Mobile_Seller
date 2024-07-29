// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/services/report_services/report_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/profile/components/textarea_field.dart';

class WriteReportPage extends StatefulWidget {
  const WriteReportPage({
    Key? key,
    required this.serviceId,
    required this.orderId,
  }) : super(key: key);

  final serviceId;
  final orderId;
  @override
  State<WriteReportPage> createState() => _WriteReportPageState();
}

class _WriteReportPageState extends State<WriteReportPage> {
  double rating = 1;
  TextEditingController reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Report', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<ProfileService>(
          builder: (context, profileProvider, child) => Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 15,
              ),
              sizedBoxCustom(20),
              Text(
                asProvider.getString('What went wrong?'),
                style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 14,
              ),
              TextareaField(
                notesController: reportController,
                hintText: asProvider.getString('Write the issue'),
              ),
              sizedBoxCustom(20),
              Consumer<ReportService>(
                builder: (context, provider, child) =>
                    CommonHelper().buttonPrimary('Submit Report', () {
                  if (provider.reportLoading == false) {
                    if (reportController.text.trim().isEmpty) {
                      OthersHelper().showToast(
                          'You must write a report to submit', Colors.black);
                      return;
                    }
                    provider.leaveReport(context,
                        message: reportController.text,
                        orderId: widget.orderId,
                        serviceId: widget.serviceId);
                  }
                }, isloading: provider.reportLoading),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

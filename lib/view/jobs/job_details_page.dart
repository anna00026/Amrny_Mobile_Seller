import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/jobs/job_details_service.dart';
import 'package:amrny_seller/services/rtl_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/jobs/components/job_helper.dart';
import 'package:amrny_seller/view/jobs/components/overview_box.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({
    Key? key,
    required this.imageLink,
    required this.jobId,
    required this.isFromNewJobPage,
    this.isHired = true,
    this.buttonText,
  }) : super(key: key);

  final imageLink;
  final jobId;
  final isFromNewJobPage;
  final isHired;
  final buttonText;

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<JobDetailsService>(context, listen: false)
        .fetchJobDetails(widget.jobId, context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final rtlProvider = Provider.of<RtlService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
          child: Consumer<JobDetailsService>(
        builder: (context, provider, child) => provider.loadingOrderDetails ==
                false
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.jobDetails.title.toString(),
                        style: TextStyle(
                            color: cc.greyFour,
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.bold),
                      ),
                      sizedBoxCustom(22),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: 180,
                          width: double.infinity,
                          imageUrl: widget.imageLink.toString(),
                          placeholder: (context, url) =>
                              Image.asset('assets/images/loading_image.png'),
                          errorWidget: (context, url, error) => Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/images/icon.png',
                              color: Colors.white.withOpacity(.5),
                              colorBlendMode: BlendMode.overlay,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      sizedBoxCustom(22),
                      //Name, profile image etc
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     CommonHelper().profileImage(
                      //       userloadingImageUrl,
                      //       55,
                      //       55,
                      //     ),
                      //     const SizedBox(
                      //       width: 16,
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           //name
                      //           CommonHelper()
                      //               .titleCommon('Saleheen', fontsize: 17),
                      //           sizedBoxCustom(7),
                      //           //time and category
                      //           Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.cases_outlined,
                      //                 color: cc.greyParagraph,
                      //                 size: 19,
                      //               ),
                      //               const SizedBox(
                      //                 width: 6,
                      //               ),
                      //               Text(
                      //                 'Total posted: 12',
                      //                 style: TextStyle(
                      //                   color: cc.greyParagraph,
                      //                   fontSize: 13,
                      //                 ),
                      //               ),
                      //               const SizedBox(
                      //                 width: 10,
                      //               ),
                      //               Icon(
                      //                 Icons.calendar_month_outlined,
                      //                 color: cc.greyParagraph,
                      //                 size: 19,
                      //               ),
                      //               const SizedBox(
                      //                 width: 6,
                      //               ),
                      //               Text(
                      //                 '5 days ago',
                      //                 style: TextStyle(
                      //                   color: cc.greyParagraph,
                      //                   fontSize: 13,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // sizedBoxCustom(14),

                      //Overview
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          OverviewBox(
                            title: asProvider.getString('Budget'),
                            subtitle: rtlProvider.currencyDirection == 'left'
                                ? '${rtlProvider.currency}${provider.jobDetails.price}'
                                : '${provider.jobDetails.price}${rtlProvider.currency}',
                          ),

                          OverviewBox(
                            title: asProvider.getString('Deadline'),
                            subtitle:
                                '${getDate(provider.jobDetails.deadLine)}',
                          ),

                          // const OverviewBox(
                          //   title: 'Location',
                          //   subtitle: 'Dhaka, Bangladesh',
                          // ),
                        ],
                      ),

                      sizedBoxCustom(14),

                      //Overview
                      // Row(
                      //   children: [
                      //     OverviewBox(
                      //       title: 'Deadline',
                      //       subtitle:
                      //           '${getDate(provider.jobDetails.deadLine)}',
                      //     ),
                      //     const SizedBox(
                      //       width: 15,
                      //     ),
                      //     // const OverviewBox(
                      //     //   title: 'Category',
                      //     //   subtitle: 'Medical',
                      //     // ),
                      //   ],
                      // ),

                      //Description
                      // ===============>
                      sizedBoxCustom(15),

                      HtmlWidget(provider.jobDetails.description.toString()),

                      sizedBoxCustom(25),
                      if (widget.isFromNewJobPage == true)
                        CommonHelper().buttonPrimary(
                          provider.jobDetailsActionButtonText(context) ??
                              asProvider.getString('Apply'),
                          provider.jobDetailsActionButtonText(context) == null
                              ? () {
                                  JobHelper().applyJobPopup(context);
                                }
                              : () {},
                          bgColor:
                              provider.jobDetailsActionButtonText(context) ==
                                      null
                                  ? cc.primaryColor
                                  : cc.borderColor,
                        ),

                      sizedBoxCustom(20),
                    ]),
              )
            : OthersHelper().showLoading(cc.primaryColor),
      )),
    );
  }
}

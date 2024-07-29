import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/my_services_service.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/my_service/components/my_service_list_appbar.dart';
import 'package:qixer_seller/view/my_service/components/my_services_card.dart';
import 'package:qixer_seller/view/my_service/components/my_services_popup_menu.dart';

class MyServiceListPage extends StatefulWidget {
  const MyServiceListPage({Key? key}) : super(key: key);

  @override
  _MyServiceListPageState createState() => _MyServiceListPageState();
}

class _MyServiceListPageState extends State<MyServiceListPage> {
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MyServiceListAppbar(),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: () async {
            final result =
                await Provider.of<MyServicesService>(context, listen: false)
                    .fetchMyServiceList(context, isrefresh: true);
            if (result) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result =
                await Provider.of<MyServicesService>(context, listen: false)
                    .fetchMyServiceList(context);
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
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                clipBehavior: Clip.none,
                child: Consumer<AppStringService>(
                  builder: (context, asProvider, child) =>
                      Consumer<MyServicesService>(
                          builder:
                              (context, provider, child) =>
                                  provider.hasError == false
                                      ? Column(
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  sizedBoxCustom(10),
                                                  Column(
                                                    children: [
                                                      for (int i = 0;
                                                          i <
                                                              provider
                                                                  .myServiceListMap
                                                                  .length;
                                                          i++)
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            print(
                                                                'service id ${provider.myServiceListMap[i]['serviceId']}');
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 25),
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: cc
                                                                        .borderColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            9)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    13,
                                                                    0,
                                                                    13,
                                                                    4),
                                                            child: Column(
                                                              children: [
                                                                sizedBoxCustom(
                                                                    17),
                                                                MyServicesCardContent(
                                                                  imageLink: provider
                                                                              .imageList[
                                                                          i] ??
                                                                      'loadingImageUrl',
                                                                  title: provider
                                                                          .myServiceListMap[i]
                                                                      ['title'],
                                                                  rating: provider
                                                                      .averageRateList[
                                                                          i]
                                                                      .toStringAsFixed(
                                                                          1),
                                                                  cancelled: provider
                                                                          .myServiceListMap[i]
                                                                      [
                                                                      'cancelled'],
                                                                  completed: provider
                                                                          .myServiceListMap[i]
                                                                      [
                                                                      'completed'],
                                                                  isOnline: provider
                                                                          .myServiceListMap[i]
                                                                      [
                                                                      'isOnline'],
                                                                  queued: provider
                                                                          .myServiceListMap[i]
                                                                      [
                                                                      'queued'],
                                                                  ratingCount:
                                                                      provider
                                                                          .ratingCountList[i],
                                                                  viewCount: provider
                                                                          .myServiceListMap[i]
                                                                      [
                                                                      'viewCount'],
                                                                ),

                                                                //
                                                                const SizedBox(
                                                                  height: 12,
                                                                ),
                                                                CommonHelper()
                                                                    .dividerCommon(),
                                                                sizedBoxCustom(
                                                                    3),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          AutoSizeText(
                                                                            '${asProvider.getString('Starts from')}:',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(
                                                                              color: cc.greyFour.withOpacity(.6),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          Consumer<
                                                                              RtlService>(
                                                                            builder: (context, rtlP, child) =>
                                                                                Expanded(
                                                                              child: AutoSizeText(
                                                                                rtlP.currencyDirection == 'left' ? '${rtlP.currency} ${provider.myServiceListMap[i]['price']}' : '${provider.myServiceListMap[i]['price']} ${rtlP.currency}',
                                                                                textAlign: TextAlign.start,
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  color: cc.greyFour,
                                                                                  fontSize: 19,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    //on off button
                                                                    Row(
                                                                      children: [
                                                                        CommonHelper().paragraphCommon(
                                                                            asProvider.getString('On/Off'),
                                                                            TextAlign.left),
                                                                        Switch(
                                                                          // This bool value toggles the switch.
                                                                          value:
                                                                              provider.myServiceListMap[i]['isServiceOn'],
                                                                          activeColor:
                                                                              cc.successColor,
                                                                          onChanged:
                                                                              (bool value) {
                                                                            provider.serviceOnOff(context,
                                                                                serviceId: provider.myServiceListMap[i]['serviceId']);
                                                                            provider.setActiveStatus(value,
                                                                                i);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),

                                                                    //popup button
                                                                    //==============>
                                                                    MyServicesPopupMenu(
                                                                      serviceId:
                                                                          provider.myServiceListMap[i]
                                                                              [
                                                                              'serviceId'],
                                                                      isOnline: provider.myServiceListMap[i]
                                                                              [
                                                                              'isOnline'] ==
                                                                          "Online",
                                                                      price: provider
                                                                          .myServiceListMap[
                                                                              i]
                                                                              [
                                                                              'price']
                                                                          ?.toString(),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  )

                                                  //
                                                ])
                                          ],
                                        )
                                      : OthersHelper().showError(context,
                                          message: 'No service found')),
                )),
          ),
          footer: commonRefreshFooter(context),
        ),
      ),
    );
  }
}

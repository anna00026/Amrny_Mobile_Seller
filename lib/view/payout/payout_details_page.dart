import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/payout_details_service.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/orders/payment_helper.dart';
import '../../utils/others_helper.dart';

class PayoutDetailsPage extends StatefulWidget {
  const PayoutDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  _OrdersDetailsPageState createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<PayoutDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cc.bgColor,
        appBar: CommonHelper().appbarCommon('Details', context, () {
          Navigator.pop(context);
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<AppStringService>(
              builder: (context, ln, child) => Consumer<PayoutDetailsService>(
                builder: (context, provider, child) => provider.isloading ==
                        false
                    ? provider.payoutDetails != 'error'
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper().titleCommon(
                                              ln.getString(
                                                  'Payout Request Details')),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          //Service row

                                          Container(
                                            child: PaymentHelper().bRow(
                                                'null',
                                                ln.getString('ID'),
                                                provider.payoutDetails
                                                    .payoutDetails.id
                                                    .toString()),
                                          ),

                                          Consumer<RtlService>(
                                            builder: (context, rtlP, child) =>
                                                Container(
                                              child: PaymentHelper().bRow(
                                                  'null',
                                                  ln.getString('Amount'),
                                                  "${rtlP.currency}${provider.payoutDetails.payoutDetails.amount}"),
                                            ),
                                          ),

                                          Container(
                                            child: PaymentHelper().bRow(
                                                'null',
                                                ln.getString('Payment Gateway'),
                                                asProvider.getString(
                                                        removeUnderscore(provider
                                                                .payoutDetails
                                                                .payoutDetails
                                                                .paymentGateway) ??
                                                            '') ??
                                                    ''),
                                          ),

                                          Container(
                                            child: PaymentHelper().bRow(
                                                'null',
                                                ln.getString('Request Date'),
                                                formatDate(provider
                                                    .payoutDetails
                                                    .payoutDetails
                                                    .createdAt)),
                                          ),

                                          Container(
                                            child: PaymentHelper().bRow(
                                                'null',
                                                ln.getString('Seller Note'),
                                                provider
                                                        .payoutDetails
                                                        .payoutDetails
                                                        .sellerNote ??
                                                    ''),
                                          ),

                                          Container(
                                            child: PaymentHelper().bRow(
                                                'null',
                                                ln.getString('Admin Note'),
                                                provider
                                                        .payoutDetails
                                                        .payoutDetails
                                                        .adminNote ??
                                                    '-'),
                                          ),

                                          Container(
                                            child: PaymentHelper().bRow(
                                                'null',
                                                ln.getString('Status'),
                                                provider.payoutDetails
                                                        .payoutDetails.status ??
                                                    '',
                                                lastBorder: false),
                                          ),
                                        ]),
                                  ),
                                  provider.receipt == null
                                      ? Container()
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 25),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(9)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonHelper().titleCommon(ln
                                                  .getString('Payout Receipt')),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              CachedNetworkImage(
                                                imageUrl:
                                                    provider.receipt['img_url'],
                                                placeholder: (context, url) {
                                                  return Image.asset(
                                                      'assets/images/loading_image.png');
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                        )
                                ]),
                          )
                        : CommonHelper().nothingfound(
                            context, ln.getString("No details found"))
                    : Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height - 120,
                        child: OthersHelper().showLoading(cc.primaryColor)),
              ),
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/orders/payment_helper.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  const SubscriptionDetailsPage({Key? key}) : super(key: key);

  @override
  _SubscriptionDetailsPageState createState() =>
      _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Subscription details', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<SubscriptionService>(
          builder: (context, provider, child) => Consumer<SubscriptionService>(
            builder: (context, provider, child) => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonHelper().paragraphCommon(
                      asProvider.getString(
                          'Note: Pending connect will be added to available connect only if the payment status is completed'),
                      TextAlign.left),
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  ),

                  sizedBoxCustom(25),
                  //Title,  type
                  //===================>
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().titleCommon(asProvider.getString('Account Status')),
                          const SizedBox(
                            height: 10,
                          ),
                          //Service row
                          

                          sizedBoxCustom(10),
                          Text(
                            asProvider.getString('Active till') +
                                ': ' +
                                formatDate(provider.subsData.expireDate),
                            style: TextStyle(
                              color: cc.primaryColor,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ]),
                  ),

                  //Connect details
                  //================>
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().titleCommon(
                              asProvider.getString('Connect details')),
                          const SizedBox(
                            height: 25,
                          ),
                          //Service row

                          Container(
                            child: PaymentHelper().bRow(
                                'null',
                                'Available connect',
                                '${provider.subsData.connect}'),
                          ),

                          Container(
                            child: PaymentHelper().bRow(
                                'null',
                                'Pending connect',
                                '${provider.subsData.initialConnect}',
                                lastBorder: false),
                          ),
                        ]),
                  ),

                  //Payment details
                  //================>
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().titleCommon(
                              asProvider.getString('Payment details')),
                          const SizedBox(
                            height: 25,
                          ),
                          //Service row

                          Container(
                            child: PaymentHelper().bRow(
                                'null',
                                'Payment gateway',
                                '${removeUnderscore(provider.subsData.paymentGateway ?? "---")}'),
                          ),

                          Container(
                            child: PaymentHelper().bRow(
                                'null',
                                'Payment status',
                                '${provider.subsData.paymentStatus}',
                                lastBorder: false),
                          ),
                        ]),
                  ),

                  sizedBoxCustom(5),

                  CommonHelper().buttonPrimary(
                      asProvider.getString('Renew Subscription'), () {
                    provider.reniewSubscription(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) => PaymentChoosePage(
                    //       reniewSubscription: true,
                    //       price: provider.subsData.price,
                    //     ),
                    //   ),
                    // );
                  }, isloading: provider.renewLoading)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

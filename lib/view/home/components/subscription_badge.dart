import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/rtl_service.dart';
import 'package:amrny_seller/services/subscription_service.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/subscription/subscription_details_page.dart';

class SubscriptionBadge extends StatelessWidget {
  const SubscriptionBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RtlService>(
      builder: (context, provider, child) => Consumer<SubscriptionService>(
        builder: (context, provider, child) => provider.subsData != null &&
                provider.showSubscription
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const SubscriptionDetailsPage(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asProvider.getString('Account Status'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            sizedBoxCustom(6),
                            Text(
                              asProvider.getString('Active till') +
                                  ': ' +
                                  formatDate(provider.subsData.expireDate),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}

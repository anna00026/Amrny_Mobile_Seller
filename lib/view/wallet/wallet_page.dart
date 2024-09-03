import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/wallet_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/payments/payment_choose_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WalletService>(context, listen: false)
        .fetchWalletHistory(context);
    Provider.of<WalletService>(context, listen: false)
        .fetchWalletBalance(context);
  }

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Wallet', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<WalletService>(
              builder: (context, provider, child) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              decoration: BoxDecoration(
                                  color: cc.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      provider.walletBalance,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    AutoSizeText(
                                      ln.getString('Balance'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    )
                                  ]),
                            ),
                            const SizedBox(
                              width: 20,
                            ),

                            // add money
                            //==========>

                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        PaymentChoosePage(
                                      isFromDepositeToWallet: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(.6),
                                        width: 1)),
                                child: Icon(
                                  Icons.add,
                                  size: 35,
                                  color: cc.greyParagraph,
                                ),
                              ),
                            )
                          ],
                        ),

                        sizedBoxCustom(22),

                        // History
                        // ===========>

                        provider.hasWalletHistory == true
                            ? provider.walletHistory != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonHelper().titleCommon(
                                          asProvider.getString('History')),
                                      sizedBoxCustom(17),
                                      for (int i = 0;
                                          i < provider.walletHistory.length;
                                          i++)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 16),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(9)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CommonHelper().titleCommon(
                                                          'ID: #${provider.walletHistory[i].id}',
                                                          fontsize: 15,
                                                          color:
                                                              cc.primaryColor),
                                                      sizedBoxCustom(5),
                                                      Wrap(
                                                        spacing: 12,
                                                        runSpacing: 12,
                                                        children: [
                                                          Text(
                                                            asProvider.getString(
                                                                    "Gateway") +
                                                                ": ${asProvider.getString(removeUnderscore(provider.walletHistory[i].paymentGateway))}.",
                                                            style: TextStyle(
                                                              color:
                                                                  cc.greyFour,
                                                              fontSize: 14,
                                                              height: 1.4,
                                                            ),
                                                          ),
                                                          Text(
                                                            asProvider.getString(
                                                                    "Amount") +
                                                                ": ${rtlProvider.currency}${provider.walletHistory[i].amount}.",
                                                            style: TextStyle(
                                                              color:
                                                                  cc.greyFour,
                                                              fontSize: 14,
                                                              height: 1.4,
                                                            ),
                                                          ),
                                                          Text(
                                                            asProvider.getString(
                                                                    "Payment Status") +
                                                                ": ${provider.walletHistory[i].paymentStatus}.",
                                                            style: TextStyle(
                                                              color:
                                                                  cc.greyFour,
                                                              fontSize: 14,
                                                              height: 1.4,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                              // Icon(
                                              //   Icons.arrow_forward_ios,
                                              //   size: 16,
                                              //   color: cc.greyFour,
                                              // )
                                            ],
                                          ),
                                        ),
                                    ],
                                  )
                                : Container(
                                    height: screenHeight(context) - 280,
                                    alignment: Alignment.center,
                                    child: OthersHelper()
                                        .showLoading(cc.primaryColor),
                                  )
                            : Container(
                                height: screenHeight(context) - 280,
                                alignment: Alignment.center,
                                child: Text(
                                    asProvider.getString('No history found')),
                              ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}

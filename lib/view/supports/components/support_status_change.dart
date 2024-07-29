import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/ticket_services/support_ticket_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/others_helper.dart';

class SupportStatusChange extends StatelessWidget {
  const SupportStatusChange({Key? key, required this.ticketId})
      : super(key: key);

  final ticketId;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<SupportTicketService>(
        builder: (context, provider, child) => SizedBox(
          height: 115,
          child: provider.isloading == false
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  //Open
                  InkWell(
                    onTap: () {
                      provider.changeStatus(ticketId, 'open', context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: Text(
                        ln.getString("Open"),
                        style: TextStyle(
                            color: cc.greyThree,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ),
                  ),
                  CommonHelper().dividerCommon(),

                  //close
                  InkWell(
                    onTap: () {
                      provider.changeStatus(ticketId, 'close', context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: Text(
                        ln.getString("Close"),
                        style: TextStyle(
                            color: cc.warningColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ),
                  ),
                ])
              : Container(
                  child: OthersHelper().showLoading(cc.primaryColor),
                ),
        ),
      ),
    );
  }
}

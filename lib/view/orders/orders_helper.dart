import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/order_details_service.dart';
import 'package:amrny_seller/services/orders_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/view/orders/components/add_extras_popup.dart';
import 'package:amrny_seller/view/report/write_report_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrdersHelper {
  List ordersPopupMenuList = [
    'Cancel order',
    'Report to admin',
  ];

  navigateMyOrders(BuildContext context,
      {required index, required serviceId, required orderId}) {
    if (index == 0) {
      OrdersHelper().cancelOrderPopup(context, orderId: orderId);
    } else if (index == 1) {
      return Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => WriteReportPage(
            serviceId: serviceId,
            orderId: orderId,
          ),
        ),
      );
    }
  }

  //=======>
  ConstantColors cc = ConstantColors();
  statusCapsule(String capsuleText, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
      decoration: BoxDecoration(
          color: color.withOpacity(.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        capsuleText,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  statusCapsuleBordered(String capsuleText, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: cc.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        capsuleText,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  ///
  orderRow(String icon, String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //icon
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: Row(children: [
            SvgPicture.asset(
              icon,
              height: 19,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              title,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ]),
        ),

        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  //Add extras popup
  // ===========>

  addExtraPopup(BuildContext context, orderId) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: AddExtrasPopup(
            orderId: orderId,
          ),
        )).show();
  }

// ==================>
//
  deleteExtraPopup(BuildContext context, {required extraId, required orderId}) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) => Column(
              children: [
                Text(
                  '${asProvider.getString('Are you sure?')}',
                  style: TextStyle(color: cc.greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CommonHelper().borderButtonPrimary(
                            asProvider.getString('Cancel'), () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<OrderDetailsService>(
                      builder: (context, provider, child) => Expanded(
                          child: CommonHelper().buttonPrimary(
                              asProvider.getString('Delete'), () {
                        if (provider.isLoading == false) {
                          provider.deleteOrderExtra(context,
                              extraId: extraId, orderId: orderId);
                        }
                      }, isloading: provider.deleteLoading)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }

  // ==================>
//
  makePaymentCompletePopup(BuildContext context, {required orderId}) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) => Column(
              children: [
                Text(
                  '${asProvider.getString('Are you sure?')}',
                  style: TextStyle(color: cc.greyPrimary, fontSize: 17),
                ),
                sizedBoxCustom(35),
                Row(
                  children: [
                    Expanded(
                        child: CommonHelper().borderButtonPrimary(
                            asProvider.getString('Cancel'), () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<OrdersService>(
                      builder: (context, provider, child) => Expanded(
                          child: CommonHelper()
                              .buttonPrimary(asProvider.getString('Yes'), () {
                        if (provider.payLoadingStatus == false) {
                          provider.makePaymentStatusComplete(context,
                              orderId: orderId);
                        }
                      }, isloading: provider.payLoadingStatus)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }

  //

  //cancel order popup
  //============>

  cancelOrderPopup(BuildContext context, {required orderId}) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) => Column(
              children: [
                Text(
                  '${asProvider.getString('Are you sure?')}',
                  style: TextStyle(color: cc.greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CommonHelper().borderButtonPrimary(
                            asProvider.getString('No'), () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<OrdersService>(
                      builder: (context, provider, child) => Expanded(
                          child: CommonHelper()
                              .buttonPrimary(asProvider.getString('Yes'), () {
                        if (provider.cancelLoading == false) {
                          provider.cancelOrder(context, orderId: orderId);
                        }
                      }, isloading: provider.cancelLoading)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }
}

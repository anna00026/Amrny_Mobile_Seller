import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/my_services/attribute_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AttributeHelper {
  final cc = ConstantColors();

  deleteAttributePopup(
    BuildContext context, {
    required attributeId,
    required serviceId,
    bool deleteInclude = false,
    bool deleteAdditional = false,
    bool deleteBenefit = false,
  }) {
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
                            asProvider.getString('Cancel'), () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<AttributeService>(
                      builder: (context, provider, child) => Expanded(
                          child: CommonHelper().buttonPrimary(
                              asProvider.getString('Delete'), () {
                        provider.deleteAttribute(context,
                            attributeId: attributeId,
                            serviceId: serviceId,
                            deleteInclude: deleteInclude,
                            deleteAdditional: deleteAdditional,
                            deleteBenefit: deleteBenefit);
                      }, isloading: provider.deleteAttrLoading)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }
}

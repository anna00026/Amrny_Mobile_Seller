// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/view/my_service/components/attributes/attribute_helper.dart';

import '../../../../utils/responsive.dart';

class ShowAttributeRow extends StatelessWidget {
  const ShowAttributeRow({
    Key? key,
    required this.title,
    required this.price,
    required this.qty,
    required this.attrId,
    this.isServiceBenefit = false,
    this.deleteInclude = false,
    this.deleteAdditional = false,
    this.deleteBenefit = false,
    required this.serviceId,
  }) : super(key: key);

  final title;
  final price;
  final qty;
  final attrId;
  final bool isServiceBenefit;
  final serviceId;

  final bool deleteInclude;
  final bool deleteAdditional;
  final bool deleteBenefit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonHelper().titleCommon(title, fontsize: 14),
              ),

              // delete button

              InkWell(
                onTap: () {
                  AttributeHelper().deleteAttributePopup(context,
                      attributeId: attrId,
                      serviceId: serviceId,
                      deleteBenefit: deleteBenefit,
                      deleteAdditional: deleteAdditional,
                      deleteInclude: deleteInclude);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
          if (!isServiceBenefit)
            Row(
              children: [
                if (price != 0)
                  CommonHelper().paragraphCommon(
                      asProvider.getString("Unit price") +
                          ': ${rtlProvider.currency}$price',
                      TextAlign.left),
                const SizedBox(
                  width: 10,
                ),
                if (qty != 0)
                  CommonHelper().paragraphCommon(
                      asProvider.getString("Quantity") + ': $qty',
                      TextAlign.left),
              ],
            ),
          sizedBoxCustom(15)
        ])
      ],
    );
  }
}

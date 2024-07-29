import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/my_services/attribute_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/my_service/components/attributes/show_attribute_row.dart';

class ShowAttributePage extends StatefulWidget {
  const ShowAttributePage({Key? key, required this.serviceId})
      : super(key: key);

  final serviceId;

  @override
  _ShowAttributePageState createState() => _ShowAttributePageState();
}

class _ShowAttributePageState extends State<ShowAttributePage> {
  @override
  void initState() {
    super.initState();
  }

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Service attributes', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<AppStringService>(
          builder: (context, asProvider, child) => Container(
            padding:
                EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
            child: Consumer<AttributeService>(
                builder: (context, provider, child) => provider.attrLoading ==
                        false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //========================>
                          //include service
                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper().titleCommon(asProvider
                                    .getString('Include Service Attributes')),
                                //
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                if (provider.attributes.includeServices.isEmpty)
                                  CommonHelper().paragraphCommon(
                                      asProvider.getString(
                                          'No include service found'),
                                      TextAlign.left),

                                for (int i = 0;
                                    i <
                                        provider
                                            .attributes.includeServices.length;
                                    i++)
                                  ShowAttributeRow(
                                      serviceId: widget.serviceId,
                                      deleteInclude: true,
                                      attrId: provider
                                          .attributes.includeServices[i].id,
                                      title: provider
                                          .attributes
                                          .includeServices[i]
                                          .includeServiceTitle,
                                      price: provider
                                          .attributes
                                          .includeServices[i]
                                          .includeServicePrice,
                                      qty: provider
                                          .attributes
                                          .includeServices[i]
                                          .includeServiceQuantity)
                              ],
                            ),
                          ),

                          //========================>
                          //additional service

                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper().titleCommon(asProvider.getString(
                                    'Additional Service Attributes')),
                                //
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                if (provider
                                    .attributes.additionalService.isEmpty)
                                  CommonHelper().paragraphCommon(
                                      asProvider.getString(
                                          'No additional service found'),
                                      TextAlign.left),

                                for (int i = 0;
                                    i <
                                        provider.attributes.additionalService
                                            .length;
                                    i++)
                                  ShowAttributeRow(
                                      deleteAdditional: true,
                                      serviceId: widget.serviceId,
                                      attrId: provider
                                          .attributes.additionalService[i].id,
                                      title: provider
                                          .attributes
                                          .additionalService[i]
                                          .additionalServiceTitle,
                                      price: provider
                                          .attributes
                                          .additionalService[i]
                                          .additionalServicePrice,
                                      qty: provider
                                          .attributes
                                          .additionalService[i]
                                          .additionalServiceQuantity)
                              ],
                            ),
                          ),

                          //========================>
                          //additional service

                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper().titleCommon(
                                    asProvider.getString('Service Benefit')),
                                //
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                if (provider.attributes.serviceBenifit.isEmpty)
                                  CommonHelper().paragraphCommon(
                                      asProvider.getString(
                                          'No service benefit found'),
                                      TextAlign.left),

                                for (int i = 0;
                                    i <
                                        provider
                                            .attributes.serviceBenifit.length;
                                    i++)
                                  ShowAttributeRow(
                                      deleteBenefit: true,
                                      serviceId: widget.serviceId,
                                      attrId: provider
                                          .attributes.serviceBenifit[i].id,
                                      title: provider.attributes
                                          .serviceBenifit[i].benifits,
                                      isServiceBenefit: true,
                                      price: 0,
                                      qty: 0)
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        height: screenHeight(context) - 120,
                        alignment: Alignment.center,
                        child: OthersHelper().showLoading(cc.primaryColor),
                      )),
          ),
        ),
      ),
    );
  }
}

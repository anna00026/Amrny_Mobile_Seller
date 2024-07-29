import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/my_services/attribute_service.dart';
import 'package:qixer_seller/services/my_services/edit_attribute_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/my_service/components/edit_attribute/edit_additional.dart';
import 'package:qixer_seller/view/my_service/components/edit_attribute/edit_benefits_of_package.dart';
import 'package:qixer_seller/view/my_service/components/edit_attribute/edit_faq_for_service_create.dart';
import 'package:qixer_seller/view/my_service/components/edit_attribute/edit_package_included.dart';

class EditAttributePage extends StatefulWidget {
  const EditAttributePage({Key? key, this.serviceId, required this.isOnline})
      : super(key: key);

  final serviceId;
  final bool isOnline;

  @override
  _EditAttributePageState createState() => _EditAttributePageState();
}

class _EditAttributePageState extends State<EditAttributePage> {
  @override
  void initState() {
    super.initState();

    loadAttribute();
  }

  loadAttribute() async {
    await Provider.of<AttributeService>(context, listen: false)
        .loadAttributes(context, serviceId: widget.serviceId);

    Provider.of<EditAttributeService>(context, listen: false)
        .fillAttributes(context);
  }

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Edit attributes', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<AttributeService>(
          builder: (context, provider, child) => Consumer<EditAttributeService>(
            builder: (context, editProvider, child) =>
                Consumer<AppStringService>(
              builder: (context, asProvider, child) =>
                  provider.attrLoading == false
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenPadding, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EditPackageIncluded(isOnline: widget.isOnline),
                              const EditAdditional(),
                              sizedBoxCustom(15),
                              const EditBenefitsOfPackage(),
                              const EditFaqForServiceCreate(),
                              sizedBoxCustom(10),
                              CommonHelper().buttonPrimary('Edit', () {
                                editProvider.editAttribute(context,
                                    serviceId: widget.serviceId);
                              }, isloading: editProvider.editAttrLoading),
                              sizedBoxCustom(40)
                            ],
                          ),
                        )
                      : Container(
                          height: screenHeight(context) - 120,
                          alignment: Alignment.center,
                          child: OthersHelper().showLoading(cc.primaryColor),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}

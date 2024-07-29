import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/attribute_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/view/my_service/components/attributes/add_additional.dart';
import 'package:qixer_seller/view/my_service/components/attributes/add_package_included.dart';
import 'package:qixer_seller/view/my_service/components/attributes/benefits_of_package.dart';
import 'package:qixer_seller/view/my_service/components/attributes/faq_for_service_create.dart';

class AddAttributePage extends StatefulWidget {
  const AddAttributePage({
    Key? key,
    required this.serviceId,
    this.isFromCreateService = false,
  }) : super(key: key);

  final serviceId;
  final bool isFromCreateService;

  @override
  _AddAttributePageState createState() => _AddAttributePageState();
}

class _AddAttributePageState extends State<AddAttributePage> {
  @override
  void initState() {
    super.initState();
  }

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Add attributes', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: cc.bgColor,
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<AttributeService>(
          builder: (context, provider, child) => Consumer<AppStringService>(
            builder: (context, asProvider, child) => Container(
              padding:
                  EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AddPackageIncluded(),
                  const AddAdditional(),
                  sizedBoxCustom(15),
                  const BenefitsOfPackage(),
                  const FaqForServiceCreate(),
                  sizedBoxCustom(10),
                  CommonHelper().buttonPrimary(asProvider.getString('Save'),
                      () {
                    provider.addAttribute(context,
                        serviceId: widget.serviceId,
                        isFromServiceCreatePage: widget.isFromCreateService);
                  }, isloading: provider.addAttrLoading),
                  sizedBoxCustom(40)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/edit_attribute_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/custom_input.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';

class EditBenefitsOfPackage extends StatefulWidget {
  const EditBenefitsOfPackage({Key? key}) : super(key: key);

  @override
  State<EditBenefitsOfPackage> createState() => _EditBenefitsOfPackageState();
}

class _EditBenefitsOfPackageState extends State<EditBenefitsOfPackage> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<EditAttributeService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHelper().titleCommon('Benefit Of This Package', fontsize: 18),

            sizedBoxCustom(18),

            CustomInput(
              controller: titleController,
              paddingHorizontal: 15,
              hintText: asProvider.getString("Type here"),
              textInputAction: TextInputAction.next,
            ),

            //Add button
            //=========>
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (titleController.text.trim().isEmpty) {
                      OthersHelper().showSnackBar(
                          context,
                          ln.getString('Please type something first'),
                          Colors.red);
                      return;
                    }
                    provider.addBenefits(titleController.text);

                    //clear
                    titleController.clear();
                  },
                  child: Container(
                    color: cc.primaryColor,
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            sizedBoxCustom(10),

            //
            //--------->
            if (provider.benefitsList.isNotEmpty)
              Column(
                children: [
                  ListView.builder(
                      itemCount: provider.benefitsList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(.2),
                              width: 1.0,
                            ),
                          )),
                          child: Row(
                            children: [
                              Expanded(
                                child: CommonHelper().labelCommon(
                                    provider.benefitsList[index]['title'],
                                    marginBotton: 0),
                              ),

                              //icon
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: InkWell(
                                  onTap: () {
                                    provider.removeBenefits(index);
                                  },
                                  child: const Icon(
                                    Icons.delete_forever,
                                    size: 27,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                  sizedBoxCustom(20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

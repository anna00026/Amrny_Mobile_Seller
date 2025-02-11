import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/my_services/edit_attribute_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/custom_input.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';

class EditFaqForServiceCreate extends StatefulWidget {
  const EditFaqForServiceCreate({Key? key}) : super(key: key);

  @override
  State<EditFaqForServiceCreate> createState() =>
      _EditFaqForServiceCreateState();
}

class _EditFaqForServiceCreateState extends State<EditFaqForServiceCreate> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<EditAttributeService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHelper().titleCommon('Faqs', fontsize: 18),

            sizedBoxCustom(18),
            CommonHelper().labelCommon("Faq title"),
            CustomInput(
              controller: titleController,
              paddingHorizontal: 15,
              hintText: asProvider.getString("Enter title"),
              textInputAction: TextInputAction.next,
            ),

            CommonHelper().labelCommon("Faq answer"),
            CustomInput(
              controller: descController,
              paddingHorizontal: 15,
              hintText: asProvider.getString("Enter answer"),
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
                    provider.addFaq(titleController.text, descController.text);

                    //clear
                    titleController.clear();
                    descController.clear();
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
            if (provider.faqList.isNotEmpty)
              Column(
                children: [
                  ListView.builder(
                      itemCount: provider.faqList.length,
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
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonHelper().labelCommon(
                                      provider.faqList[index]['title'],
                                      marginBotton: 1),
                                  CommonHelper().paragraphCommon(
                                      provider.faqList[index]['desc'],
                                      TextAlign.left),
                                ],
                              )),

                              //icon
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: InkWell(
                                  onTap: () {
                                    provider.removeFaq(index);
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/attribute_service.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/custom_input.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';

class AddPackageIncluded extends StatefulWidget {
  const AddPackageIncluded({Key? key}) : super(key: key);

  @override
  State<AddPackageIncluded> createState() => _AddPackageIncludedState();
}

class _AddPackageIncludedState extends State<AddPackageIncluded> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();

  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final rtlProvider = Provider.of<RtlService>(context, listen: false);
    return Consumer<AttributeService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //on off button
            Row(
              children: [
                CommonHelper().paragraphCommon(
                    asProvider.getString('Online service'), TextAlign.left),
                Switch(
                  // This bool value toggles the switch.
                  value: isOnline,
                  activeColor: cc.successColor,
                  onChanged: (bool value) {
                    isOnline = !isOnline;
                    provider.setIsOnline(isOnline);
                    setState(() {});
                  },
                ),
              ],
            ),

            sizedBoxCustom(5),

            CommonHelper().titleCommon(
                asProvider.getString('What is Included In This Package'),
                fontsize: 18),

            sizedBoxCustom(18),
            CommonHelper().labelCommon(asProvider.getString("Title")),
            CustomInput(
              controller: titleController,
              paddingHorizontal: 15,
              hintText: asProvider.getString("Enter title"),
              textInputAction: TextInputAction.next,
            ),

            if (!isOnline)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHelper().labelCommon(asProvider.getString("Price")),
                  CustomInput(
                    controller: priceController,
                    paddingHorizontal: 15,
                    hintText: asProvider.getString("Enter price"),
                    isNumberField: true,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),

            //Add faq button
            //=========>
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (titleController.text.trim().isEmpty) {
                      OthersHelper().showSnackBar(context,
                          ln.getString('Please enter a title'), Colors.red);
                      return;
                    }
                    if (priceController.text.trim().isEmpty && !isOnline) {
                      OthersHelper().showSnackBar(context,
                          ln.getString('Please enter a price'), Colors.red);
                      return;
                    }

                    provider.addIncludedList(titleController.text,
                        !isOnline ? priceController.text : '0');

                    //clear
                    titleController.clear();
                    priceController.clear();
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
            if (provider.includedList.isNotEmpty)
              Column(
                children: [
                  ListView.builder(
                      itemCount: provider.includedList.length,
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
                                      provider.includedList[index]['title'],
                                      marginBotton: 0),
                                  if (!isOnline)
                                    CommonHelper().paragraphCommon(
                                        rtlProvider.currencyDirection == 'left'
                                            ? "${rtlProvider.currency}${provider.includedList[index]['price']}"
                                            : "${provider.includedList[index]['price']}${rtlProvider.currency}",
                                        TextAlign.left)
                                ],
                              )),

                              //icon
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: InkWell(
                                  onTap: () {
                                    provider.removeIncludedList(index);
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
            if (isOnline)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHelper().labelCommon(asProvider.getString("Duration")),
                  CustomInput(
                    initialValue: provider.onlineServiceDuration?.toString(),
                    paddingHorizontal: 15,
                    hintText: asProvider.getString("Enter service duration"),
                    isNumberField: true,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      final numValue = num.tryParse(value.toString()) ?? 0;
                      provider.setOnlineServiceDuration(numValue);
                    },
                    validation: (value) {
                      final numValue = num.tryParse(value.toString()) ?? 0;
                      if (numValue < 0) {
                        return "Enter a valid duration.";
                      }
                      return null;
                    },
                  ),
                  CommonHelper().labelCommon(asProvider.getString("Revision")),
                  CustomInput(
                    initialValue: provider.onlineServiceRevisions?.toString(),
                    paddingHorizontal: 15,
                    hintText: asProvider.getString("Enter revision times"),
                    isNumberField: true,
                    textInputAction: TextInputAction.next,
                  ),
                  CommonHelper().labelCommon(asProvider.getString("Price")),
                  CustomInput(
                    initialValue: provider.onlineServicePrice?.toString(),
                    paddingHorizontal: 15,
                    hintText: asProvider.getString("Enter service price"),
                    isNumberField: true,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      final numValue = num.tryParse(value.toString()) ?? 0;
                      provider.setOnlineServicePrice(numValue);
                    },
                    validation: (value) {
                      final numValue = num.tryParse(value.toString()) ?? 0;
                      if (numValue < 0) {
                        return "Enter a valid price.";
                      }
                      return null;
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

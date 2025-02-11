import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/cat_subcat_dropdown_service_for_edit_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';

class CategoryDropdownForEditService extends StatefulWidget {
  const CategoryDropdownForEditService({Key? key}) : super(key: key);

  @override
  State<CategoryDropdownForEditService> createState() =>
      _CategoryDropdownForEditServiceState();
}

class _CategoryDropdownForEditServiceState
    extends State<CategoryDropdownForEditService> {
  @override
  void initState() {
    super.initState();

    fetch();
  }

  fetch() {
    // Future.delayed(const Duration(microseconds: 500), () {
    //   Provider.of<CatSubcatDropdownServiceForEditService>(context,
    //           listen: false)
    //       .fetchCategoryForEditService();
    // });
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Consumer<CatSubcatDropdownServiceForEditService>(
        builder: (context, provider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHelper().labelCommon(asProvider.getString("Category")),
                provider.categoryDropdownList.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: cc.greyFive),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            // menuMaxHeight: 200,
                            isExpanded: true,
                            value: provider.selectedCategory,
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: cc.greyFour),
                            iconSize: 26,
                            elevation: 17,
                            style: TextStyle(color: cc.greyFour),
                            onChanged: (newValue) {
                              provider.setCategoryValue(newValue);

                              //setting the id of selected value
                              provider.setSelectedCategoryId(
                                  provider.categoryDropdownIndexList[provider
                                      .categoryDropdownList
                                      .indexOf(newValue!)]);

                              provider.fetchSubCategoryForEditService();
                            },
                            items: provider.categoryDropdownList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: cc.greyPrimary.withOpacity(.8)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [OthersHelper().showLoading(cc.primaryColor)],
                      ),
              ],
            ));
  }
}

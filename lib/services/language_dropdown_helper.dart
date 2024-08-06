import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';

class LanguageDropdownHelper {
  //language dropdown
  languageDropdown(cc, BuildContext context) {
    Provider.of<AppStringService>(context, listen: false).getCurrentLangauge();
    return Consumer<AppStringService>(
      builder: (context, provider, child) =>
          provider.languageDropdownList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().labelCommon("Language"),
                    Container(
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
                          value: provider.currentLanguage,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: cc.greyFour),
                          iconSize: 26,
                          elevation: 17,
                          style: TextStyle(color: cc.greyFour),
                          onChanged: (newValue) {
                            //setting the id of selected value
                            provider.setCurrentLangauge(context, newValue!);
                          },
                          items: provider.languageDropdownList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                asProvider.getString(value),
                                style: TextStyle(
                                    color: cc.greyPrimary.withOpacity(.8)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [OthersHelper().showLoading(cc.primaryColor)],
                ),
    );
  }
}

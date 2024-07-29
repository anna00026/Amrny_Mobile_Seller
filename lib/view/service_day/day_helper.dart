import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../services/day_schedule_service/day_service.dart';
import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';
import '../../utils/constant_styles.dart';
import '../../utils/others_helper.dart';
import '../../utils/responsive.dart';

showCreateDayDialogue(BuildContext context) {
  ConstantColors cc = ConstantColors();
  Provider.of<DayService>(context, listen: false).fetchDynamicDays(context);
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          buttonPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxCustom(10),
                CommonHelper().labelCommon(asProvider.getString("Choose day")),
                Consumer<DayService>(builder: (context, dProvider, child) {
                  print(dProvider.daysList);
                  return !dProvider.dynamicDayLoading
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
                              // isExpanded: true,
                              hint: Text(
                                asProvider.getString("Choose day"),
                                style: TextStyle(color: cc.greyFour),
                              ),
                              value: dProvider.selectedDay,
                              icon: Icon(Icons.keyboard_arrow_down_rounded,
                                  color: cc.greyFour),
                              iconSize: 26,
                              elevation: 17,
                              style: TextStyle(color: cc.greyFour),
                              onChanged: (newValue) {
                                dProvider.setSelectedDay(newValue);
                              },
                              items: (dProvider.daysList.isEmpty
                                      ? [
                                          "Sat",
                                          "Sun",
                                          "Mon",
                                          "Tue",
                                          "Wed",
                                          "Thu",
                                          "Fri"
                                        ]
                                      : dProvider.daysList)
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OthersHelper().showLoading(cc.primaryColor)
                          ],
                        );
                })
              ],
            ),
          ),
          actions: [
            Consumer<DayService>(builder: (context, dProvider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: CommonHelper()
                    .buttonPrimary(asProvider.getString('Add Day'), () async {
                  await dProvider.createNewDay(context);
                }, isloading: dProvider.creatingDayLoading),
              );
            })
          ],
        );
      });
}

showDeleteDialogue(BuildContext context, {id}) async {
  ConstantColors cc = ConstantColors();
  TextEditingController scheduleController = TextEditingController();
  await Alert(
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
        child: Consumer<DayService>(
          builder: (context, provider, child) => Column(
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
                  Expanded(
                      child: CommonHelper()
                          .buttonPrimary(asProvider.getString('Delete'), () {
                    provider.deleteSellerDay(context, id);
                  },
                              bgColor: Colors.red,
                              isloading: provider.deletingDayLoading))
                ],
              )
            ],
          ),
        ),
      )).show();
}

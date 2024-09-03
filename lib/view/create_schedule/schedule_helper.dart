import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/day_schedule_service/schedule_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../services/app_string_service.dart';
import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';
import '../../utils/constant_styles.dart';
import '../../utils/custom_input.dart';
import '../../utils/others_helper.dart';
import '../../utils/responsive.dart';

showCreateScheduleDialogue(BuildContext context, {schedule, dayId, id}) {
  ConstantColors cc = ConstantColors();
  TextEditingController scheduleController = TextEditingController();
  scheduleController.text = schedule ?? '';
  final sProvider = Provider.of<ScheduleService>(context, listen: false);
  try {
    var day = sProvider.schedulesList?.days?.firstWhere((element) {
      return element.id.toString() == dayId.toString();
    });
    sProvider.setSelectedDay(day);
  } catch (e) {
    sProvider.setSelectedDay(null);
  }

  print(sProvider.schedulesList?.days);
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          buttonPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 416,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                // physics: const NeverScrollableScrollPhysics(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBoxCustom(10),
                  CommonHelper()
                      .labelCommon(asProvider.getString("Choose day")),
                  Consumer<ScheduleService>(
                      builder: (context, sProvider, child) {
                    return sProvider.schedulesList != null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: cc.greyFive),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  asProvider.getString("Choose day"),
                                  style: TextStyle(color: cc.greyFour),
                                ),
                                // menuMaxHeight: 200,
                                // isExpanded: true,
                                value: sProvider.schedulesList?.days == null
                                    ? null
                                    : sProvider.selectedDay,
                                icon: Icon(Icons.keyboard_arrow_down_rounded,
                                    color: cc.greyFour),
                                iconSize: 26,
                                elevation: 17,
                                style: TextStyle(color: cc.greyFour),
                                onChanged: (newValue) {
                                  print(newValue);
                                  sProvider.setSelectedDay(newValue);
                                  // provider.setAreaValue(newValue);
                                  // //setting the id of selected value
                                  // provider.setSelectedAreaId(
                                  //     provider.areaDropdownIndexList[provider
                                  //         .areaDropdownList
                                  //         .indexOf(newValue)]);
                                },
                                items:
                                    sProvider.schedulesList!.days!.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      asProvider.getString(
                                          (value.day ?? '').capitalize()),
                                      style: TextStyle(
                                          color:
                                              cc.greyPrimary.withOpacity(.8)),
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
                  }),
                  const SizedBox(height: 8),
                  if (dayId == null)
                    Consumer<ScheduleService>(
                        builder: (context, sProvider, child) {
                      return CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: ConstantColors().primaryColor,
                        contentPadding: const EdgeInsets.all(0),
                        title: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            asProvider.getString(
                                'Add this schedule time for all days.'),
                            style: TextStyle(
                                color: ConstantColors().greyFour,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                        value: sProvider.scheduleForAllDay,
                        onChanged: (value) {
                          sProvider.setScheduleForAllDay(value);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),
                  const SizedBox(height: 8),
                  CommonHelper().labelCommon(asProvider.getString("Full name")),
                  CustomInput(
                    controller: scheduleController,
                    hintText: asProvider.getString("Enter schedule"),
                    icon: 'assets/icons/user.png',
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      Provider.of<ScheduleService>(context, listen: false)
                          .setSelectedSchedule(value);
                    },
                  ),
                  CommonHelper().paragraphCommon(
                      asProvider.getString(
                          "eg: 10:00Am - 11:00PM, this schedule time will show in frontend, when anyone want to book your service, they will select this schedule time made by you"),
                      TextAlign.start,
                      color: cc.greyFour)
                ],
              ),
            ),
          ),
          actions: [
            Consumer<ScheduleService>(builder: (context, sProvider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: CommonHelper().buttonPrimary(
                    asProvider.getString(
                        dayId != null ? 'Update Schedule' : 'Add Schedule'),
                    () {
                  if (dayId == null) {
                    sProvider.createNewSchedule(
                        context, scheduleController.text);
                  } else {
                    sProvider.updateNewSchedule(
                        context, scheduleController.text, id);
                  }
                }, isloading: sProvider.creatingScheduleLoading),
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
        child: Consumer<AppStringService>(
          builder: (context, asProvider, child) => Consumer<ScheduleService>(
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
                      provider.deleteSchedule(context, id);
                    },
                                bgColor: Colors.red,
                                isloading: provider.deletingScheduleLoading))
                  ],
                )
              ],
            ),
          ),
        ),
      )).show();
}

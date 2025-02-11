import 'package:flutter/material.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/others_helper.dart';

import '../../utils/responsive.dart';
import 'schedule_helper.dart';

class ScheduleCard extends StatelessWidget {
  var scheduleId;
  String? dayTitle;
  String? scheduleTitle;
  var dayId;

  ScheduleCard(
      {this.dayTitle,
      this.scheduleId,
      this.scheduleTitle,
      this.dayId,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: cc.greyFive,
          )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              asProvider.getString((dayTitle ?? '').capitalize()),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      showCreateScheduleDialogue(context,
                          dayId: dayId,
                          schedule: scheduleTitle,
                          id: scheduleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.edit,
                        color: cc.successColor,
                      ),
                    )),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: () {
                      showDeleteDialogue(context, id: scheduleId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.delete_outline,
                        color: cc.warningColor,
                      ),
                    )),
              ],
            )
          ],
        ),
        const Divider(),
        Row(
          children: [
            Text(
              asProvider.getString("Schedule") + ": ",
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              // height: 32,
              // padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     color: cc.primaryColor),
              child: Text(
                scheduleTitle ?? '',
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/view/service_day/day_helper.dart';

import '../../utils/responsive.dart';

class DayCard extends StatelessWidget {
  String? dayTitle;
  List<String?> scheduleList;
  var dayId;

  DayCard({this.dayTitle, required this.scheduleList, this.dayId, Key? key})
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
            IconButton(
                onPressed: () {
                  showDeleteDialogue(context, id: dayId);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: cc.warningColor,
                ))
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
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width - 160,
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: scheduleList
                    .map((e) => Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: cc.primaryColor),
                          child: Text(
                            e ?? '',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ]),
    );
  }
}

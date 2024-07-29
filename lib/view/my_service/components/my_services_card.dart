// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';

class MyServicesCardContent extends StatelessWidget {
  const MyServicesCardContent({
    Key? key,
    required this.imageLink,
    required this.title,
    required this.rating,
    required this.ratingCount,
    required this.isOnline,
    required this.queued,
    required this.completed,
    required this.cancelled,
    required this.viewCount,
  }) : super(key: key);

  final imageLink;
  final title;
  final rating;
  final ratingCount;
  final isOnline;
  final queued;
  final completed;
  final cancelled;
  final viewCount;

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHelper().profileImage(imageLink, 75, 78),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //service name ======>
                Text(
                  title.toString(),
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

                sizedBoxCustom(6),

                //First row
                // ==========>
                Row(
                  children: [
                    //Rating
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.yellow[800],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CommonHelper().paragraphCommon(
                        "$rating ($ratingCount)", TextAlign.left,
                        fontsize: 14, fontweight: FontWeight.w600),

                    const SizedBox(
                      width: 10,
                    ),

                    //View
                    //========>
                    Icon(
                      Icons.remove_red_eye_sharp,
                      size: 18,
                      color: cc.primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CommonHelper().paragraphCommon("$viewCount", TextAlign.left,
                        fontsize: 14, fontweight: FontWeight.w600),

                    //online/offline
                    //========>
                    const SizedBox(
                      width: 9,
                    ),
                    Icon(
                      Icons.gps_fixed,
                      size: 18,
                      color: cc.primaryColor,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    CommonHelper().paragraphCommon("$isOnline", TextAlign.left,
                        fontsize: 14, fontweight: FontWeight.w600),
                  ],
                ),

                sizedBoxCustom(8),

                //Second row
                // ==========>
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.17),
                          borderRadius: BorderRadius.circular(4)),
                      child: CommonHelper().paragraphCommon(
                        asProvider.getString("Queue") + ": $queued",
                        TextAlign.left,
                        // color: Colors.black,
                        fontsize: 13,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(.17),
                          borderRadius: BorderRadius.circular(4)),
                      child: CommonHelper().paragraphCommon(
                        asProvider.getString("Completed") + ": $completed",
                        TextAlign.left,
                        // color: Colors.black,
                        fontsize: 13,
                      ),
                    ),
                  ],
                ),

                //Third row
                // ==========>

                sizedBoxCustom(8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.17),
                          borderRadius: BorderRadius.circular(4)),
                      child: CommonHelper().paragraphCommon(
                        asProvider.getString("Cancelled") + ": $cancelled",
                        TextAlign.left,
                        // color: Colors.black,
                        fontsize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

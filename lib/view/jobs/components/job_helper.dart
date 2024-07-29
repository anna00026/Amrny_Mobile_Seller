import 'package:flutter/material.dart';
import 'package:qixer_seller/view/jobs/apply_job_popup.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class JobHelper {
  applyJobPopup(BuildContext context) {
    return Alert(
            context: context,
            style: AlertStyle(
                alertElevation: 0,
                overlayColor: Colors.black.withOpacity(.6),
                alertPadding: const EdgeInsets.all(15),
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
                padding: const EdgeInsets.only(top: 20),
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
                child: const ApplyJobPopup()))
        .show();
  }
}

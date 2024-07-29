import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/view/auth/login/login.dart';

class SignupHelper {
  ConstantColors cc = ConstantColors();
  haveAccount(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: ln.getString('Have an account?') + '  ',
              style: const TextStyle(color: Color(0xff646464), fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    text: ln.getString('Sign in'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: cc.primaryColor,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  phoneFieldDecoration(String labelText, String hintText) {
    return InputDecoration(
        labelText: labelText,
        // hintTextDirection: TextDirection.rtl,

        labelStyle: TextStyle(color: cc.greyFour, fontSize: 14),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstantColors().greyFive),
            borderRadius: BorderRadius.circular(9)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstantColors().primaryColor)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstantColors().warningColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstantColors().primaryColor)),
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 18));
  }
}

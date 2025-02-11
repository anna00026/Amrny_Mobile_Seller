// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/auth_services/signup_service.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/view/auth/signup/signup_helper.dart';

import '../../../../services/rtl_service.dart';
import '../../../../utils/common_helper.dart';
import '../../../../utils/responsive.dart';

class SignupPhonePass extends StatefulWidget {
  const SignupPhonePass(
      {Key? key,
      required this.passController,
      required this.phoneController,
      required this.confirmPassController})
      : super(key: key);

  final passController;
  final confirmPassController;
  final phoneController;

  @override
  _SignupPhonePassState createState() => _SignupPhonePassState();
}

class _SignupPhonePassState extends State<SignupPhonePass> {
  late bool _newpasswordVisible;
  late bool _confirmNewPassswordVisible;

  @override
  void initState() {
    super.initState();
    _newpasswordVisible = false;
    _confirmNewPassswordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<SignupService>(
        builder: (context, provider, child) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Phone number field
              CommonHelper().labelCommon(ln.getString("Phone")),
              Consumer<RtlService>(
                builder: (context, rtlP, child) => IntlPhoneField(
                  controller: widget.phoneController,
                  disableLengthCheck: true,
                  decoration: SignupHelper().phoneFieldDecoration(
                      ln.getString('Phone Number'),
                      ln.getString('Enter phone number')),
                  searchText: asProvider.getString("Search country"),
                  initialCountryCode: provider.countryCode,
                  textAlign: rtlP.direction == 'ltr'
                      ? TextAlign.left
                      : TextAlign.right,
                  onChanged: (phone) {
                    provider.setCountryCode(phone.countryISOCode);

                    provider.setPhone(phone.number);
                  },
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              //New password =========================>
              CommonHelper().labelCommon(ln.getString("Password")),

              Container(
                  margin: const EdgeInsets.only(bottom: 19),
                  decoration: BoxDecoration(
                      // color: const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: widget.passController,
                    textInputAction: TextInputAction.next,
                    obscureText: !_newpasswordVisible,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString('Please enter your password');
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 22.0,
                              width: 40.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/icons/lock.png'),
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                          ],
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _newpasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 22,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _newpasswordVisible = !_newpasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ConstantColors().greyFive),
                            borderRadius: BorderRadius.circular(9)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().primaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().warningColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().primaryColor)),
                        hintText: ln.getString('Enter password'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 18)),
                  )),

              const SizedBox(
                height: 10,
              ),
              //Confirm New password =========================>
              CommonHelper().labelCommon(ln.getString("Confirm Password")),

              Container(
                  margin: const EdgeInsets.only(bottom: 19),
                  decoration: BoxDecoration(
                      // color: const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: widget.confirmPassController,
                    textInputAction: TextInputAction.next,
                    obscureText: !_confirmNewPassswordVisible,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString('Please retype your password');
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 22.0,
                              width: 40.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/icons/lock.png'),
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                          ],
                        ),
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _confirmNewPassswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 22,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _confirmNewPassswordVisible =
                                  !_confirmNewPassswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ConstantColors().greyFive),
                            borderRadius: BorderRadius.circular(9)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().primaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().warningColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ConstantColors().primaryColor)),
                        hintText: ln.getString('Retype password'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 18)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

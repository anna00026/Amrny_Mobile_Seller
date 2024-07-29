import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/custom_input.dart';

class EmailNameFields extends StatelessWidget {
  const EmailNameFields(
      {Key? key,
      this.fullNameController,
      this.userNameController,
      this.emailController,
      this.passController,
      this.confirmPassController})
      : super(key: key);

  final fullNameController;
  final userNameController;
  final emailController;
  final passController;
  final confirmPassController;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Name ============>
          CommonHelper().labelCommon(ln.getString("Full name")),

          CustomInput(
            controller: fullNameController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return ln.getString('Please enter your full name');
              }
              return null;
            },
            hintText: ln.getString("Enter your full name"),
            icon: 'assets/icons/user.png',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 8,
          ),

          //User name ============>
          CommonHelper().labelCommon(ln.getString("Username")),

          CustomInput(
            controller: userNameController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return ln.getString('Please enter your username');
              }
              return null;
            },
            hintText: ln.getString("Enter your username"),
            icon: 'assets/icons/user.png',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 8,
          ),

          //Email ============>
          CommonHelper().labelCommon(ln.getString("Email")),

          CustomInput(
            controller: emailController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return ln.getString('Please enter your email');
              }
              return null;
            },
            hintText: ln.getString("Enter your email"),
            icon: 'assets/icons/email-grey.png',
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}

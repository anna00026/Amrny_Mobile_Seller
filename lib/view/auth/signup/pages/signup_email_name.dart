// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qixer_seller/utils/constant_colors.dart';
// import 'package:qixer_seller/view/auth/signup/components/email_name_fields.dart';
// import 'package:qixer_seller/view/auth/signup/signup_helper.dart';

// import '../../../../services/auth_services/signup_service.dart';
// import '../../../../utils/common_helper.dart';

// class SignupEmailName extends StatefulWidget {
//   const SignupEmailName(
//       {Key? key,
//       this.fullNameController,
//       this.userNameController,
//       this.emailController})
//       : super(key: key);

//   final fullNameController;
//   final userNameController;
//   final emailController;

//   @override
//   _SignupEmailNameState createState() => _SignupEmailNameState();
// }

// class _SignupEmailNameState extends State<SignupEmailName> {
//   late bool _passwordVisible;

//   @override
//   void initState() {
//     super.initState();
//     _passwordVisible = false;
//   }

//   final _formKey = GlobalKey<FormState>();

//   bool keepLoggedIn = true;

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 25),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             EmailNameFields(
//                 emailController: widget.emailController,
//                 fullNameController: widget.fullNameController,
//                 userNameController: widget.userNameController),
//             const SizedBox(
//               height: 8,
//             ),

//             //Login button ==================>
//             const SizedBox(
//               height: 13,
//             ),
//             Consumer<SignupService>(
//               builder: (context, provider, child) =>
//                   CommonHelper().borderButtonPrimary("Continue", () {
//                 if (_formKey.currentState!.validate()) {
//                   provider.pagecontroller.animateToPage(
//                       provider.selectedPage + 1,
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.ease);
//                 }
//               }),
//             ),

//             const SizedBox(
//               height: 25,
//             ),
//             SignupHelper().haveAccount(context),
//           ],
//         ),
//       ),
//     );
//   }
// }

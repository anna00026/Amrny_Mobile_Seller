// import 'package:flutter/material.dart';
// import 'package:qixer_seller/utils/constant_colors.dart';

// import '../../../utils/common_helper.dart';

// class LocationSelectAfterLoginPage extends StatelessWidget {
//   const LocationSelectAfterLoginPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CommonHelper().appbarCommon('Select Location', context, () {
//         Navigator.pop(context);
//       }),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Consumer<AllServicesService>(
//             builder: (context, provider, child) => Column(children: [
//               // Service List ===============>
//               const SizedBox(
//                 height: 10,
//               ),
//               const CountryStatesDropdowns(),

//               const SizedBox(
//                 height: 30,
//               ),

//               CommonHelper().buttonOrange("Login", () {
//                 Navigator.pushReplacement<void, void>(
//                   context,
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) => const LandingPage(),
//                   ),
//                 );
//               }),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

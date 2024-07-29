// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qixer_seller/utils/constant_colors.dart';
// import 'package:qixer_seller/view/profile/profile_edit.dart';

// import '../../../services/profile_service.dart';
// import '../../../utils/common_helper.dart';

// class NameImage extends StatelessWidget {
//   const NameImage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();

//     return //name and profile image
//         Consumer<ProfileService>(
//             builder: (context, profileProvider, child) =>
//                 //  profileProvider
//                 //             .profileDetails !=
//                 //         null
//                 //     ? profileProvider.profileDetails != 'error'
//                 //         ?
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) => ProfileEditPage(),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Row(
//                       children: [
//                         //name
//                         Expanded(
//                             child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Welcome!',
//                               style: TextStyle(
//                                 color: cc.greyParagraph,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'Saleheen',
//                               style: TextStyle(
//                                 color: cc.greyFour,
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         )),

//                         //profile image
//                         // profileProvider.profileImage != null
//                         //     ? CommonHelper().profileImage(
//                         //         profileProvider.profileImage, 52, 52)
//                         //     :
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.asset(
//                             'assets/images/avatar.png',
//                             height: 52,
//                             width: 52,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//             //     : const Text('Couldn\'t load user profile info')
//             // : Container(),
//             );
//   }
// }

import 'package:qixer_seller/utils/constant_colors.dart';

class SubscriptionHelper {
  final cc = ConstantColors();

  // reniewPopup(BuildContext context, {required subscriptionId}) {
  //   return Alert(
  //       context: context,
  //       style: AlertStyle(
  //           alertElevation: 0,
  //           overlayColor: Colors.black.withOpacity(.6),
  //           alertPadding: const EdgeInsets.all(25),
  //           isButtonVisible: false,
  //           alertBorder: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             side: const BorderSide(
  //               color: Colors.transparent,
  //             ),
  //           ),
  //           titleStyle: const TextStyle(),
  //           animationType: AnimationType.grow,
  //           animationDuration: const Duration(milliseconds: 500)),
  //       content: Container(
  //         margin: const EdgeInsets.only(top: 22),
  //         padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(7),
  //           boxShadow: [
  //             BoxShadow(
  //                 color: Colors.black.withOpacity(0.01),
  //                 spreadRadius: -2,
  //                 blurRadius: 13,
  //                 offset: const Offset(0, 13)),
  //           ],
  //         ),
  //         child: Consumer<AppStringService>(
  //           builder: (context, asProvider, child) => Column(
  //             children: [
  //               Text(
  //                 '${asProvider.getString('Reniew subscription')}?',
  //                 style: TextStyle(color: cc.greyPrimary, fontSize: 17),
  //               ),
  //               const SizedBox(
  //                 height: 25,
  //               ),
  //               Consumer<SubscriptionService>(
  //                 builder: (context, provider, child) => Row(
  //                   children: [
  //                     Expanded(
  //                         child: CommonHelper().borderButtonPrimary(
  //                             asProvider.getString('Cancel'), () {
  //                       Navigator.pop(context);
  //                     })),
  //                     const SizedBox(
  //                       width: 16,
  //                     ),
  //                     Expanded(
  //                         child: CommonHelper()
  //                             .buttonPrimary(asProvider.getString('Yes'), () {
  //                       provider.reniewSubscription(context,
  //                           subscriptionId: subscriptionId);
  //                     }, isloading: provider.isloading)),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       )).show();
  // }
}

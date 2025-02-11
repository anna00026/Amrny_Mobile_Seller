import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/deactivate_account_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/profile/components/textarea_field.dart';

class DeactivateAccountPage extends StatelessWidget {
  const DeactivateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    ConstantColors cc = ConstantColors();
    TextEditingController descController = TextEditingController();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Deactivate account', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenPadding,
        ),
        height: screenHeight - 100,
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<DeactivateAccountService>(
            builder: (context, provider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // dropdown ======>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().labelCommon(ln.getString("Choose Reason")),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: cc.greyFive),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // menuMaxHeight: 200,
                          // isExpanded: true,
                          value: provider.selecteddeactivateReason,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: cc.greyFour),
                          iconSize: 26,
                          elevation: 17,
                          style: TextStyle(color: cc.greyFour),
                          onChanged: (newValue) {
                            provider.setdeactivateReasonValue(newValue);

                            //setting the id of selected value
                            provider.setSelecteddeactivateReasonId(
                                provider.deactivateReasonDropdownList[provider
                                    .deactivateReasonDropdownList
                                    .indexOf(newValue!)]);
                          },
                          items: provider.deactivateReasonDropdownList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                asProvider.getString(value),
                                style: TextStyle(
                                    color: cc.greyPrimary.withOpacity(.8)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                CommonHelper().labelCommon(ln.getString("Short description")),

                TextareaField(
                  hintText: ln.getString('description'),
                  notesController: descController,
                ),

                const SizedBox(
                  height: 30,
                ),

                Consumer<DeactivateAccountService>(
                  builder: (context, provider, child) => CommonHelper()
                      .buttonPrimary(ln.getString("Deactivate"), () {
                    if (provider.isloading == false) {
                      if (descController.text.isEmpty) {
                        OthersHelper().showToast(
                            ln.getString('Please enter a description'),
                            Colors.black);
                        return;
                      }

                      provider.deactivate(context, descController.text);
                      // Navigator.pushReplacement<void, void>(
                      //   context,
                      //   MaterialPageRoute<void>(
                      //     builder: (BuildContext context) =>
                      //         const Homepage(),
                      //   ),
                      // );
                    }
                  },
                          isloading: provider.isloading == false ? false : true,
                          bgColor: cc.orangeColor),
                ),

                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/language_dropdown_helper.dart';
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/view/orders/payment_helper.dart';
import 'package:amrny_seller/view/profile/profile_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Profile', context, () {
          Navigator.pop(context);
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: Consumer<AppStringService>(
                builder: (context, ln, child) => Consumer<ProfileService>(
                  builder: (context, profileProvider, child) => profileProvider
                              .profileDetails !=
                          null
                      ? profileProvider.profileDetails != 'error'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenPadding),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //profile image, name ,desc
                                        Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              //Profile image section =======>
                                              InkWell(
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const ProfileEditPage(),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    profileProvider
                                                                .profileImage !=
                                                            null
                                                        ? CommonHelper()
                                                            .profileImage(
                                                                profileProvider
                                                                    .profileImage
                                                                    .imgUrl,
                                                                62,
                                                                62)
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: Image.asset(
                                                              'assets/images/avatar.png',
                                                              height: 62,
                                                              width: 62,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),

                                                    const SizedBox(
                                                      height: 12,
                                                    ),

                                                    //user name
                                                    CommonHelper().titleCommon(
                                                        profileProvider
                                                                .profileDetails
                                                                .name ??
                                                            ''),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    //phone
                                                    CommonHelper()
                                                        .paragraphCommon(
                                                            profileProvider
                                                                .profileDetails
                                                                .phone
                                                                .toString(),
                                                            TextAlign.center),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    CommonHelper().paragraphCommon(
                                                        profileProvider
                                                                .profileDetails
                                                                .about ??
                                                            '',
                                                        TextAlign.center)
                                                  ],
                                                ),
                                              ),

                                              //Grid cards
                                            ],
                                          ),
                                        ),

                                        //
                                      ]),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                // Personal information ==========>
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenPadding),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        PaymentHelper().bRow(
                                            'null',
                                            ln.getString('Email'),
                                            profileProvider
                                                    .profileDetails.email ??
                                                ''),
                                        PaymentHelper().bRow(
                                            'null',
                                            ln.getString('City'),
                                            profileProvider.profileDetails.city
                                                    ?.serviceCity ??
                                                ''),
                                        PaymentHelper().bRow(
                                            'null',
                                            ln.getString('Area'),
                                            profileProvider.profileDetails.area
                                                    ?.serviceArea ??
                                                ''),
                                        PaymentHelper().bRow(
                                            'null',
                                            ln.getString('Country'),
                                            profileProvider.profileDetails
                                                    .country?.country ??
                                                ''),
                                        PaymentHelper().bRow(
                                            'null',
                                            ln.getString('Post Code'),
                                            profileProvider
                                                    .profileDetails.postCode ??
                                                ''),
                                        PaymentHelper().bRow(
                                            'null',
                                            ln.getString('Address'),
                                            profileProvider
                                                    .profileDetails.address ??
                                                ''),
                                        const SizedBox(height: 5),
                                        //dropdown for language
                                        LanguageDropdownHelper()
                                            .languageDropdown(cc, context),
                                      ]),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                CommonHelper().buttonPrimary(
                                    ln.getString('Edit Profile'), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ProfileEditPage(),
                                    ),
                                  );
                                })
                              ],
                            )
                          : OthersHelper().showError(context)
                      : Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height - 150,
                          child: OthersHelper().showLoading(cc.primaryColor),
                        ),
                ),
              ),
            ),
          ),
        ));
  }
}

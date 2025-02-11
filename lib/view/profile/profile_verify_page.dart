import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/services/profile_verify_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';

class ProfileVerifyPage extends StatefulWidget {
  const ProfileVerifyPage({Key? key}) : super(key: key);

  @override
  State<ProfileVerifyPage> createState() => _ProfileVerifyPageState();
}

class _ProfileVerifyPageState extends State<ProfileVerifyPage> {
  @override
  void initState() {
    super.initState();
    isVerified = Provider.of<ProfileService>(context, listen: false)
        .profileDetails
        .sellerVerify;
  }

  var isVerified;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Verify', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<ProfileVerifyService>(
            builder: (context, provider, child) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenPadding,
              ),
              child: isVerified == null || isVerified.status.toString() != "1"
                  ? Column(
                      children: [
                        Text(
                          ln.getString('Address document image'),
                          style:
                              TextStyle(color: cc.greyParagraph, fontSize: 15),
                        ),
                        provider.pickedAddressImage != null
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 80,
                                    child: ListView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: [
                                        // for (int i = 0;
                                        //     i <
                                        //         provider
                                        //             .images!.length;
                                        //     i++)
                                        InkWell(
                                          onTap: () {},
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: Image.file(
                                                  // File(provider.images[i].path),
                                                  File(provider
                                                      .pickedAddressImage.path),
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),

                        //pick image button =====>
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CommonHelper().buttonPrimary(
                                ln.getString('Choose address images'), () {
                              provider.pickAddressImage(context);
                            }),
                          ],
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        //NID document image ===========>
                        //===============================
                        Text(
                          ln.getString('NID document image'),
                          style:
                              TextStyle(color: cc.greyParagraph, fontSize: 15),
                        ),
                        provider.pickedNidImage != null
                            ? Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 80,
                                    child: ListView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: [
                                        // for (int i = 0;
                                        //     i <
                                        //         provider
                                        //             .images!.length;
                                        //     i++)
                                        InkWell(
                                          onTap: () {},
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: Image.file(
                                                  // File(provider.images[i].path),
                                                  File(provider
                                                      .pickedNidImage.path),
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),

                        //pick image button =====>
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CommonHelper().buttonPrimary(
                                ln.getString('Choose NID images'), () {
                              provider.pickNidImage(context);
                            }),
                          ],
                        ),

                        //UPload button
                        const SizedBox(
                          height: 20,
                        ),
                        CommonHelper().buttonPrimary(ln.getString('Upload'),
                            () {
                          if (provider.isloading == false) {
                            provider.uploadDocument(context);
                          }
                        },
                            isloading:
                                provider.isloading == false ? false : true),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: screenHeight - 200,
                      margin: const EdgeInsets.only(top: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration_outlined,
                            size: 60,
                            color: cc.primaryColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            ln.getString("Account verified"),
                            style: TextStyle(
                                color: cc.greyParagraph,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

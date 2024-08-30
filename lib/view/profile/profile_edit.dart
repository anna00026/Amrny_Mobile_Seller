import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/dropdowns_services/area_dropdown_service.dart';
import 'package:qixer_seller/services/dropdowns_services/country_dropdown_service.dart';
import 'package:qixer_seller/services/dropdowns_services/state_dropdown_services.dart';
import 'package:qixer_seller/services/language_dropdown_helper.dart';
import 'package:qixer_seller/services/profile_edit_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/auth/signup/signup_helper.dart';
import 'package:qixer_seller/view/profile/components/textarea_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../services/profile_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/constant_styles.dart';
import '../../utils/custom_input.dart';
import '../../utils/responsive.dart';
import '../auth/signup/components/country_states_dropdowns.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sellerLabelController = TextEditingController();

  TextEditingController postCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String? countryCode;
  Map<String, dynamic> profileJson = {};
  List<String> socialFieldNames = [
    'fb_url',
    'tw_url',
    'go_url',
    'li_url',
    'yo_url',
    'in_url',
    'dr_url',
    'twi_url',
    'pi_url',
    're_url',
  ];
  List<String> socialLabelNames = [
    'Facebook',
    'Twitter',
    'Google',
    'Linkedin',
    'Youtube',
    'Instagram',
    'Dribble',
    'Twitch',
    'Pinterest',
    'Reddit',
  ];
  @override
  void initState() {
    super.initState();
    ProfileService profileProvider =
        Provider.of<ProfileService>(context, listen: false);
    ProfileEditService profileEditProvider =
        Provider.of<ProfileEditService>(context, listen: false);
    countryCode = profileProvider.profileDetails.countryCode;
    profileEditProvider.setCountryCode(countryCode);

    fullNameController.text = profileProvider.profileDetails.name ?? '';
    sellerLabelController.text =
        profileProvider.profileDetails.sellerLabel ?? '';
    emailController.text = profileProvider.profileDetails.email ?? '';

    phoneController.text = profileProvider.profileDetails.phone ?? '';
    postCodeController.text = profileProvider.profileDetails.postCode ?? '';
    addressController.text = profileProvider.profileDetails.address ?? '';
    aboutController.text = profileProvider.profileDetails.about ?? '';
    Provider.of<CountryDropdownService>(context, listen: false)
        .setCountryBasedOnUserProfile(context);
    Provider.of<StateDropdownService>(context, listen: false)
        .setStateBasedOnUserProfile(context);
    Provider.of<AreaDropdownService>(context, listen: false)
        .setAreaBasedOnUserProfile(context);
    profileJson = profileProvider.profileDetails.toJson();
  }

  late AnimationController localAnimationController;
  XFile? pickedImage;

  Widget _getSocialInput(int idx, AppStringService ln) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 8,
      ),
      CommonHelper().labelCommon(ln.getString('${socialLabelNames[idx]} Link')),
      CustomInput(
        initialValue: profileJson[socialFieldNames[idx]],
        hintText: ln.getString(
            'https://www.${socialLabelNames[idx].toLowerCase()}.com/'),
        textInputAction: TextInputAction.next,
        onChanged: (val) => profileJson[socialFieldNames[idx]] = val,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Edit profile', context, () {
        if (Provider.of<ProfileEditService>(context, listen: false).isloading ==
            false) {
          Navigator.pop(context);
        } else {
          OthersHelper().showToast(
              Provider.of<AppStringService>(context, listen: false)
                  .getString('Please wait while the profile is updating'),
              Colors.black);
        }
      }),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<ProfileEditService>(
            builder: (context, provider, child) => WillPopScope(
              onWillPop: () {
                if (provider.isloading == false) {
                  return Future.value(true);
                } else {
                  OthersHelper().showToast(
                      ln.getString('Please wait while the profile is updating'),
                      Colors.black);
                  return Future.value(false);
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //pick profile image
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          pickedImage = await provider.pickImage();
                          setState(() {});
                        },
                        child: SizedBox(
                          width: 105,
                          height: 105,
                          child: Stack(
                            children: [
                              Consumer<ProfileService>(
                                builder: (context, profileProvider, child) =>
                                    Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: pickedImage == null
                                          ? profileProvider.profileImage != null
                                              ? CommonHelper().profileImage(
                                                  profileProvider
                                                      .profileImage.imgUrl,
                                                  85,
                                                  85)
                                              : Image.asset(
                                                  'assets/images/avatar.png',
                                                  height: 85,
                                                  width: 85,
                                                  fit: BoxFit.cover,
                                                )
                                          : Image.file(
                                              File(pickedImage!.path),
                                              height: 85,
                                              width: 85,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              ),
                              Positioned(
                                bottom: 9,
                                right: 12,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                      child: Icon(
                                    Icons.camera,
                                    color: cc.greyPrimary,
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      //Email, name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Name ============>
                          CommonHelper().labelCommon(ln.getString("Full name")),

                          CustomInput(
                            controller: fullNameController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString('Please enter your full name');
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

                          //Company Name ============>
                          CommonHelper()
                              .labelCommon(ln.getString("Company name")),

                          CustomInput(
                            controller: sellerLabelController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(
                                    'Please enter your company name');
                              }
                              return null;
                            },
                            hintText: ln.getString("Enter your company name"),
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

                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),

                      //phone
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().labelCommon(ln.getString("Phone")),
                          Consumer<RtlService>(
                            builder: (context, rtlP, child) => IntlPhoneField(
                              controller: phoneController,
                              disableLengthCheck: true,
                              decoration: SignupHelper().phoneFieldDecoration(
                                  ln.getString('Phone Number'),
                                  ln.getString('Enter phone number')),
                              searchText:
                                  asProvider.getString("Search country"),
                              initialCountryCode: provider.countryCode,
                              textAlign: rtlP.direction == 'ltr'
                                  ? TextAlign.left
                                  : TextAlign.right,
                              onCountryChanged: (country) {
                                provider.setCountryCode(country.code);
                              },
                              onChanged: (phone) {
                                provider.setCountryCode(phone.countryISOCode);
                              },
                            ),
                          ),
                          sizedBoxCustom(20),
                          CommonHelper().labelCommon(ln.getString("Post code")),
                          CustomInput(
                            controller: postCodeController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString('Please enter post code');
                              }
                              return null;
                            },
                            isNumberField: true,
                            hintText: ln.getString("Enter your post code"),
                            icon: 'assets/icons/user.png',
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),

                      const SizedBox(
                        height: 18,
                      ),
                      //dropdowns
                      const CountryStatesDropdowns(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          CommonHelper()
                              .labelCommon(ln.getString("Your Address")),
                          TextareaField(
                            hintText: ln.getString('Address'),
                            notesController: addressController,
                          ),
                        ],
                      ),

                      //About
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          CommonHelper().labelCommon(ln.getString("About")),
                          TextareaField(
                            hintText: ln.getString('About'),
                            notesController: aboutController,
                          ),
                        ],
                      ),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            CommonHelper()
                                .labelCommon(ln.getString("Tax Number")),
                            CustomInput(
                              initialValue: profileJson['tax_number'],
                              hintText: ln.getString("Enter your tax number"),
                              textInputAction: TextInputAction.next,
                              onChanged: (val) =>
                                  profileJson['tax_number'] = val,
                            ),
                          ]),
                      for (int i = 0; i < socialFieldNames.length; i++)
                        _getSocialInput(i, ln),
                      const SizedBox(
                        height: 25,
                      ),
                      CommonHelper().buttonPrimary(ln.getString('Save'),
                          () async {
                        if (provider.isloading == false) {
                          if (addressController.text.isEmpty) {
                            OthersHelper().showToast(
                                ln.getString('Address field is required'),
                                Colors.black);
                            return;
                          } else if (phoneController.text.isEmpty) {
                            OthersHelper().showToast(
                                ln.getString('Phone field is required'),
                                Colors.black);
                            return;
                          }
                          showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                message: ln.getString(
                                    "Updating profile...It may take few seconds"),
                              ),
                              persistent: true,
                              onAnimationControllerInit: (controller) =>
                                  localAnimationController = controller,
                              onTap: () {
                                // localAnimationController.reverse();
                              });

                          //update profile
                          var result = await provider.updateProfile(
                            fullNameController.text,
                            sellerLabelController.text,
                            emailController.text,
                            phoneController.text,
                            Provider.of<StateDropdownService>(context,
                                    listen: false)
                                .selectedStateId,
                            Provider.of<AreaDropdownService>(context,
                                    listen: false)
                                .selectedAreaId,
                            Provider.of<CountryDropdownService>(context,
                                    listen: false)
                                .selectedCountryId,
                            postCodeController.text,
                            addressController.text,
                            aboutController.text,
                            pickedImage?.path,
                            profileJson,
                            context,
                          );
                          if (result == true || result == false) {
                            localAnimationController.reverse();
                          }
                          localAnimationController.reverse();
                        }
                      }, isloading: provider.isloading == false ? false : true),

                      const SizedBox(
                        height: 38,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

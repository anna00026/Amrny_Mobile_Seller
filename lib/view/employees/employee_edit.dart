import 'dart:io';

import 'package:customizable_datetime_picker/sources/i18n/date_picker_i18n.dart';
import 'package:customizable_datetime_picker/sources/model/date_picker_divider_theme.dart';
import 'package:customizable_datetime_picker/sources/model/date_picker_theme.dart';
import 'package:customizable_datetime_picker/sources/widget/customizable_date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/model/employee_model.dart';
import 'package:qixer_seller/model/profile_model.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/dropdowns_services/area_dropdown_service.dart';
import 'package:qixer_seller/services/dropdowns_services/country_dropdown_service.dart';
import 'package:qixer_seller/services/dropdowns_services/state_dropdown_services.dart';
import 'package:qixer_seller/services/employees/employees_service.dart';
import 'package:qixer_seller/services/language_dropdown_helper.dart';
import 'package:qixer_seller/services/profile_edit_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/auth/signup/signup_helper.dart';
import 'package:qixer_seller/view/employees/components/number_formatter.dart';
import 'package:qixer_seller/view/profile/components/textarea_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../services/profile_service.dart';
import '../../services/rtl_service.dart';
import '../../utils/constant_styles.dart';
import '../../utils/custom_input.dart';
import '../../utils/responsive.dart';
import '../auth/signup/components/country_states_dropdowns.dart';

class EmployeeEditPage extends StatefulWidget {
  EmployeeModel? employee;
  EmployeeEditPage({super.key, this.employee});

  @override
  State<EmployeeEditPage> createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  String? countryCode;
  EmployeeModel? employee;
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    super.initState();
    employee = widget.employee;
    if (employee == null) {}
    if (employee == null) {
      employee = EmployeeModel();
      employee?.userDetails = UserDetails();
    }
      _birthDtController.text = getFormattedDateString(
          employee?.joiningDate,
          Provider.of<AppStringService>(context, listen: false)
              .currentLanguage);
  }

  late AnimationController localAnimationController;
  final TextEditingController _birthDtController = TextEditingController();
  XFile? pickedImage;

  String getFormattedDateString(DateTime? date, String currentLanguage) {
    return date == null
        ? ''
        : DateFormat.yMMMMd(currentLanguage == 'English' ? 'en_US' : 'ar_AR')
            .format(date);
  }

  DateTime? parseDateString(String dateString, String currentLanguage) {
    if (dateString.isEmpty) return null;

    try {
      return DateFormat.yMMMMd(currentLanguage == 'English' ? 'en_US' : 'ar_AR')
          .parse(dateString);
    } catch (e) {
      return null;
    }
  }

  void _selectBirthDate(
      BuildContext context, DateTime? joinDate, String currentLanguage) {
    DateTime? selectedDate = joinDate ?? DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AppStringService>(
          builder: (context, ln, child) => AlertDialog(
            title: Text(
              ln.getString('Joining Date'),
            ),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            content: CustomizableDatePickerWidget(
                separatorWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    ":",
                    style: TextStyle(
                      color: cc.greyThree,
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                locale: currentLanguage == 'English'
                    ? DateTimePickerLocale.enUs
                    : DateTimePickerLocale.ar,
                looping: true,
                lastDate: DateTime.now(),
                initialDate: selectedDate,
                dateFormat: "yyyy-MMMM-dd",
                pickerTheme: DateTimePickerTheme(
                    itemTextStyle: TextStyle(
                      color: cc.greyThree,
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: Colors.white,
                    itemHeight: 50,
                    pickerHeight: 250,
                    dividerTheme: DatePickerDividerTheme(
                        dividerColor: cc.primaryColor,
                        thickness: 4,
                        height: 4)),
                onChange: (dateTime, selectedIndex) {
                  selectedDate = dateTime;
                }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(ln.getString('Cancel')),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    joinDate = selectedDate;
                    _birthDtController.text =
                        getFormattedDateString(joinDate, currentLanguage);
                  });
                  Navigator.pop(context);
                },
                child: Text(ln.getString('OK')),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon(
          employee!.id != null ? 'Edit employee' : 'New employee', context, () {
        if (Provider.of<ProfileEditService>(context, listen: false).isloading ==
            false) {
          Navigator.pop(context);
        } else {
          OthersHelper().showToast(
              Provider.of<AppStringService>(context, listen: false)
                  .getString('Please wait while saving the employee data'),
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
          builder: (context, ln, child) => Consumer<EmployeesService>(
            builder: (context, provider, child) => WillPopScope(
              onWillPop: () {
                if (provider.isLoading == false) {
                  return Future.value(true);
                } else {
                  OthersHelper().showToast(
                      ln.getString(
                          'Please wait while saving the employee data'),
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
                              Consumer<EmployeesService>(
                                builder: (context, profileProvider, child) =>
                                    Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: pickedImage == null
                                          ? (employee != null &&
                                                  employee?.profileImage !=
                                                      null)
                                              ? CommonHelper().profileImage(
                                                  employee?.profileImage
                                                          ?.imgUrl ??
                                                      '',
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
                            onChanged: (val) =>
                                employee!.userDetails?.name = val,
                            hintText:
                                ln.getString("Enter employee's full name"),
                            icon: 'assets/icons/user.png',
                            textInputAction: TextInputAction.next,
                            initialValue: employee!.userDetails?.name,
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          //Email ============>
                          CommonHelper().labelCommon(ln.getString("Email")),

                          CustomInput(
                            onChanged: (val) =>
                                employee!.userDetails?.email = val,
                            hintText: ln.getString("Enter employee's email"),
                            icon: 'assets/icons/email-grey.png',
                            textInputAction: TextInputAction.next,
                            initialValue: employee!.userDetails?.email,
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
                              onChanged: (val) => employee!.userDetails?.phone =
                                  val.completeNumber,
                              disableLengthCheck: true,
                              decoration: SignupHelper().phoneFieldDecoration(
                                  ln.getString('Phone Number'),
                                  ln.getString('Enter phone number')),
                              searchText:
                                  asProvider.getString("Search country"),
                              initialValue: employee!.userDetails?.phone,
                              textAlign: rtlP.direction == 'ltr'
                                  ? TextAlign.left
                                  : TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          CommonHelper()
                              .labelCommon(ln.getString("Employee's Address")),
                          TextareaField(
                            hintText: ln.getString('Address'),
                            value: employee!.userDetails!.address,
                            onChanged: (val) =>
                                employee!.userDetails?.address = val,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          //Password ============>
                          CommonHelper().labelCommon(ln.getString("Password")),

                          CustomInput(
                            onChanged: (val) => password = val,
                            isPasswordField: true,
                            hintText: ln.getString("Enter employee's password"),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 18,
                          ),

                          //Password ============>
                          CommonHelper()
                              .labelCommon(ln.getString("Confirm Password")),

                          CustomInput(
                            onChanged: (val) => confirmPassword = val,
                            isPasswordField: true,
                            hintText:
                                ln.getString("Confirm employee's password"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      //About
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper()
                              .labelCommon(ln.getString("Joining Date")),
                          CustomInput(
                            controller: _birthDtController,
                            isReadOnly: true,
                            onTap: () {
                              String currentLanguage =
                                  Provider.of<AppStringService>(context,
                                          listen: false)
                                      .currentLanguage;
                              _selectBirthDate(context, employee?.joiningDate,
                                  currentLanguage);
                            },
                            hintText: ln.getString("YYYY/MM/DD"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper().labelCommon(ln.getString("Salary")),
                          CustomInput(
                            onChanged: (val) {
                              employee?.salary = val;
                            },
                            isNumberField: true,
                            formatters: [NumberFormatter()],
                            hintText: ln.getString("Salary"),
                            initialValue: employee!.salary ?? '',
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper().labelCommon(ln.getString("Bank Name")),
                          CustomInput(
                            onChanged: (val) {
                              employee?.bankName = val;
                            },
                            initialValue: employee?.bankName ?? '',
                            isNumberField: true,
                            hintText: ln.getString("Bank Name"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper()
                              .labelCommon(ln.getString("Bank Branch")),
                          CustomInput(
                            onChanged: (val) {
                              employee?.bankBranch = val;
                            },
                            initialValue: employee?.bankBranch ?? '',
                            hintText: ln.getString("Bank Branch"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper()
                              .labelCommon(ln.getString("Account Name")),
                          CustomInput(
                            onChanged: (val) {
                              employee?.bankAccount = val;
                            },
                            initialValue: employee?.bankAccount ?? '',
                            hintText: ln.getString("Account Name"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper()
                              .labelCommon(ln.getString("Account Number")),
                          CustomInput(
                            onChanged: (val) {
                              employee?.bankHolder = val;
                            },
                            initialValue: employee?.bankHolder ?? '',
                            hintText: ln.getString("Account Number"),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),

                      //About
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CommonHelper().labelCommon(ln.getString("About")),
                          TextareaField(
                            hintText: ln.getString('About'),
                            value: employee!.userDetails?.about,
                            onChanged: (val) =>
                                employee!.userDetails?.about = val,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      CommonHelper().buttonPrimary(ln.getString('Save'),
                          () async {
                        if (provider.isLoading == false) {
                          if (employee != null &&
                              employee!.userDetails != null) {
                            if (employee!.userDetails!.name == null ||
                                employee!.userDetails!.name!.isEmpty) {
                              OthersHelper().showToast(
                                  ln.getString('Name field is required'),
                                  Colors.black);
                              return;
                            } else if (employee!.userDetails!.address == null ||
                                employee!.userDetails!.address!.isEmpty) {
                              OthersHelper().showToast(
                                  ln.getString('Address field is required'),
                                  Colors.black);
                              return;
                            } else if (employee!.userDetails!.phone == null ||
                                employee!.userDetails!.phone!.isEmpty) {
                              OthersHelper().showToast(
                                  ln.getString('Phone field is required'),
                                  Colors.black);
                              return;
                            } else if (employee!.id == null &&
                                password.isEmpty) {
                              OthersHelper().showToast(
                                  ln.getString('Password field is required'),
                                  Colors.black);
                              return;
                            } else if ((employee!.id == null ||
                                    password.isNotEmpty) &&
                                password != confirmPassword) {
                              OthersHelper().showToast(
                                  ln.getString('Passwords do not match'),
                                  Colors.black);
                              return;
                            }
                          }

                          showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                message: ln.getString(
                                    "Saving employee data...It may take few seconds"),
                              ),
                              persistent: true,
                              onAnimationControllerInit: (controller) =>
                                  localAnimationController = controller,
                              onTap: () {
                                // localAnimationController.reverse();
                              });

                          String currentLanguage =
                              Provider.of<AppStringService>(context,
                                      listen: false)
                                  .currentLanguage;
                          employee?.joiningDate = parseDateString(
                              _birthDtController.text, currentLanguage);
                          // //update employee
                          var result = await provider.saveEmployee(
                            employee,
                            password,
                            pickedImage?.path,
                            context,
                          );
                          if (result == true || result == false) {
                            localAnimationController.reverse();
                          }
                          localAnimationController.reverse();
                        }
                      }, isloading: provider.isLoading == false ? false : true),

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

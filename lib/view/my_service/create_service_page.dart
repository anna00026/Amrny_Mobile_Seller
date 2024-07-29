import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/create_services_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/custom_input.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/my_service/components/category_dropdown.dart';
import 'package:qixer_seller/view/my_service/components/child_category_dropdown.dart';
import 'package:qixer_seller/view/my_service/components/create_service_image_upload.dart';
import 'package:qixer_seller/view/my_service/components/sub_category_dropdown.dart';
import 'package:qixer_seller/view/profile/components/textarea_field.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({Key? key}) : super(key: key);

  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CreateServicesService>(context, listen: false)
        .setCreateLodingStatus(false);
  }

  ConstantColors cc = ConstantColors();

  final titleController = TextEditingController();
  final videoUrlController = TextEditingController();
  final descController = TextEditingController();

  bool isAvailableToAllCities = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Create Service', context, () {
        Navigator.pop(context);
        Provider.of<CreateServicesService>(context, listen: false)
            .setImageNull();
      }),
      backgroundColor: cc.bgColor,
      body: WillPopScope(
        onWillPop: () {
          Provider.of<CreateServicesService>(context, listen: false)
              .setImageNull();
          return Future.value(true);
        },
        child: SingleChildScrollView(
          physics: physicsCommon,
          child: Consumer<CreateServicesService>(
            builder: (context, provider, child) => Consumer<AppStringService>(
              builder: (context, asProvider, child) => Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenPadding, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //on off button
                      Row(
                        children: [
                          CommonHelper().paragraphCommon(
                              asProvider.getString(
                                  'Is available to all cities and area'),
                              TextAlign.left),
                          Switch(
                            // This bool value toggles the switch.
                            value: isAvailableToAllCities,
                            activeColor: cc.successColor,
                            onChanged: (bool value) {
                              setState(() {
                                isAvailableToAllCities =
                                    !isAvailableToAllCities;
                              });
                            },
                          ),
                        ],
                      ),

                      sizedBoxCustom(10),
                      const CategoryDropdown(),

                      sizedBoxCustom(20),

                      const SubCategoryDropdown(),

                      sizedBoxCustom(20),

                      const ChildCategoryDropdown(),

                      sizedBoxCustom(20),

                      // Title
                      //============>
                      CommonHelper().labelCommon(asProvider.getString("Title")),

                      CustomInput(
                        controller: titleController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return asProvider.getString('Please enter a title');
                          }
                          return null;
                        },
                        hintText: asProvider.getString("Title"),
                        paddingHorizontal: 15,
                        textInputAction: TextInputAction.next,
                      ),

                      // Video URL
                      //============>
                      CommonHelper()
                          .labelCommon(asProvider.getString("Video URL")),

                      CustomInput(
                        controller: videoUrlController,
                        hintText: asProvider.getString("Youtube embed code"),
                        paddingHorizontal: 15,
                        textInputAction: TextInputAction.next,
                      ),

                      // Description
                      //============>

                      CommonHelper()
                          .labelCommon(asProvider.getString('Description')),
                      TextareaField(
                        hintText: asProvider.getString('Description'),
                        notesController: descController,
                      ),

                      sizedBoxCustom(10),

                      const CreateServiceImageUpload(),

                      sizedBoxCustom(20),

                      CommonHelper().buttonPrimary(asProvider.getString('Next'),
                          () {
                        //
                        if (descController.text.trim().isEmpty ||
                            titleController.text.trim().isEmpty) {
                          OthersHelper().showToast(
                              'You must enter a title and description',
                              Colors.black);
                          return;
                        }
                        if (descController.text.length < 150) {
                          OthersHelper().showToast(
                              'Description must be at least 150 characters',
                              Colors.black);
                          return;
                        }
                        //
                        provider.createService(context,
                            isAvailableToAllCities: isAvailableToAllCities,
                            description: descController.text,
                            videoUrl: videoUrlController.text,
                            title: titleController.text,
                            isFromCreateService: true);
                      }, isloading: provider.createServiceLoading),

                      sizedBoxCustom(20),

                      //
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

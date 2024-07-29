import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/jobs/job_details_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/custom_input.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/profile/components/textarea_field.dart';

class ApplyJobPopup extends StatelessWidget {
  const ApplyJobPopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    final priceController = TextEditingController();
    final coverController = TextEditingController();

    return Consumer<JobDetailsService>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Name ============>
          // CommonHelper().labelCommon('Your offer price'),

          CustomInput(
            controller: priceController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return asProvider.getString('Please enter a price');
              }
              return null;
            },
            hintText: asProvider.getString('Offer price'),
            paddingHorizontal: 20,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 5,
          ),

          TextareaField(
            hintText: asProvider.getString('Cover letter'),
            notesController: coverController,
          ),

          sizedBoxCustom(20),

          CommonHelper().buttonPrimary('Apply', () {
            if (provider.applyLoading == true) return;

            if (double.tryParse(priceController.text.trim()) == null) {
              //if not integer value
              OthersHelper()
                  .showToast('You must enter a valid price', Colors.black);
              return;
            }
            print('job id ${provider.jobDetails.id}');

            provider.applyToJob(context,
                buyerId: provider.jobDetails.buyerId,
                buyerEmail: provider.jobDetails.buyer?.email ?? '',
                jobPostId: provider.jobDetails.id,
                offerPrice: priceController.text,
                coverLetter: coverController.text,
                jobPrice: provider.jobDetails.price);
          }, isloading: provider.applyLoading),
        ],
      ),
    );
  }
}

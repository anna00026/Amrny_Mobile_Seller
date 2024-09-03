import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/order_details_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/custom_input.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';

class AddExtrasPopup extends StatelessWidget {
  const AddExtrasPopup({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final orderId;

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    final titleController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    return Consumer<OrderDetailsService>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Name ============>
          CommonHelper().labelCommon('Title'),

          CustomInput(
            controller: titleController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return asProvider.getString('Please enter a title');
              }
              return null;
            },
            hintText: asProvider.getString('Title'),
            textInputAction: TextInputAction.next,
          ),

          //Name ============>
          CommonHelper().labelCommon('Quantity'),

          CustomInput(
            controller: quantityController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return asProvider.getString('Please enter a quantity');
              }
              return null;
            },
            hintText: asProvider.getString('Quantity'),
            textInputAction: TextInputAction.next,
          ),

          //Name ============>
          CommonHelper().labelCommon('Price'),

          CustomInput(
            controller: priceController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return asProvider.getString('Please enter a price');
              }
              return null;
            },
            hintText: asProvider.getString('Price'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 5,
          ),

          CommonHelper().buttonPrimary('Add', () {
            if (provider.isLoading == true) return;

            if (double.tryParse(priceController.text.trim()) == null) {
              //if not integer value
              OthersHelper().showSnackBar(
                  context, 'You must enter a valid amount', Colors.red);
              return;
            }
            if (double.tryParse(quantityController.text.trim()) == null) {
              //if not integer value
              OthersHelper().showSnackBar(
                  context, 'Quantity must be an integer value', Colors.red);
              return;
            }

            provider.addOrderExtra(context,
                orderId: orderId,
                title: titleController.text,
                price: priceController.text,
                quantity: quantityController.text);
          }, isloading: provider.isLoading == true ? true : false),
        ],
      ),
    );
  }
}

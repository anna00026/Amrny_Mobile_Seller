import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/app_string_service.dart';
import 'package:amrny_seller/services/withdraw_service.dart';
import 'package:amrny_seller/utils/common_helper.dart';
import 'package:amrny_seller/utils/constant_colors.dart';
import 'package:amrny_seller/utils/constant_styles.dart';
import 'package:amrny_seller/utils/custom_input.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/profile/components/textarea_field.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<WithdrawService>(context, listen: false).fetchGatewayList();

    Provider.of<WithdrawService>(context, listen: false)
        .getMinMaxAmount(context);

    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Withdraw', context, () {
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: Listener(
            onPointerDown: (_) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: SingleChildScrollView(
              physics: physicsCommon,
              child: Consumer<AppStringService>(
                builder: (context, ln, child) => Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 10),
                    child: Consumer<WithdrawService>(
                      builder: (context, wProvider, child) => Column(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // dropdown ======>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper()
                                    .labelCommon(ln.getString("Gateway")),
                                wProvider.paymentDropdownList.isNotEmpty
                                    ? Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: cc.greyFive),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            // menuMaxHeight: 200,
                                            // isExpanded: true,
                                            value: wProvider.selectedPayment,
                                            icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: cc.greyFour),
                                            iconSize: 26,
                                            elevation: 17,
                                            style:
                                                TextStyle(color: cc.greyFour),
                                            onChanged: (newValue) {
                                              wProvider
                                                  .setgatewayValue(newValue);

                                              //setting the id of selected value
                                              wProvider.setSelectedgatewayId(
                                                  wProvider
                                                          .paymentDropdownIndexList[
                                                      wProvider
                                                          .paymentDropdownList
                                                          .indexOf(newValue!)]);
                                            },
                                            items: wProvider.paymentDropdownList
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                  asProvider.getString(value),
                                                  style: TextStyle(
                                                      color: cc.greyPrimary
                                                          .withOpacity(.8)),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          OthersHelper()
                                              .showLoading(cc.primaryColor)
                                        ],
                                      ),
                              ],
                            ),

                            sizedBoxCustom(20),
                            CommonHelper().labelCommon(ln.getString("Amount")),
                            CustomInput(
                              controller: amountController,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln.getString('Please enter an amount');
                                }
                                return null;
                              },
                              hintText: ln.getString("Amount"),
                              isNumberField: true,
                              // icon: 'assets/icons/user.png',
                              paddingHorizontal: 18,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            CommonHelper()
                                .labelCommon(ln.getString("Payment details")),

                            TextareaField(
                              hintText: ln.getString(
                                  'Please indicate your payment account'),
                              notesController: noteController,
                            ),

                            sizedBoxCustom(20),
                            Text(
                              ln.getString(
                                      'You can make a request only if your remaining balance in a range set by the site admin. Like admin set minimum request amount') +
                                  ' ${wProvider.minAmount} ${ln.getString("and maximum request amount")} ${wProvider.maxAmount}. ${ln.getString("then you can request a payment between")} ${wProvider.minAmount} ${ln.getString("to")} ${wProvider.maxAmount}.',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13, height: 1.4),
                            ),

                            //Save button =========>

                            const SizedBox(
                              height: 30,
                            ),

                            CommonHelper().buttonPrimary(
                                ln.getString('Withdraw'), () {
                              if (noteController.text.isEmpty) {
                                OthersHelper().showToast(
                                    ln.getString('Please enter a note'),
                                    Colors.black);
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                if (wProvider.isloading == false) {
                                  wProvider.withdrawMoney(amountController.text,
                                      noteController.text, context);
                                }
                              }
                            },
                                isloading:
                                    wProvider.isloading == false ? false : true)
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

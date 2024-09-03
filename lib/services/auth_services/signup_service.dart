import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/dropdowns_services/area_dropdown_service.dart';
import 'package:amrny_seller/services/dropdowns_services/country_dropdown_service.dart';
import 'package:amrny_seller/services/dropdowns_services/state_dropdown_services.dart';
import 'package:amrny_seller/utils/others_helper.dart';

import '../../utils/constant_colors.dart';
import '../../view/auth/signup/components/email_verify_page.dart';
import '../common_service.dart';
import 'email_verify_service.dart';

class SignupService with ChangeNotifier {
  bool isloading = false;

  String phoneNumber = '0';
  String countryCode = 'BD';

  setPhone(value) {
    phoneNumber = value;
    notifyListeners();
  }

  setCountryCode(code) {
    countryCode = code;
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future signup(
    String fullName,
    String userName,
    String email,
    String phoneNumber,
    String password,
    BuildContext context,
  ) async {
    var connection = await checkConnection();

    var selectedCountryId =
        Provider.of<CountryDropdownService>(context, listen: false)
            .selectedCountryId;
    var selectedStateId =
        Provider.of<StateDropdownService>(context, listen: false)
            .selectedStateId;
    var selectedAreaId =
        Provider.of<AreaDropdownService>(context, listen: false).selectedAreaId;
    if (connection) {
      setLoadingTrue();
      var data = jsonEncode({
        'name': fullName,
        'username': userName,
        'email': email,
        'country_id': selectedCountryId,
        'country_code': countryCode,
        'service_city': selectedStateId,
        'service_area': selectedAreaId,
        'phone': phoneNumber,
        'password': password,
        'terms_conditions': 1,
        'user_type': 0, //0=seller, 1=buyer
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      print(data);
      var response = await http.post(Uri.parse('$baseApi/register'),
          body: data, headers: header);

      if (response.statusCode == 201) {
        OthersHelper().showToast(
            "Registration successful", ConstantColors().successColor);

        String token = jsonDecode(response.body)['token'];
        int userId = jsonDecode(response.body)['users']['id'];

        //Send otp
        var isOtepSent =
            await Provider.of<EmailVerifyService>(context, listen: false)
                .sendOtpForEmailValidation(email, context, token);
        setLoadingFalse();
        if (isOtepSent) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => EmailVerifyPage(
                email: email,
                pass: password,
                token: token,
                userId: userId,
                state: selectedStateId,
                countryId: selectedCountryId,
              ),
            ),
          ).then((value) {});
        } else {
          OthersHelper().showToast('Otp send failed', Colors.black);
        }

        return true;
      } else {
        //Sign up unsuccessful ==========>
        print(response.body);

        if (jsonDecode(response.body).containsKey('errors')) {
          showError(jsonDecode(response.body)['errors']);
        } else {
          OthersHelper()
              .showToast(jsonDecode(response.body)['message'], Colors.black);
        }

        setLoadingFalse();
        return false;
      }
    } else {
      //internet connection off
      return false;
    }
  }

  showError(error) {
    if (error.containsKey('email')) {
      OthersHelper().showToast(error['email'][0], Colors.black);
    } else if (error.containsKey('username')) {
      OthersHelper().showToast(error['username'][0], Colors.black);
    } else if (error.containsKey('phone')) {
      OthersHelper().showToast(error['phone'][0], Colors.black);
    } else if (error.containsKey('password')) {
      OthersHelper().showToast(error['password'][0], Colors.black);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
  }
}

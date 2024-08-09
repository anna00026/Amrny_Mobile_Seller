import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/helper/extension/string_extension.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/others_helper.dart';

class ChangePassService with ChangeNotifier {
  bool isloading = false;

  String? otpNumber;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  changePassword(
      currentPass, newPass, repeatNewPass, BuildContext context) async {
    if (newPass != repeatNewPass) {
      OthersHelper().showToast(
          'Make sure you repeated new password correctly', Colors.black);
    } else {
      //check internet connection
      var connection = await checkConnection();
      if (connection) {
        setLoadingTrue();
        // if (baseApi.toLowerCase().contains(siteLink)) {
        //   await Future.delayed(const Duration(seconds: 2));
        //   "This feature is turned off for demo app".showToast();
        //   setLoadingFalse();
        //   return false;
        // }
        //internet connection is on
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        var header = {
          //if header type is application/json then the data should be in jsonEncode method
          "Accept": "application/json",
          // "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        };
        var data = {'current_password': currentPass, 'new_password': newPass};

        setLoadingTrue();
        if (baseApi == 'https://bytesed.com/laravel/qixer/api/v1') {
          await Future.delayed(const Duration(seconds: 1));
          OthersHelper().showToast(
              'This feature is turned off in test mode', Colors.black);
          setLoadingFalse();
          return;
        }

        try {
          var response = await http.post(
              Uri.parse('$baseApi/user/change-password'),
              headers: header,
              body: data);
          print(response.statusCode);
          if (response.statusCode == 201) {
            OthersHelper().showToast(
                "Password changed successfully", ConstantColors().primaryColor);
            setLoadingFalse();

            prefs.setString("pass", newPass);

            Navigator.pop(context);
          } else {
            print(response.body);
            try {
              OthersHelper().showToast(
                  jsonDecode(response.body)['message'], Colors.black);
            } catch (e) {}
            setLoadingFalse();
          }
        } catch (e) {
          setLoadingFalse();
          print(e);

          OthersHelper().showToast('Something went wrong', Colors.black);
        }
      }
    }
  }
}

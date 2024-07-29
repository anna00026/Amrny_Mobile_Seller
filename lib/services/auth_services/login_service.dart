// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/day_schedule_service/schedule_service.dart';
import 'package:qixer_seller/services/push_notification_service.dart';
import 'package:qixer_seller/services/subscription_service.dart';
import 'package:qixer_seller/view/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant_colors.dart';
import '../../utils/others_helper.dart';
import '../../view/auth/signup/components/email_verify_page.dart';
import '../common_service.dart';
import 'email_verify_service.dart';

class LoginService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> login(email, pass, BuildContext context, bool keepLoggedIn,
      {isFromLoginPage = true}) async {
    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();
      var data = jsonEncode({
        'email': email,
        'password': pass,
        'user_type': 0, //0=seller, 1=buyer
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(Uri.parse('$baseApi/login'),
          body: data, headers: header);
      debugPrint(response.body.toString());
      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        debugPrint(responseData.toString());
        if (responseData["users"]?["account_status"] is Map) {
          if (isFromLoginPage) {
            OthersHelper().showToast(
                "Invalid Email or Password", ConstantColors().warningColor);
          }
          setLoadingFalse();
          return false;
        }
        if (isFromLoginPage) {
          OthersHelper()
              .showToast("Login successful", ConstantColors().successColor);
        }
        setLoadingFalse();

        String token = jsonDecode(response.body)['token'];
        int userId = jsonDecode(response.body)['users']['id'];
        String state = jsonDecode(response.body)['users']['state'].toString();
        String country_id =
            jsonDecode(response.body)['users']['country_id'].toString();
        if (responseData["users"]["email_verified"].toString() == "0") {
          var isOtepSent =
              await Provider.of<EmailVerifyService>(context, listen: false)
                  .sendOtpForEmailValidation(
                      responseData["users"]["email"], context, token);

          if (isOtepSent) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => EmailVerifyPage(
                  email: responseData["users"]["email"].toString(),
                  pass: pass,
                  token: token,
                  userId: userId,
                  state: state,
                  countryId: country_id,
                ),
              ),
            );
          } else {
            OthersHelper().showToast("Otp send failed", Colors.black);
          }
          setLoadingFalse();
          return false;
        }

        if (keepLoggedIn) {
          saveDetails(email, pass, token, userId, state, country_id);
        } else {
          setKeepLoggedInFalseSaveToken(token);
        }

        print(response.body);
        //start pusher
        //============>
        await Provider.of<PushNotificationService>(context, listen: false)
            .fetchPusherCredential();
        Provider.of<SubscriptionService>(context, listen: false)
            .fetchAdminCommissionType(context);
        Provider.of<ScheduleService>(context, listen: false)
            .fetchSellerSchedules();
        var pusherInstance =
            Provider.of<PushNotificationService>(context, listen: false)
                .pusherInstance;

        //start stripe
        //============>
        // var publishableKey = await StripeService().getStripeKey();
        // Stripe.publishableKey = publishableKey;
        // Stripe.instance.applySettings();

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Homepage(),
          ),
        );

        return true;
      } else {
        print(response.body);
        print(data);
        print('$baseApi/login');
        //Login unsuccessful ==========>
        if (isFromLoginPage) {
          OthersHelper().showToast(
              "Invalid Email or Password", ConstantColors().warningColor);
        }
        setLoadingFalse();
        return false;
      }
    } else {
      //internet off
      return false;
    }
  }

  saveDetails(
      String email, pass, String token, int userId, state, country_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setBool('keepLoggedIn', true);
    prefs.setString("pass", pass);
    prefs.setString("token", token);
    prefs.setInt('userId', userId);
    prefs.setString("state", state.toString());
    prefs.setString("countryId", country_id.toString());
    print('token is $token');
    print('user id is $userId');
    print('user state id is $state');
  }

  setKeepLoggedInFalseSaveToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('keepLoggedIn', false);
    prefs.setString("token", token);
  }
}

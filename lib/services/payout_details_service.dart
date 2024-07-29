// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qixer_seller/model/payout_details_model.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'common_service.dart';

class PayoutDetailsService with ChangeNotifier {
  var payoutDetails;

  var receipt;

  bool isloading = true;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchPayoutDetails(payoutId) async {
    setLoadingTrue();
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response = await http.post(
          Uri.parse('$baseApi/seller/payment-history/details/$payoutId'),
          headers: header);

      setLoadingFalse();

      if (response.statusCode == 201) {
        var data = PayoutDetailsModel.fromJson(jsonDecode(response.body));

        payoutDetails = data;
        var r = jsonDecode(response.body)['payout_details']['payment_receipt'];

        print(r);
        if (r is List) {
          receipt = null;
        } else {
          receipt = r;
        }

        notifyListeners();
      } else {
        //Something went wrong
        print('error fetching payout details ' + response.body);
        payoutDetails = 'error';
        notifyListeners();
      }
    }
  }
}

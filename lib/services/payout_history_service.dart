// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer_seller/model/payout_history_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayoutHistoryService with ChangeNotifier {
  var payoutHistoryList = [];

  late int totalPages;
  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  makePayoutHistoryListEmpty() {
    payoutHistoryList = [];
    currentPage = 1;
    notifyListeners();
  }

  fetchPayoutHistory(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      payoutHistoryList = [];

      notifyListeners();

      Provider.of<PayoutHistoryService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

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
      var response = await http.post(
          Uri.parse("$baseApi/seller/payment-history?page=$currentPage"),
          headers: header);

      if (response.statusCode == 201 &&
          jsonDecode(response.body)['payment_history']['data'].isNotEmpty) {
        var data = PayoutHistoryModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.paymentHistory.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          //make the list empty first so that existing data doesn't stay
          setServiceList(data.paymentHistory.data, false);
        } else {
          print('add new data');

          //else add new data
          setServiceList(data.paymentHistory.data, true);
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print(response.body);
        return false;
      }
    }
  }

  setServiceList(dataList, bool addnewData) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      payoutHistoryList = [];
      notifyListeners();
    }

    for (int i = 0; i < dataList.length; i++) {
      payoutHistoryList.add(dataList[i]);
    }

    notifyListeners();
  }
}

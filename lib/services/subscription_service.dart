import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/model/subscription_history_model.dart';
import 'package:qixer_seller/model/subscription_info_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/services/wallet_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/subscription/components/reniew_subscription_success_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubscriptionService with ChangeNotifier {
  var subsData;
  bool showSubscription = false;

  List subsHistoryList = [];

  bool hasSubsHistory = true;
  bool isloading = false;

  bool renewLoading = false;

  setLoadingStatus(bool status) {
    isloading = status;
    notifyListeners();
  }

  setRenewLoading(value) {
    if (value == renewLoading) {
      return;
    }
    renewLoading = value;
    notifyListeners();
  }

  Future<bool> fetchCurrentSubscriptionData(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http
        .get(Uri.parse('$baseApi/seller/subscription/info'), headers: header);

    setLoadingStatus(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = SubscriptionInfoModel.fromJson(jsonDecode(response.body));
      subsData = data.subscriptionInfo;
      notifyListeners();
      return true;
    } else {
      print(
          'Error fetching subscription data' + response.statusCode.toString());

      return false;
    }
  }

  // Fetch subscription history
  fetchAdminCommissionType(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return;

    if (subsHistoryList.isNotEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/admin-commission-type'),
        headers: header);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      showSubscription = data['admin_commission'] == "subscription";
      notifyListeners();
    } else {
      print('Error fetching subscription history----------------------------' +
          response.body);

      hasSubsHistory = false;
      notifyListeners();
    }
  }

  fetchSubscriptionHistory(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return;

    if (subsHistoryList.isNotEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
        Uri.parse('$baseApi/seller/subscription/history'),
        headers: header);

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 201 &&
        decodedData['subscription_history'].isNotEmpty) {
      final data = SubscriptionHistoryModel.fromJson(jsonDecode(response.body));
      subsHistoryList = data.subscriptionHistory;
      notifyListeners();
    } else {
      print('Error fetching subscription history' + response.body);

      hasSubsHistory = false;
      notifyListeners();
    }
  }

  // Reniew subscription
  // ==============>
  reniewSubscription(
    BuildContext context,
  ) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data =
        jsonEncode({'subscription_id': subsData.subscriptionId.toString()});
    setRenewLoading(true);
    try {
      var response = await http.post(
          Uri.parse('$baseApi/seller/wallet/renew-subscription'),
          headers: header,
          body: data);
      print('$baseApi/seller/wallet/renew-subscription');
      print(data);
      print(header);

      final decodedData = jsonDecode(response.body);

      // Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

      print(response.body);

      if (response.statusCode == 200) {
        //fetch subscription data,

        await fetchCurrentSubscriptionData(context);

        Navigator.pop(context);

//fetch wallet balance
        Provider.of<WalletService>(context, listen: false)
            .fetchWalletBalance(context);

        Provider.of<WalletService>(context, listen: false)
            .fetchWalletHistory(context);

        OthersHelper()
            .showToast('Subscription renewed successfully', Colors.black);

        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                const ReniewSubscriptionSuccessPage(),
          ),
        );
      } else {
        print('Error reniew subscription' + response.body);

        if (decodedData.containsKey('msg')) {
          OthersHelper().showToast(decodedData['msg'], Colors.black);
        } else {
          OthersHelper().showToast('Something went wrong', Colors.black);
        }
      }
    } finally {
      setRenewLoading(false);
    }
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentGatewayListService with ChangeNotifier {
  var paymentDropdownList = [];
  var paymentDropdownIndexList = [];
  var selectedPayment;
  var selectedPaymentId;

  var selectedMethodName;

  bool? isTestMode;
  var publicKey;
  var secretKey;

  var billPlzCollectionName;
  var paytabProfileId;

  var squareLocationId;

  var zitopayUserName;

  setSelectedMethodName(newName) {
    selectedMethodName = newName;
    notifyListeners();
  }

  Future fetchGatewayList() async {
    //if payment list already loaded, then don't load again
    if (paymentDropdownList.isNotEmpty) {
      return;
    }

    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(
          Uri.parse('$baseApi/user/payment-gateway-list'),
          headers: header);

      if (response.statusCode == 201) {
        // var gatewayList = jsonDecode(response.body)['gateway_list'];
        // for (int i = 0; i < gatewayList.length; i++) {
        //   paymentDropdownList.add(removeUnderscore(gatewayList[i]['name']));
        //   paymentDropdownIndexList.add(gatewayList[i]['name']);
        // }
        // selectedPayment = removeUnderscore(gatewayList[0]['name']);
        // selectedPaymentId = gatewayList[0]['name'];
        paymentDropdownList = jsonDecode(response.body)['gateway_list'];
        paymentDropdownList
            .removeWhere((element) => element['name'] == "cash_on_delivery");
        // add wallet payment
        paymentDropdownList.add({
          "name": "wallet",
          "logo_link": "https://i.postimg.cc/y8pMmqF4/wallet.png"
        });

        notifyListeners();
      } else {
        //something went wrong
        print('payment gateway list fetching error' + response.body);
      }
    } else {
      //internet off
      return false;
    }
  }

  //set clientId or secretId
  //==================>
  setKey(String methodName, int index) {
    print('selected method $methodName');
    switch (methodName) {
      case 'paypal':
        publicKey = paymentDropdownList[index]['client_id'];
        secretKey = paymentDropdownList[index]['secret_id'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        print('client id is $publicKey');
        print('secret id is $secretKey');
        notifyListeners();
        break;

      case 'cashfree':
        publicKey = paymentDropdownList[index]['app_id'];
        secretKey = paymentDropdownList[index]['secret_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        print('client id is $publicKey');
        print('secret id is $secretKey');
        notifyListeners();
        break;

      case 'flutterwave':
        publicKey = paymentDropdownList[index]['public_key'];
        secretKey = paymentDropdownList[index]['secret_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'instamojo':
        publicKey = paymentDropdownList[index]['client_id'];
        secretKey = paymentDropdownList[index]['client_secret'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'marcadopago':
        publicKey = paymentDropdownList[index]['client_id'];
        secretKey = paymentDropdownList[index]['client_secret'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'midtrans':
        publicKey = paymentDropdownList[index]['merchant_id'];
        secretKey = paymentDropdownList[index]['server_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'mollie':
        publicKey = paymentDropdownList[index]['public_key'];
        secretKey = '';
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'payfast':
        publicKey = paymentDropdownList[index]['merchant_id'];
        secretKey = paymentDropdownList[index]['merchant_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'paystack':
        publicKey = paymentDropdownList[index]['public_key'];
        secretKey = paymentDropdownList[index]['secret_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'paytm':
        publicKey = paymentDropdownList[index]['merchant_key'];
        secretKey = paymentDropdownList[index]['merchant_mid'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'razorpay':
        publicKey = paymentDropdownList[index]['api_key'];
        secretKey = paymentDropdownList[index]['api_secret'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'stripe':
        publicKey = paymentDropdownList[index]['public_key'];
        secretKey = paymentDropdownList[index]['secret_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'cinetpay':
        publicKey = paymentDropdownList[index]['site_id'];
        secretKey = paymentDropdownList[index]['app_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'paytabs':
        paytabProfileId = paymentDropdownList[index]['profile_id'];
        secretKey = paymentDropdownList[index]['server_key'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'squareup':
        squareLocationId = paymentDropdownList[index]['location_id'];
        secretKey = paymentDropdownList[index]['access_token'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'billplz':
        publicKey = paymentDropdownList[index]['key'];
        secretKey = paymentDropdownList[index]['xsignature'];
        billPlzCollectionName = paymentDropdownList[index]['collection_name'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'zitopay':
        zitopayUserName = paymentDropdownList[index]['username'];
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'manual_payment':
        publicKey = '';
        secretKey = '';
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      case 'cash_on_delivery':
        publicKey = '';
        secretKey = '';
        isTestMode = paymentDropdownList[index]['test_mode'];
        notifyListeners();
        break;

      //switch end
    }
  }
}

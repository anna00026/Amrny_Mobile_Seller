// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/model/order_details_model.dart';
import 'package:qixer_seller/model/order_extra_model.dart';
import 'package:qixer_seller/services/orders_service.dart';
import 'package:qixer_seller/services/push_notification_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'common_service.dart';

class OrderDetailsService with ChangeNotifier {
  var orderDetails;
  var orderStatus;

  var orderedServiceTitle;

  List orderExtra = [];

  bool isLoading = true;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  Future<bool> fetchOrderDetails(orderId, BuildContext context) async {
    print('order id $orderId');

    setLoadingStatus(true);
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
    if (!connection) return false;
    //if connection is ok
    var response = await http
        .post(Uri.parse('$baseApi/seller/my-orders/$orderId'), headers: header);

    setLoadingStatus(false);

    if (response.statusCode == 201) {
      var data = OrderDetailsModel.fromJson(jsonDecode(response.body));
      print(response.body);
      orderDetails = data.orderInfo;
      print('$baseApi/seller/my-orders/$orderId');
      orderedServiceTitle =
          jsonDecode(response.body)['orderInfo']?['service']?['title'] ?? '';

      var status = data.orderInfo.status;
      orderStatus = getOrderStatus(status ?? -1);

      await Provider.of<OrderDetailsService>(context, listen: false)
          .fetchOrderExtraList(orderId);

      Provider.of<OrdersService>(context, listen: false)
          .fetchDeclineHistory(context, orderId: orderId);

      return true;
    } else {
      //Something went wrong
      print('error fetching order details ' + response.body);
      orderDetails = 'error';
      notifyListeners();
      return false;
    }
  }

  //Add order extra
  addOrderExtra(BuildContext context,
      {required orderId,
      required title,
      required price,
      required quantity}) async {
    //check internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //internet off
      OthersHelper()
          .showToast("Please turn on your internet connection", Colors.black);
      return false;
    } else {
      //get user id
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      //internet connection is on
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      var data = jsonEncode({
        'order_id': orderId,
        'title': title,
        'price': price,
        'quantity': quantity
      });

      print(data);
      setLoadingStatus(true);

      var response = await http.post(
          Uri.parse('$baseApi/seller/order/extra-service/add'),
          headers: header,
          body: data);

      final responseDecoded = jsonDecode(response.body);

      if (response.statusCode == 201 &&
          responseDecoded.containsKey("extra_service")) {
        await Provider.of<OrderDetailsService>(context, listen: false)
            .fetchOrderDetails(orderId, context);

        setLoadingStatus(false);
        Provider.of<PushNotificationService>(context, listen: false)
            .sendNotificationToBuyer(context,
                buyerId: orderDetails.buyerId,
                title:
                    "${orderDetails.name} ${asProvider.getString("has requested for extra service.")}",
                body: asProvider.getString("Order id") + ": $orderId");

        OthersHelper().showToast('Extra added', Colors.black);

        Navigator.pop(context);
      } else {
        setLoadingStatus(false);
        print(response.body);
        OthersHelper()
            .showToast(jsonDecode(response.body)['message'], Colors.black);
      }
    }
  }

  //fetch order extra list
  Future<bool> fetchOrderExtraList(orderId) async {
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
    if (!connection) return false;
    //if connection is ok
    var response = await http.get(
        Uri.parse('$baseApi/user/order/extra-service/list/$orderId'),
        headers: header);

    final decodedData = jsonDecode(response.body);

    print(response.body);

    if (response.statusCode == 201 &&
        decodedData.containsKey('extra_service_list')) {
      var data = OrderExtraModel.fromJson(decodedData);

      orderExtra = data.extraServiceList;

      notifyListeners();

      return true;
    } else {
      print('error fetching order extra ${response.body}');
      return false;
    }
  }

  //================>
  //=========>
  bool deleteLoading = false;
  setDeleteLoadingStatus(bool status) {
    deleteLoading = status;
    notifyListeners();
  }

  deleteOrderExtra(BuildContext context,
      {required extraId, required orderId}) async {
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (connection) {
      setDeleteLoadingStatus(true);

      var data = jsonEncode({'id': extraId});

      var response = await http.post(
          Uri.parse('$baseApi/seller/order/extra-service/delete'),
          headers: header,
          body: data);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        await Provider.of<OrderDetailsService>(context, listen: false)
            .fetchOrderDetails(orderId, context);

        setDeleteLoadingStatus(false);

        Navigator.pop(context);
        OthersHelper().showToast('Successfully deleted', Colors.black);
        notifyListeners();
      } else {
        setDeleteLoadingStatus(false);
        Navigator.pop(context);
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }

  //==========>

  getOrderStatus(int status) {
    if (status == 0) {
      return 'Pending';
    } else if (status == 1) {
      return 'Active';
    } else if (status == 2) {
      return "Completed";
    } else if (status == 3) {
      return "Delivered";
    } else if (status == 4) {
      return 'Cancelled';
    } else {
      return 'Unknown';
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/chart_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartService with ChangeNotifier {
  List chartDataListMap = [];
  var constValue = 0.0;
  num maxValue = 1.0;

  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future fetchChartData(
    BuildContext context,
  ) async {
    if (chartDataListMap.isNotEmpty) {
      return;
      //if data already loaded. no need to load again
    }
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      setLoadingTrue();

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };

      var response = await http.post(Uri.parse('$baseApi/seller/chart-data'),
          headers: header);

      setLoadingFalse();
      print(response.body);

      if (response.statusCode == 201) {
        var c = ChartModel.fromJson(jsonDecode(response.body));

        var maxSold = await findMax(c.chartData);
        maxValue = maxSold;
        constValue = maxSold / 6;

        calculateSaleWithinSix(constValue, c.chartData);

        //calculate total sale and shrink it within 0-6 , so that we can show it
        //in our small graph

        return true;
      } else {
        print("error fetching chart data " + response.body);
        //Login unsuccessful ==========>
      }
    } else {
      //internet off
      return false;
    }
  }

  calculateSaleWithinSix(constValue, dataList) {
    for (int i = 0; i < dataList.length; i++) {
      var newData = dataList[i].totalOrder / constValue;
      if (newData < 0 || newData.toString() == 'NaN') {
        newData = 0.0;
      }
      chartDataListMap
          .add({'monthName': dataList[i].monthName, 'orders': newData});
    }
    notifyListeners();
  }

  findMax(data) {
    var largestGeekValue = data[0].totalOrder;
    var smallestGeekValue = data[0].totalOrder;
    for (var i = 0; i < data.length; i++) {
      // Checking for largest value in the list
      if (data[i].totalOrder > largestGeekValue) {
        largestGeekValue = data[i].totalOrder;
      }

      // Checking for smallest value in the list
      if (data[i].totalOrder < smallestGeekValue) {
        smallestGeekValue = data[i].totalOrder;
      }
    }
    return largestGeekValue;
  }
}

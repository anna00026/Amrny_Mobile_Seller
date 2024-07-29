import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/auth_services/logout_service.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeactivateAccountService with ChangeNotifier {
  bool isloading = false;
  //deactivateReason dropdown
  var deactivateReasonDropdownList = ['Vacation', 'Personal reason'];
  var deactivateReasonDropdownIndexList = ['Vacation', 'Vacation'];
  var selecteddeactivateReason = 'Vacation';
  var selecteddeactivateReasonId = 'Vacation';

  setdeactivateReasonValue(value) {
    selecteddeactivateReason = value;
    notifyListeners();
  }

  setSelecteddeactivateReasonId(value) {
    selecteddeactivateReasonId = value;
    notifyListeners();
  }

  deactivate(BuildContext context, desc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({
      'reason': selecteddeactivateReasonId,
      'description': desc,
    });

    var connection = await checkConnection();
    if (connection) {
      isloading = true;
      notifyListeners();
      //if connection is ok
      var response = await http.post(
          Uri.parse('$baseApi/seller/profile/deactivate'),
          headers: header,
          body: data);
      isloading = false;
      notifyListeners();
      if (response.statusCode == 201) {
        OthersHelper()
            .showToast('Account deactivated, Logging out', Colors.black);
        Provider.of<LogoutService>(context, listen: false).logout(context);
      } else {
        print('deactivate account error ' + response.body);
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }
}

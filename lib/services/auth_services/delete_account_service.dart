import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/others_helper.dart';
import '../../view/auth/login/login.dart';
import '../common_service.dart';
import '../profile_service.dart';

class DeleteAccountService with ChangeNotifier {
  bool isloading = false;
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

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  deleteAccount(BuildContext context, password, description) async {
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var data = jsonEncode({
        'reason': selecteddeactivateReasonId,
        'description': description,
        'password': password,
      });

      var header = {
        "Authorization": "Bearer $token",
      };

      setLoadingTrue();
      if (baseApi == 'https://bytesed.com/laravel/amrny/api/v1') {
        await Future.delayed(const Duration(seconds: 1));
        OthersHelper()
            .showToast('This feature is turned off in test mode', Colors.black);
        setLoadingFalse();
        return;
      }
      var response = await http.post(
        Uri.parse(
            '$baseApi/account-delete?reason=$selecteddeactivateReasonId&description=$description&password=$password'),
        headers: header,
      );
      if (response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            OthersHelper().showToast(data['message'], Colors.black);
          }
        } catch (e) {}

        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (route) => false,
        );

        // clear profile data =====>
        Provider.of<ProfileService>(context, listen: false)
            .setEverythingToDefault();

        clear();
        setLoadingFalse();
      } else {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            OthersHelper().showToast(data['message'], Colors.black);
            setLoadingFalse();
            return;
          }
        } catch (e) {}
        print(response.body);
        OthersHelper().showToast('Something went wrong', Colors.black);
        setLoadingFalse();
      }
    }
  }

  //clear saved email, pass and token
  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

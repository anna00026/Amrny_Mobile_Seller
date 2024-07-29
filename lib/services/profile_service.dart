import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/profile_model.dart';
import 'common_service.dart';

class ProfileService with ChangeNotifier {
  bool isloading = false;

  var profileDetails;
  var profileImage;

  List ordersList = [];

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setEverythingToDefault() {
    profileDetails = null;
    profileImage = null;
    ordersList = [];
    notifyListeners();
  }

  getProfileDetails({bool isFromProfileupdatePage = false}) async {
    if (isFromProfileupdatePage == true) {
      //if from update profile page then load it anyway
      print('is from profile update page true');
      setEverythingToDefault();
      fetchData();
    } else {
      //not from profile page. check if data already loaded
      if (profileDetails == null) {
        fetchData();
      } else {
        print('profile data already loaded');
      }
    }
  }

  fetchData() async {
    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      setLoadingTrue();

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };

      var response = await http.post(Uri.parse('$baseApi/seller/profile'),
          headers: header);

      if (response.statusCode == 201) {
        var data = ProfileModel.fromJson(jsonDecode(response.body));
        profileDetails = data.userDetails;
        profileImage = data.profileImage;

        notifyListeners();
      } else {
        print('profile fetch error ' + response.body);
        profileDetails == 'error';
        setLoadingFalse();
        OthersHelper().showToast('Something went wrong', Colors.black);
        notifyListeners();
      }
    }
  }
}

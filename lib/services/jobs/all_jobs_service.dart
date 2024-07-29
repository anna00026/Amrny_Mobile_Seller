import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/all_job_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllJobsService with ChangeNotifier {
  var allJobsList = [];
  List imageList = [];
  bool isLoading = true;

  late int totalPages;

  int currentPage = 1;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  fetchAllJobs(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      allJobsList = [];
      notifyListeners();

      setCurrentPage(1);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        // "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setLoadingStatus(true);

      var response = await http.get(
          Uri.parse("$baseApi/job/all?page=$currentPage"),
          headers: header);

      setLoadingStatus(false);

      final decodedData = jsonDecode(response.body);

      print(response.body);

      if (response.statusCode == 201 &&
          decodedData['all_jobs']['data'].isNotEmpty) {
        var data = AllJobModel.fromJson(decodedData);

        setTotalPage(data.allJobs?.lastPage ?? 1);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          // setServiceList(data.allJobs?.data??[], decodedData['image_url'], false);
          allJobsList = data.allJobs?.data ?? [];
        } else {
          print('add new data');
          data.allJobs?.data?.forEach((element) {
            allJobsList.add(element);
          });
          //else add new data
          // setServiceList(data.allJobs?.data??[], decodedData['image_url'], true);
        }

        notifyListeners();
        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print('error fetching new jobs ${response.body}');
        return false;
      }
    }
  }

  setServiceList(dataList, images, bool addnewData) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      allJobsList = [];
      imageList = [];
      notifyListeners();
    }

    for (int i = 0; i < dataList.length; i++) {
      allJobsList.add(dataList[i]);
    }

    for (int i = 0; i < images.length; i++) {
      String? serviceImage;

      if (i == 0) {
        //api giving an unnecessary null for first one, so skip it
        continue;
      } else {
        serviceImage = images[i]['img_url'] ?? loadingImageUrl;
      }

      imageList.add(serviceImage);
    }

    notifyListeners();
  }
}

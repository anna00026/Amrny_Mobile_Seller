import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/all_job_model.dart';
import 'package:qixer_seller/model/employee_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesService with ChangeNotifier {
  var allEmployeesList = [];
  bool isLoading = true;

  late int totalPages;

  int currentPage = 1;
  var employeeData;
  var employeeImage;


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

  fetchEmployees(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      allEmployeesList = [];
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
          Uri.parse("$baseApi/seller/employees/list?page=$currentPage"),
          headers: header);

      setLoadingStatus(false);

      final decodedData = jsonDecode(response.body);

      print(response.body);

      if (response.statusCode == 201 &&
          decodedData['employee_lists']['data'].isNotEmpty) {
        var data = EmployeeModel.fromJson(decodedData);

        // setTotalPage(data.allJobs?.lastPage ?? 1);

        // if (isrefresh) {
        //   print('refresh true');
        //   //if refreshed, then remove all service from list and insert new data
        //   // setServiceList(data.allJobs?.data??[], decodedData['image_url'], false);
        //   allEmployeesList = data.allJobs?.data ?? [];
        // } else {
        //   print('add new data');
        //   data.allJobs?.data?.forEach((element) {
        //     allEmployeesList.add(element);
        //   });
        //   //else add new data
        //   // setServiceList(data.allJobs?.data??[], decodedData['image_url'], true);
        // }

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

  fetchEmployeeData(int employeeId) async {
    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      setLoadingStatus(true);

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };
      Map<String, dynamic> data = {
        'id': employeeId,
      };
      var response = await http.post(Uri.parse('$baseApi/seller/employee'),
          body: data, headers: header);

      if (response.statusCode == 201) {
        // var data = Employee.fromJson(jsonDecode(response.body));
        // profileDetails = data.userDetails;
        // profileImage = data.profileImage;

        notifyListeners();
      } else {
        // print('profile fetch error ' + response.body);
        // profileDetails == 'error';
        // setLoadingFalse();
        // OthersHelper().showToast('Something went wrong', Colors.black);
        notifyListeners();
      }
    }
  }
}
